# if NeoVim is installed
command -v nvim >/dev/null && {

	# create the configuration directory if missing
	test -d ~/.config/nvim || mkdir -p ~/.config/nvim

        # install vim-plug if missing
        test -d ~/.config/nvim/autoload || {
                mkdir -p ~/.config/nvim/autoload
                curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
                        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        }

	# link to the configuration within this repository
        test -L ~/.config/nvim/init.vim || \
		ln -s $SCRIPTS/etc/nvim/init.vim ~/.config/nvim/init.vim
#        test -L ~/.config/nvim/init.lua ||
#                ln -s $SCRIPTS/etc/nvim/init.lua ~/.config/nvim/init.lua

        
        # use the AppImage if present
        test -f $HOME/bin/nvim.appimage \
                && alias nvim=nvim.appimage
        # prefer the latest version if present
#        test -f $HOME/bin/nvim-nightly.appimage \
#              && alias nvim=nvim-nightly.appimage

        alias v=nvim
        alias v0='nvim --clean'

}
