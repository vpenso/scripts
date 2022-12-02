
if command -v hstr >/dev/null
then
      alias hh=hstr                                # hh to be alias for hstr
      setopt histignorespace                       # skip cmds w/ leading space from history
      export HSTR_CONFIG=hicolor,help-on-opposite-side
      bindkey -s "\C-r" "\C-a hstr -- \C-j"        # bind hstr to Ctrl-r (for Vi mode check doc)
else
      alias '?'='fc -li 1'                         # list history with time stamp
      alias '?5'='history -5'                      # list last five entries in history
fi

