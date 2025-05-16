command -v kubectl >/dev/null && {
        
        alias k=kubectl

        # load command completion
	case "$SHELL" in
        /bin/bash) 
                source <(kubectl completion bash) 
                complete -o default -f __start_kubectl k
                ;;
        /bin/zsh) 
                autoload -U +X compinit && compinit
                source <(kubectl completion zsh)
                ;;
        esac

        # load Krew plugin manager if available
        test -d $HOME/.krew \
                && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

}
