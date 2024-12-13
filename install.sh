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

DEBUG=0
DOTFILES_HOME="$(cd "$(dirname "${0}")" && pwd)"
BACKUP_DIR="${DOTFILES_HOME}/backup"

source "${DOTFILES_HOME}/lib/logger.sh"

# backup creates a backup of the file.
function backup() {
    local src="${HOME}/${1}" dest="${BACKUP_DIR}/${1}"
    mkdir -p "$(dirname "${dest}")"
    mv "${src}" "${dest}"
}

# link creates a symbolic link to a file.
function link() {
    local src="${DOTFILES_HOME}/${1}" dest="${HOME}/${2}"
    [ -f "${dest}" ] && backup "${2}"
    ln -fsv "${src}" "${dest}"
}

# link_dir creates a symbolic link to a directory.
# If the destination is a symbolic link, it is removed.
function link_dir() {
    local src="${DOTFILES_HOME}/${1}" dest="${HOME}/${2}"
    [ -e "${dest}" ] && backup "${2}"
    if [ -L "${dest}" ]; then rm "${dest}"; fi
    ln -sv "${src}" "${dest}"
}

# show_help prints the help message.
function show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -v        Enable verbose (debug) mode"
    echo "  --help    Show this help message"
}

function main() {
    # Parse options
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -v) DEBUG=1 ;;
            --help) show_help; exit 0 ;;
            *) error "Unknown option: $1"; exit 1 ;;
        esac
        shift
    done

    # Show the installation information.
    info "Installing dotfiles..."
    debug "DOTFILES_HOME: ${DOTFILES_HOME}"
    debug "BACKUP_DIR: ${BACKUP_DIR}"
    error "This script is not yet implemented."
}

main "$@"
