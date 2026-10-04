# Private configuration

Public examples contain placeholder identities, paths and password-manager
references. Configure the ignored local files before using the mail or backup
tools. Keep passwords in a password manager or encrypted files.

| Tool | Public configuration | Ignored local configuration |
| --- | --- | --- |
| Git | `.config/git/config` | `.config/git/config.local` |
| Fish | `conf.d/private-settings.fish` and `hosts.example/` | `.config/fish/private/config.fish` and `hosts/<hostname>.fish` |
| NeoMutt | `.config/neomutt/neomuttrc` | `.config/neomutt/private.rc` and `accounts/` |
| Resticprofile | `.config/resticprofile/profiles.toml` | `profiles.local.toml`, `profiles.local.credentials.toml`, `excludes.local.txt` |
| aerc | `.config/aerc/accounts.conf.example` | `.config/aerc/accounts.conf` |
| msmtp | `.config/msmtp/config.example` | `.config/msmtp/config` |
| OfflineIMAP | `.config/offlineimap/config.example` | `.config/offlineimap/config` |
| notmuch | `.notmuch-config.example` | `.notmuch-config` |
| iTerm2 | `.config/iTerm2/com.googlecode.iterm2.plist.example` | `.config/iTerm2/com.googlecode.iterm2.plist` |
| k9s | `.config/k9s/config.yaml.example` | `.config/k9s/config.yaml` |
| SSH | `.ssh/config.example` | `.ssh/config` and `.ssh/config.d/` |

Copy each `.example` to the corresponding local filename and edit its
placeholders. For Fish, copy `private.example.fish` to `private/config.fish`;
put account-specific functions there. The generic `op_` field reader remains
shared. Host settings are loaded from an ignored file named for the hostname.
For NeoMutt, copy `private.rc.example` to `private.rc`.

For Resticprofile, copy both `profiles.local*.toml.example` files to their
corresponding local names. Put source paths, schedules and log locations in
`profiles.local.toml`. Set the repository and password source in
`profiles.local.credentials.toml`, or make that file a local symlink to an
existing private credentials configuration. Included files cannot load nested
includes; the shared profile loads both files directly. Local exclusions are
combined with the shared exclusions. Verify the merged profile with
`resticprofile --config ~/.config/resticprofile/profiles.toml show` locally;
its output can contain private settings.

Mail configurations and terminal preferences without suitable include support
remain ignored runtime files with public examples. The iTerm2 example omits
saved window arrangements and home directory values. Generated editor plugin
files, repository history, logs, fonts and wallpapers stay outside Git.
