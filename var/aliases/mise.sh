command -v mise >/dev/null && {

        test -f ~/.bashrc.d/mise.sh || \
                echo 'eval "$(mise activate bash)"' > ~/.bashrc.d/mise.sh
        
        test -d ~/.local/share/bash-completion/completions || \
                mkdir -p ~/.local/share/bash-completion/completions

        test -f ~/.local/share/bash-completion/completions/mise || \
                mise completion bash --include-bash-completion-lib \
                        > ~/.local/share/bash-completion/completions/mise

}
