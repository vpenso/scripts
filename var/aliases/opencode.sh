command -v opencode >/dev/null && {
    test -f ~/.config/opencode || mkdir -p ~/.config/opencode
    test -f ~/.config/opencode/opencode.json \
        || ln -svf $GSI_SCRIPTS/etc/opencode/opencode.json \
                   ~/.config/opencode/opencode.json

    # Performs web searches using Exa AI cf. https://exa.ai/
    export OPENCODE_ENABLE_EXA=1 
}
