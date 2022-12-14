
if command -v hstr >/dev/null
then
      alias '?'=hstr
      setopt histignorespace
      export HSTR_CONFIG=hicolor,help-on-opposite-side
      export HSTR_PROMPT="> "

      # bind Ctrl-r
      #bindkey -s '^R' 'hstr^M'
else
      alias '?'='fc -li 1'                         # list history with time stamp
      alias '?5'='history -5'                      # list last five entries in history
fi

