typeset -gU path fpath cdpath

export GOPATH="${GOPATH:-$HOME/go}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Keep persistent shells and agents attached to the latest forwarded SSH agent.
if [[ $OSTYPE == linux* ]]; then
    () {
        local stable_socket="$HOME/.ssh/agent-forwarded.sock"
        local forwarded_socket=${SSH_AUTH_SOCK:-}
        local stable_rc=2
        local fwd_rc=2

        # Only interactive/TTY SSH logins outside Herdr may publish a new target,
        # so short-lived non-interactive SSH commands cannot break active sessions.
        if [[ -n ${SSH_CONNECTION:-} && -z ${HERDR_ENV:-} && ( -o interactive || -n ${SSH_TTY:-} ) ]]; then
            if [[ -S $forwarded_socket ]]; then
                forwarded_socket=${forwarded_socket:A}
                if [[ $forwarded_socket != "$stable_socket" &&
                      $forwarded_socket != /run/user/*/openssh_agent &&
                      $forwarded_socket != /run/user/*/gnupg/S.gpg-agent.ssh &&
                      $forwarded_socket != "$HOME/.config/herdr/"* ]]; then
                    SSH_AUTH_SOCK="$forwarded_socket" ssh-add -l >/dev/null 2>&1
                    fwd_rc=$?
                    if (( fwd_rc == 0 || fwd_rc == 1 )); then
                        if (( fwd_rc == 1 )); then
                            SSH_AUTH_SOCK="$stable_socket" ssh-add -l >/dev/null 2>&1
                            stable_rc=$?
                        fi
                        if (( fwd_rc == 0 || stable_rc != 0 )); then
                            local pending_link="${stable_socket}.$$.tmp"
                            if command ln -s -- "$forwarded_socket" "$pending_link" 2>/dev/null; then
                                command mv -f -- "$pending_link" "$stable_socket" 2>/dev/null
                                command rm -f -- "$pending_link"
                            fi
                        fi
                    fi
                fi
            fi
        fi

        # In interactive shells, recover if the current symlink target has closed
        # while another SSH session's forwarded socket is still alive.
        if [[ -o interactive ]]; then
            SSH_AUTH_SOCK="$stable_socket" ssh-add -l >/dev/null 2>&1
            stable_rc=$?
            if (( stable_rc != 0 )); then
                local candidate cand_rc
                local fallback=""
                for candidate in "$HOME"/.ssh/agent/s.*(N=om) /tmp/ssh-*/agent.*(N=om); do
                    SSH_AUTH_SOCK="$candidate" ssh-add -l >/dev/null 2>&1
                    cand_rc=$?
                    if (( cand_rc == 0 )); then
                        fallback="$candidate"
                        break
                    elif (( cand_rc == 1 && stable_rc == 2 )) && [[ -z $fallback ]]; then
                        fallback="$candidate"
                    fi
                done
                if [[ -n $fallback ]]; then
                    local pending_link="${stable_socket}.$$.tmp"
                    if command ln -s -- "$fallback" "$pending_link" 2>/dev/null; then
                        command mv -f -- "$pending_link" "$stable_socket" 2>/dev/null
                        command rm -f -- "$pending_link"
                    fi
                fi
            fi
        fi

        if [[ -S $stable_socket || -L $stable_socket ]]; then
            export SSH_AUTH_SOCK="$stable_socket"
        elif (( fwd_rc == 0 || fwd_rc == 1 )); then
            export SSH_AUTH_SOCK="$forwarded_socket"
        fi
    }
fi

path=(
    "$GOPATH/bin"
    "$HOME/bin"
    "$HOME/.local/bin"
    "${MISE_DATA_DIR:-$XDG_DATA_HOME/mise}/shims"
    $path
)
if [[ -f "$HOME/.zshenv.local" ]]; then
    source "$HOME/.zshenv.local"
fi
