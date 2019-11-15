# in Debian the binary is called `fdfind` as the binary name `fd` 
# is already used by another package
command -v fdfind >&- && {
        alias fd=fdfind
}
