if command -v firejail >/dev/null
then
        # Install configuration files from this repository
        for file in \
                $SCRIPTS/etc/firejail/*.local \
                $SCRIPTS/etc/firejail/*.profile
        do
                diffcp -r $file ~/.config/firejail/$(basename $file)
        done
       
        #################################
        # Which applications to launch with firejail

        function opencode-firejail() {
                firejail --profile=opencode --whitelist=$(pwd) opencode
        }
        alias opencode=opencode-firejail

        function pi-firejail() {
                firejail --profile=pi --whitelist=$(pwd) ~/bin/pi
        }
        alias pi=pi-firejail
fi
