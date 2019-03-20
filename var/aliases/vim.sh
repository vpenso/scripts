
# install vim-plug plugin manager
#
# https://github.com/junegunn/vim-plug
[[ -d ~/.vim/autoload ]] || mkdir -vp ~/.vim/autoload
[[ -f ~/.vim/autoload/plug.vim ]] || \
	curl -fLo ~/.vim/autoload/plug.vim \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# run PlugInstall! and PlugUpdate!


# link to the vim configuration file in this repository
#
#
if [ -z $SCRIPTS ]
then
	echo \$SCRIPTS must be set!
else
	[[ -f ~/.vimrc ]] || \
		ln -svf $SCRIPTS/etc/vimrc ~/.vimrc
fi

# do not source vimrc on startup, but run with `noncompatible` option
alias v0='vim -u NONE -N'
