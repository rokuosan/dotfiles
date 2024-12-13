# green prints the message in green.
function green() {
    echo -e "\033[32m$1\033[0m"
}

# red prints the message in red.
function red() {
    echo -e "\033[31m$1\033[0m"
}

# lightblue prints the message in light blue.
function lightblue() {
    echo -e "\033[94m$1\033[0m"
}
