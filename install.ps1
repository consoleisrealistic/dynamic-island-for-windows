# Island installer
# Usage:  irm https://raw.githubusercontent.com/consoleisrealistic/dynamic-island-for-windows/main/install.ps1 | iex
#
# What it does: reads version.json from this repository, downloads IslandSetup.exe from the matching
# official GitHub release, checks its SHA-256 (and its digital signature once releases are signed),
# then runs the installer. Nothing is executed unless every check passes.

function Install-Island {
    [CmdletBinding()]
    param(
        [switch]$Silent
    )

    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'
    $Repo = 'consoleisrealistic/dynamic-island-for-windows'
    $Feed = "https://raw.githubusercontent.com/$Repo/main/version.json"
    $Publisher = ''
    $MaxBytes = 300MB

    function Say([string]$Text, [string]$Color = 'Gray') { Write-Host "  $Text" -ForegroundColor $Color }
    function Stop-Install([string]$Text) { throw [System.OperationCanceledException]::new($Text) }

    try {
    Write-Host ''
    Write-Host '  Island installer' -ForegroundColor Cyan
    Write-Host '  A Dynamic Island for Windows' -ForegroundColor DarkGray
    Write-Host ''

    if ($env:OS -ne 'Windows_NT') { Stop-Install 'Island runs on Windows 10 and Windows 11 only.' }
    $os = [Environment]::OSVersion.Version
    if ($os.Major -lt 10 -or ($os.Major -eq 10 -and $os.Build -lt 17763)) { Stop-Install "Windows 10 version 1809 or later is required (this PC is $os)." }
    if (-not [Environment]::Is64BitOperatingSystem) { Stop-Install 'A 64-bit version of Windows is required.' }
    Say "Windows $($os.Major) build $($os.Build), 64-bit" 'DarkGray'

    try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }

    Say 'Checking the latest version...'
    try {
        $info = Invoke-RestMethod -Uri $Feed -UseBasicParsing -TimeoutSec 30 -Headers @{ 'Cache-Control' = 'no-cache' }
    } catch {
        $code = 0
        try { $code = [int]$_.Exception.Response.StatusCode } catch { }
        if ($code -eq 404) { Stop-Install "no release has been published yet. Watch https://github.com/$Repo/releases for the first one." }
        Stop-Install "could not reach GitHub ($($_.Exception.Message)). Check your internet connection and try again."
    }

    $version = [string]$info.version
    if ($version -notmatch '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(-[0-9A-Za-z.-]+)?$') { Stop-Install 'the release information has an invalid version.' }
    $url = [string]$info.download_url
    $expected = "https://github.com/$Repo/releases/download/v$version/IslandSetup.exe"
    if ($url -cne $expected) { Stop-Install 'the download link does not point at an official Island release.' }
    $sha = ([string]$info.sha256).ToLowerInvariant()
    if ($sha -notmatch '^[0-9a-f]{64}$') { Stop-Install 'the release information has no valid SHA-256 checksum.' }
    Say "Latest version: $version" 'Green'

    $dir = Join-Path ([IO.Path]::GetTempPath()) ("island-install-" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $file = Join-Path $dir "IslandSetup-$version.exe"
    try {
        Say 'Downloading IslandSetup.exe...'
        try {
            Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing -TimeoutSec 600 -MaximumRedirection 5
        } catch {
            Stop-Install "the download failed ($($_.Exception.Message))."
        }
        $item = Get-Item -LiteralPath $file
        if ($item.Length -le 0 -or $item.Length -gt $MaxBytes) { Stop-Install 'the downloaded file has an unexpected size.' }
        if ($info.size -and [int64]$info.size -ne $item.Length) { Stop-Install 'the downloaded file size does not match the release.' }
        Say ("Downloaded {0:N1} MB" -f ($item.Length / 1MB)) 'DarkGray'

        Say 'Verifying SHA-256...'
        $actual = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -ne $sha) { Stop-Install "checksum mismatch. Expected $sha, got $actual. The file was deleted." }
        Say 'Checksum matches the official release' 'Green'

        Say 'Checking the digital signature...'
        $sig = Get-AuthenticodeSignature -LiteralPath $file
        if ($Publisher) {
            if ($sig.Status -ne 'Valid') { Stop-Install "the installer signature is $($sig.Status)." }
            if ($sig.SignerCertificate.Subject -notmatch [regex]::Escape("CN=$Publisher")) { Stop-Install 'the installer is signed by an unexpected publisher.' }
            Say "Signed by $Publisher" 'Green'
        } elseif ($sig.Status -eq 'Valid') {
            Say "Signed by $($sig.SignerCertificate.Subject)" 'Green'
        } elseif ($sig.Status -eq 'NotSigned') {
            Say 'This release is not code-signed yet; the SHA-256 checksum above is what proves it is the official file.' 'Yellow'
            Say 'Windows SmartScreen may ask you to confirm. Choose More info, then Run anyway.' 'Yellow'
        } else {
            Stop-Install "the installer signature is $($sig.Status)."
        }

        Unblock-File -LiteralPath $file -ErrorAction SilentlyContinue
        Say 'Starting the installer...'
        $installArgs = @('/CHANNEL=exe')
        if ($Silent) { $installArgs += @('/SILENT', '/SUPPRESSMSGBOXES', '/NORESTART') }
        $p = Start-Process -FilePath $file -ArgumentList $installArgs -PassThru -Wait
        switch ($p.ExitCode) {
            0 { Write-Host ''; Say "Island $version is installed. Find it in the Start menu." 'Green'; Write-Host '' }
            2 { Say 'Setup was cancelled.' 'Yellow' }
            5 { Say 'Setup was cancelled.' 'Yellow' }
            default { Stop-Install "setup ended with code $($p.ExitCode)." }
        }
    } finally {
        Remove-Item -LiteralPath $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
    } catch [System.OperationCanceledException] {
        Write-Host ''
        Write-Host "  Island was not installed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ''
    } catch {
        Write-Host ''
        Write-Host "  Island was not installed: unexpected error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ''
    }
}

Install-Island
