command -v kubectl >/dev/null && {

        # load command completion
	if [ "$shell" = "bash" ] ; then
		source <(kubectl completion bash)
	elif [ "$shell" = "zsh" ] ; then
		source <(kubectl completion zsh)
	fi

        # load the kubeclt Krew plugin manager if available
        test -d $HOME/.krew \
                && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

}
