# if NeoVim is installed
command -v nvim >/dev/null && {

	# create the configuration directory if missing
	test -d ~/.config/nvim || mkdir -p ~/.config/nvim
	# link to the configuration within this repository
	test -L ~/.config/nvim/init.vim || \
		ln -s $SCRIPTS/etc/nvim/init.vim ~/.config/nvim/init.vim

	alias nv=nvim

}
