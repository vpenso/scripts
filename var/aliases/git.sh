if ! [ -f ~/.gitconfig ]
then
	$SCRIPTS/bin/git-default-config 'Victor Penos' vic.penso@gmail.com
fi

alias g=git
