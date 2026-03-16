#!/usr/bin/env bash
#
# = SYNOPSIS
#   Run this script to install the dotfiles.
#     $ git clone https://github.com/rokuosan/dotfiles.git
#     $ ./dotfiles/install.sh
#
# = DESCRIPTION
#   This script creates symbolic links to the dotfiles in the home directory.
#
set -euxo pipefail

DEBUG=0
DRY_RUN=0
DOTFILES_HOME="$(cd "$(dirname "${0}")" && pwd)"
BACKUP_DIR="${DOTFILES_HOME}/backup"

source "${DOTFILES_HOME}/lib/logger.sh"

# run_cmd runs a command or prints it in dry-run mode.
function run_cmd() {
    if [ "${DRY_RUN}" -eq 1 ]; then
        info "[dry-run] $*"
        return 0
    fi

    "$@"
}

# backup creates a backup of the file.
function backup() {
    local src="${HOME}/${1}" dest="${BACKUP_DIR}/${1}"
    run_cmd mkdir -p "$(dirname "${dest}")"
    run_cmd mv "${src}" "${dest}"
}

# link creates a symbolic link to a file.
function link() {
    local src="${DOTFILES_HOME}/${1}" dest="${HOME}/${2}"
    [ -f "${dest}" ] && backup "${2}"
    run_cmd mkdir -p "$(dirname "${dest}")"
    info "${dest} -> ${src}"
    run_cmd ln -fs "${src}" "${dest}"
}

# link_dir creates a symbolic link to a directory.
# If the destination is a symbolic link, it is removed.
function link_dir() {
    local src="${DOTFILES_HOME}/${1}" dest="${HOME}/${2}"
    [ -e "${dest}" ] && backup "${2}"
    if [ -L "${dest}" ]; then run_cmd rm "${dest}"; fi
    run_cmd mkdir -p "$(dirname "${dest}")"
    info "${dest} -> ${src}"
    run_cmd ln -s "${src}" "${dest}"
}

# show_help prints the help message.
function show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -v        Enable verbose (debug) mode"
    echo "  -n        Dry-run mode (show actions without changing files)"
    echo "  --dry-run Dry-run mode (show actions without changing files)"
    echo "  --help    Show this help message"
}

function main() {
    # Parse options
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -v) DEBUG=1 ;;
            -n|--dry-run) DRY_RUN=1 ;;
            --help) show_help; exit 0 ;;
            *) error "Unknown option: $1"; exit 1 ;;
        esac
        shift
    done

    # Show the installation information.
    info "Installing dotfiles..."
    debug "DOTFILES_HOME: ${DOTFILES_HOME}"
    debug "BACKUP_DIR: ${BACKUP_DIR}"
    [ "${DRY_RUN}" -eq 1 ] && info "Dry-run mode enabled. No files will be changed."

    link "config/zsh/.zshrc" ".zshrc"
    link "config/zsh/.zprofile" ".zprofile"
    link_dir "config/zsh" ".config/zsh"

    link_dir "config/1Password" ".config/1Password"
    link_dir "config/gh" ".config/gh"
    link_dir "config/ghostty" ".config/ghostty"
    link_dir "config/git" ".config/git"
    link_dir "config/mise" ".config/mise"
    link_dir "config/nvim" ".config/nvim"
    link_dir "config/peco" ".config/peco"
    link_dir "config/starship" ".config/starship"
}

main "$@"
