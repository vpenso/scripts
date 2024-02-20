
if command -v brave-browser >/dev/null ; then
        alias brave=brave-browser
        # set as default browser
#        export BROWSER=${BROWSER:-brave-browser}

# Firefox typically installed by default
else
        export BROWSER=${BROWSER:-firefox}
fi

