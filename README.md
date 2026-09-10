# dotfiles

## Setup

Log in to App Store and Apple ID

## Run script

```bash
bash init.sh
```

The script calls `sudo` in several places, so it prompts for the account password. A few
settings are written to nvram and to the login window, which only take effect after a
restart.

## Other manual settings

`mac/setup.sh` covers what `defaults`, `pmset`, `nvram`, and `pluginkit` can reach. The
items below have to be done by hand.

### AutoFill & Passwords

The master toggle and the built-in Passwords provider are stored under
`~/Library/Application Support/com.apple.AuthenticationServices/CredentialProviders`.
That directory is protected by TCC, so no script can write it.

1. Open System Settings > General > AutoFill & Passwords.
2. Turn on **AutoFill Passwords and Passkeys**.
3. Under **AutoFill from**, turn off **Passwords** (the built-in provider).
4. Under **AutoFill from**, turn on **1Password**.

Step 4 is normally handled by `configure_autofill_passwords`, which enables the extension
with `pluginkit`. On a fresh machine it gets skipped: `init.sh` runs the `mac` step before
the `homebrew` step, so 1Password is not installed yet. Either do step 4 by hand, or
re-run `bash mac/setup.sh` once `init.sh` has finished.

### Gatekeeper

`spctl --master-enable` no longer exists, so `configure_security` only reports the current
state. If `spctl --status` prints anything other than `assessments enabled`, boot into
Recovery OS and turn Gatekeeper back on from there.

### Lockdown Mode

`configure_security` writes the `Mode` key under
`/Library/Preferences/com.apple.security.lockdown`, but the supported way to change
Lockdown Mode is System Settings > Privacy & Security > Lockdown Mode, and it needs a
restart. Check that pane after running the script.

### FileVault

`configure_security` runs `sudo fdesetup enable` when FileVault is off. It prompts for the
account password and prints a recovery key. Save the key before moving on.

### Menu bar icon order

The script controls which icons appear, not where they sit. Positions are stored as
`NSStatusItem Preferred Position *` keys under `com.apple.controlcenter`. Hold Command and
drag the icons to reorder them.

### Dock contents

The script sets the Dock's size, position, and behaviour, but not which apps are pinned to
it. Add and arrange those by hand.

### Keys left out of the script

Two keys are set on the current machine but are not in `mac/setup.sh`, because the System
Settings item they correspond to could not be identified:

- `com.apple.WindowManager HideDesktop`
- `com.apple.WindowManager AppWindowGroupingBehavior`

Go through System Settings > Desktop & Dock by hand if the desktop or window grouping
behaves unexpectedly after a fresh install.

### Everything else

- Rename computer name
- Set up Wallet & Apple Pay settings
- Register additional fingerprints for Touch ID
- Set up to unlock Mac using Apple Watch
- Set up Screen Saver
- Set up Wallpaper randomly
- Set up Focus mode
- Turn off Night Shift
- Turn off True Tone
- Turn off Auto-Brightness
- Turn on bio-metric authentication to unlock Mac
- Change keyboard input source to Google Japanese Input
- Change default web browser to Google Chrome
- Setup each app
- Setup ESET
