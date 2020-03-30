# executables installed by Pip in Debian
test -d ~/.local/bin && export PATH=$PATH:~/.local/bin
# cf $SCRIPTS/docs/tools/termtosvg.md

termtosvg-light-progress_bar() {
        local templates=$SCRIPTS/var/lib/termtosvg
        termtosvg \
                --screen-geometry=80x20 \
                --template=$templates/light-progress_bar.svg \
                --command="bash --rcfile $templates/bashrc" \
                $@
}
