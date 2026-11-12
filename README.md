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

Codex settings still use a symlink. Claude settings are seeded only when
missing, so application-generated settings can remain local.

To apply only the dotfiles from outside this repository:

```sh
mise -C ~/.dotfiles dot apply
```

## Skills and generated integrations

Repository skills are linked individually into `~/.agents/skills` and
`~/.claude/skills`, leaving externally installed skills in place. Gist skills
are submodules; after cloning without `--recurse-submodules`, run
`git submodule update --init --recursive` before applying dotfiles.

Install or refresh Cloudflare and cosense skills for Codex and Claude Code:

```sh
mise run setup:skills
```

Claude settings are copied only when missing. Existing settings, including
Herdr-generated hooks, stay local. After installing Herdr, generate its
integration rather than copying the generated hook script:

```sh
mise run setup:herdr:claude
```
