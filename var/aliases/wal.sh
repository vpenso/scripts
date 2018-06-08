# if pywal is configured
if [ -f ~/.cache/wal/sequences ]
then
	# import colorschema from pywal
	(cat ~/.cache/wal/sequences &)
fi

alias walli='wal -l -i'
