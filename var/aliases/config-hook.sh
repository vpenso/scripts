
if [[ "$SHELL" == *"bash" ]]
then
	grep -q -F source_me ~/.bashrc || \
		echo "source $SCRIPTS/source_me.sh" >> ~/.bashrc
fi

if [[ "$SHELL" == *"zsh" ]]
then
	# Make sure to load the environment automatically
	# if ZSH is configured to use the POST initialization hook
	hook=~/.zshrc.d/01_scripts
	if [ ! -f $hook ]
	then
		mkdir ~/.zshrc.d 2>/dev/null
		ln -s $SCRIPTS/source_me.sh $hook
		echo "ZSH configuration hook set at [$hook]."
	fi
fi

