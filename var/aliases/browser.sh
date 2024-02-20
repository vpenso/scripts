
# Firefox typically installed by default
export BROWSER=${BROWSER:-firefox}

if command -v brave-browser >/dev/null ; then
        alias brave=brave-browser
#        export BROWSER=${BROWSER:-brave-browser}
fi

