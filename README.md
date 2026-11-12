# dotfiles

## New machine setup

```bash
# Install mise
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

# Clone the repository and submodules under the configured ghq root
GHQ_ROOT="$HOME/repo" mise exec ghq@latest -- ghq get https://github.com/rokuosan/dotfiles

# Change to the dotfiles directory
cd ~/repo/github.com/rokuosan/dotfiles

# Trust the configuration and preview dotfile deployment
mise trust
mise bootstrap --only dotfiles --dry-run

# Apply the dotfiles
mise bootstrap --only dotfiles
```

The ghq root is `~/repo`, matching `config/git/config`. After loading the zsh
configuration, press `Ctrl-G` to select a repository with ghq and peco.

## Existing installations

Links that already point to the declared sources are left unchanged. Preview
with `mise bootstrap --only dotfiles --dry-run` before applying. Existing regular files and
directories conflict; inspect and remove or move only those targets yourself,
then rerun. Links to other sources, including broken links, are repointed.
No automatic backup is configured.

Codex settings use a regular file. `mise dot apply` merges the keys declared in
`config/codex/config.toml`, preserving local project trust, hooks, and application
state. Removing a shared key does not remove its local value. Claude settings
are seeded only when missing, so application-generated settings can remain local.

To apply only the dotfiles from outside this repository:

```sh
mise -C ~/repo/github.com/rokuosan/dotfiles dot apply
```

## Homebrew packages and applications

Install Homebrew if needed, then install formulae and casks from `Brewfile`:

```sh
mise run setup:brew
```

Existing Homebrew installations are reused, including when `brew` is not on
`PATH` but is in a standard installation location. Installed packages are not
upgraded, and packages outside `Brewfile` are not removed. Use `brew upgrade`
separately when you want to update them.

## Utility tasks

Task scripts live in `scripts/tasks/`. Dotfile deployment links this directory
at `~/.config/mise/tasks` and links `config/mise/config.toml` separately.
When migrating an existing `~/.config/mise` directory symlink, remove only that
symlink before running `mise dot apply`; keep regular directories and files.

`encrypt`, `sign`, and `verify` are shell aliases for their mise tasks. Reload
the mise shell environment after applying the configuration to use them.
Outside an interactive shell, use `mise run --quiet encrypt -- [options] [file]`
(and similarly for `sign` and `verify`). The separator forwards options such as
`--help` to the script. Each task uses the calling directory and requests the
latest Perl through mise; `mise upgrade perl` updates the installed version.

`git-wtclean2` keeps a launcher in `bin/` for use as `git wtclean2`; its Perl
implementation is also a mise task. `update` is in `scripts/tasks/` as well.

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
