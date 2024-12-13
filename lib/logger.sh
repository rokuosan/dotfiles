source "$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)/colors.sh"

# now returns the current date and time.
function now() {
    date "+%Y-%m-%d %H:%M:%S"
}

# debug prints the message if the DEBUG flag is set.
# color: light blue
function debug() {
    if [ "${DEBUG}" -eq 1 ]; then
        lightblue "$(now) [debug]: $1"
    fi
}

# error prints the error message in red and exits the script.
function error() {
    red "$(now) [error]: $1" >&2
    exit 1
}

# info prints the message.
# color: green
function info() {
    green "$(now) [info]: $1"
}
