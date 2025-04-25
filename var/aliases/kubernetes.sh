command -v kubectl >/dev/null && {

        # load command completion
	case "$SHELL" in
        /bin/bash) source <(kubectl completion bash) ;;
        /bin/zsh) source <(kubectl completion zsh) ;;
        esac

        # load Krew plugin manager if available
        test -d $HOME/.krew \
                && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

}
