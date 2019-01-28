# command-line fuzzy finder
# cf. https://github.com/junegunn/fzf

export FZF_DEFAULT_OPTS='--height 60% --border'

# key bindings and completion on Arch, Debian
for file in /usr/share/fzf/key-bindings.zsh \
            /usr/share/fzf/completion.zsh \
            /usr/share/doc/fzf/examples/key-bindings.zsh
do
        [ -f $file ] && source $file
done

function fzf-cheat() {
echo "
            KEYBINDING

         ctrl-t │ paste selection onto the command-line
         ctrl-r │ paste command from history
          alt-c │ cd into slected directory
        **<tab> │ trigger fuzzy completion
            esc │ exit

              SEARCH

           'str │ exact-match (quoted)
           ^str │ prefix-exact-match
           str$ │ suffix-exact-match
           !str │ inverse-exact-match
          !^str │ inverse-prefix-exact-match
          !str$ │ invert-suffix-exact-match
"
}
