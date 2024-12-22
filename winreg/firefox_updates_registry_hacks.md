# Firefox Update Control via Registry Settings
_For those who choose not to be guinea pigs for the Agile development model.
_
This document describes registry modifications that control Firefox's automatic update behavior at the system level.

## Registry Location

All modifications are made to:
```
HKEY_LOCAL_MACHINE\Software\Policies\Mozilla\Firefox
```

## Available Modifications

### Disable Firefox Updates
File: `disable_firefox_updates.reg`
https://github.com/igoros777/x/blob/main/winreg/disable_firefox_updates.reg

```reg
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\Software\Policies\Mozilla\Firefox]
"DisableAppUpdate"=dword:00000001
```

### Enable Firefox Updates
File: `enable_firefox_updates.reg`
https://github.com/igoros777/x/blob/main/winreg/enable_firefox_updates.reg

```reg
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\Software\Policies\Mozilla\Firefox]
"DisableAppUpdate"=dword:00000000
```

## Usage

1. Save the desired registry file (`.reg`) to your system
2. Double-click the file to merge it into the Windows Registry
3. Confirm any security prompts that appear
4. Restart Firefox for changes to take effect

## Notes

- These modifications require administrative privileges to apply
- The changes affect all users on the system
- Setting `DisableAppUpdate` to `1` completely disables Firefox's ability to check for and install updates
- Setting `DisableAppUpdate` to `0` restores Firefox's default update behavior
