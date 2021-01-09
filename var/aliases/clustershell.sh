# quick export NODES environment variable
function NODES() {
	if [ $# -lt 1 ]
	then
		: ${NODES:?}
		echo $NODES
	else
		export NODES=$@
	fi
}

# stdin is exported as environment variable
exp() { read n; export $1=$n ; }

# run Clustershell using the NODES environment variable
alias rush='clush -l root -w $NODES'

if [[ $SHELL == *zsh ]]
then
        alias nodeset='noglob nodeset'
        alias NODES='noglob NODES'
	# pipe into the NODES environment variable
	alias -g NE='| exp NODES'
	alias -g NF='| nodeset -f'
	alias -g NC='| nodeset -c'
        alias na='noglob nodeset-accessible'
else # bash, etc.
        alias na=nodeset-accessible
        alias ne='exp NODES'
        alias nf='nodeset -f'
fi

nodeset-fping() { fping $(nodeset -e $NODES) 2>$- ; }

alias np=nodeset-fping
