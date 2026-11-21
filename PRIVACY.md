# DeskHalo privacy policy

_Last updated: 16 November 2026_

DeskHalo is a desktop app that runs on your computer. This policy explains what it does with information.

## The short version

- DeskHalo has **no accounts, analytics, telemetry, ads or tracking**.
- Your settings, notes, clipboard history, reminders and other data stay on your PC in `%APPDATA%\island`.
- DeskHalo only connects to the internet for the features listed below, and only when you use them.

## Online features

| Feature | Service | What DeskHalo sends | When |
| --- | --- | --- | --- |
| Synced lyrics | [LRCLIB](https://lrclib.net) | Title, artist and length of the song that is playing | When a new song starts and lyrics are turned on |
| Weather | [Open-Meteo](https://open-meteo.com) | The city you type, or coordinates for it | Every 15 to 180 minutes, as you set it, when weather is on |
| Weather location | [ipapi.co](https://ipapi.co), with [ipwho.is](https://ipwho.is) as a fallback | Your IP address, to estimate your city | When you press *Detect automatically* |
| Meeting Quick Join | [Google Calendar API](https://developers.google.com/calendar) | Requests for your upcoming events, using read-only access you grant | Only after you connect your Google account in Settings › Connect |
| Ask, Translate and the OCR fallback | [Google Gemini API](https://ai.google.dev/gemini-api/terms), using your own API key | The question, text or screenshot area you choose to send, and the conversation it belongs to | Only when you use these features with a key saved in Settings › Ask & Translate |
| Currency conversion | [ExchangeRate-API](https://www.exchangerate-api.com) (open.er-api.com) | A request for current exchange rates | When you convert a currency |
| Speed test | Cloudflare, Hetzner, OVH or Linode public test servers, or a server you add | Test data to measure speed | Only when you start a test |
| AI agent icons | Google and DuckDuckGo favicon services | The website name of each coding agent DeskHalo detects | Once, when icons are first fetched |
| Update checks | [GitHub](https://github.com) | A request for `version.json`, and the installer download if you choose to update | At start-up and every 8 hours, unless you turn it off in Settings › Updates |

Each service receives your IP address as part of the connection and handles it under its own privacy policy.

## Data on your PC

- **Clipboard history** stays on your PC and you can clear it at any time.
- **Notifications** are read through the Windows notification listener, with your permission, so they can be shown in the island. They are not stored beyond the recent feed.
- **Google sign-in tokens and app credentials** are encrypted with Windows Data Protection (DPAPI) so only your Windows account can read them.
- **Copy text (OCR)** runs on your PC with Windows' built-in text recognition. A screenshot area is only sent to Gemini when you turn on smart OCR in Settings › Ask & Translate, or when Windows recognition is unavailable and you have saved a Gemini key.
- **AI Agents** monitoring is local. DeskHalo adds hooks to the coding agents you connect, which report to DeskHalo over a private pipe on your PC. A backup of each agent's settings is kept, and disconnecting removes the hooks.
- **Your Gemini API key** is encrypted with Windows Data Protection (DPAPI). Ask history stays on your PC.
- **Logs** (`island.log`, `crash.log`) stay on your PC. They are only shared if you attach them to a support request.

## Removing your data

Uninstalling DeskHalo asks whether to delete your data. You can also delete the `%APPDATA%\island` folder yourself at any time. To revoke Google Calendar access, disconnect in Settings › Connect or at [myaccount.google.com/permissions](https://myaccount.google.com/permissions).

## Children

DeskHalo is a general-purpose utility and does not knowingly collect information from anyone.

## Changes

Changes to this policy are published in this repository with the date above.

## Contact

Questions: [open an issue](https://github.com/consoleisrealistic/dynamic-island-for-windows/issues).
