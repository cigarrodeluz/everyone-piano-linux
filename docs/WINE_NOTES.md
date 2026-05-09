# Wine Notes

Everyone Piano 2.5.9.4 is a 32-bit Windows application.

The setup that worked reliably during testing:

- Dedicated Wine prefix
- `WINEARCH=win32`
- Windows version set to `winxp`
- Program installed under `C:\Program Files\EveryonePiano`

The `winxp` setting matters. With newer Windows versions, Everyone Piano can open its main window and then crash in an audio thread after Wine loads `mmdevapi` and `winepulse`. Forcing Windows XP keeps the app on the older compatibility path and avoids that startup crash.

Useful manual commands:

```sh
export WINEPREFIX="$HOME/.local/share/everyone-piano-linux/wineprefix"
export WINEARCH=win32

wineboot -u
winecfg -v winxp
wine reg add 'HKCU\Software\Wine' /v Version /t REG_SZ /d winxp /f
wine EveryonePiano2.5.9.4_setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
wine start /unix "$WINEPREFIX/drive_c/Program Files/EveryonePiano/EveryonePiano.exe"
```

