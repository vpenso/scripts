if command -v firejail >/dev/null
then
        # reference to the configuration in this repository
        test -L ~/.config/firejail \
                || ln -s $SCRIPTS/etc/firejail ~/.config/firejail
        
        # Launch from your project directory
        function opencode-firejail() {
                firejail --profile=opencode --whitelist=$(pwd) opencode
        }        
fi
