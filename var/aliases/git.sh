command -v git >/dev/null && {

        alias g=git

        # configure the git command
        test -L ~/.gitconfig \
                || ln -sfv $SCRIPTS/etc/gitconfig ~/.gitconfig
        test -L ~/.gitignore_global \
                || ln -sfv $SCRIPTS/etc/gitignore_global ~/.gitignore_global
}
