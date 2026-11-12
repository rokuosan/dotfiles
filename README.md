# dotfiles

## New machine setup

```bash
# Install mise
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
# Clone the repository
git clone --recurse-submodules https://github.com/rokuosan/dotfiles ~/.dotfiles
# Change to the dotfiles directory
cd ~/.dotfiles
# Trust the configuration and preview dotfile deployment
mise trust
mise bootstrap --only dotfiles --dry-run
# Apply the dotfiles
mise bootstrap --only dotfiles
```

## Existing installations

Links that already point to the declared sources are left unchanged. Preview
with `mise bootstrap --only dotfiles --dry-run` before applying. Existing regular files and
directories conflict; inspect and remove or move only those targets yourself,
then rerun. Links to other sources, including broken links, are repointed.
No automatic backup is configured.

All entries currently use symlinks to preserve the former `install.sh` layout,
including Codex. Copying or seeding individual configurations is a separate change.

To apply only the dotfiles from outside this repository:

```sh
mise -C ~/.dotfiles dot apply
```
