# if NeoVim is installed
command -v nvim >/dev/null && {

        # install vim-plug if missing
        test -d ~/.config/nvim/autoload || {
                mkdir -p ~/.config/nvim/autoload
                curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
                        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        }

	# create the configuration directory if missing
	test -d ~/.config/nvim || mkdir -p ~/.config/nvim
	# link to the configuration within this repository
	test -L ~/.config/nvim/init.vim || \
		ln -s $SCRIPTS/etc/nvim/init.vim ~/.config/nvim/init.vim

	alias nv=nvim

}
