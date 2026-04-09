#!/usr/bin/env bash

warn() {
    printf 'mise postinstall: %s\n' "$*" >&2
}

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)"
DOTFILES_HOME="${DOTFILES_HOME:-$(CDPATH= cd -- "${SCRIPT_DIR}/../../.." && pwd -P)}"
TARGET_REL="config/mise/config.toml"
TARGET="${DOTFILES_HOME}/${TARGET_REL}"
MISE_TOOL_NAME="${1:-${MISE_TOOL_NAME:-}}"
COMMIT_MESSAGE="chore(mise): update global config"

if [ -n "${MISE_TOOL_NAME}" ]; then
    COMMIT_MESSAGE="chore(mise): install ${MISE_TOOL_NAME}"
fi

if ! command -v git >/dev/null 2>&1; then
    warn "git is not available, skipping ${TARGET_REL} update"
    exit 0
fi

if ! git -C "${DOTFILES_HOME}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    warn "${DOTFILES_HOME} is not a git repository, skipping ${TARGET_REL} update"
    exit 0
fi

if [ ! -f "${TARGET}" ]; then
    warn "${TARGET_REL} does not exist, skipping"
    exit 0
fi

if ! git -C "${DOTFILES_HOME}" add -- "${TARGET_REL}"; then
    warn "failed to stage ${TARGET_REL}"
    exit 0
fi

if git -C "${DOTFILES_HOME}" diff --cached --quiet -- "${TARGET_REL}"; then
    exit 0
fi

if ! git -C "${DOTFILES_HOME}" commit --only -m "${COMMIT_MESSAGE}" -- "${TARGET_REL}"; then
    warn "failed to commit ${TARGET_REL}"
fi
