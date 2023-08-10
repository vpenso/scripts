
# generate a random identifier of a given length (defaults to 5)
rid() {
        local length=${1:-5}
        tr -dc A-Za-z0-9 </dev/urandom | head -c $length ; echo
}

