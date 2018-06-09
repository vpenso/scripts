if ! [ -f ~/.gitconfig ]
then
	$SCRIPTS/bin/git-default-config 'Victor Penso' vic.penso@gmail.com
fi

alias g=git
