
test -L /usr/bin/i3exit || {
        echo sudo: Adding link to i3exit?
        sudo ln -sfv $SCRIPTS/bin/i3exit /usr/bin/i3exit 
}
