# Third-party notices

Island is built with the following open-source software. Their licenses apply to those components, not to Island itself.

| Component | License | Project |
| --- | --- | --- |
| Python | PSF License | https://www.python.org |
| Qt for Python (PySide6, Shiboken6) and Qt 6 | LGPL v3 | https://www.qt.io/qt-for-python |
| psutil | BSD 3-Clause | https://github.com/giampaolo/psutil |
| pycaw | MIT | https://github.com/AndreMiras/pycaw |
| comtypes | MIT | https://github.com/enthought/comtypes |
| PyWinRT (winrt-* packages) | MIT | https://github.com/pywinrt/pywinrt |
| pywin32 | PSF License | https://github.com/mhammond/pywin32 |
| WMI | MIT | https://github.com/tjguk/wmi |
| screen-brightness-control | MIT | https://github.com/Crozzers/screen_brightness_control |
| PyInstaller bootloader | GPL v2 with bootloader exception | https://pyinstaller.org |

## Qt (LGPL v3)

Island links to the Qt libraries dynamically. They ship as separate DLL files in the install folder (`_internal\PySide6`), so you can replace them with your own build of the same Qt version. The Qt source code is available from https://download.qt.io and the LGPL v3 text from https://www.gnu.org/licenses/lgpl-3.0.html.

## Data sources

- Lyrics: [LRCLIB](https://lrclib.net).
- Weather data by [Open-Meteo.com](https://open-meteo.com), licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
