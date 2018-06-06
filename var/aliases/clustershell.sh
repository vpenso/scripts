alias nodeset='noglob nodeset'

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

alias NODES='noglob NODES'

# stdin is exported as environment variable
exp() { read n; export $1=$n ; }

if [[ "$SHELL" == "*zsh" ]]
then
	# pipe into the NODES environment variable
	alias -g NE='| exp NODES'
	alias -g NF='| nodeset -f'
	alias -g NC='| nodeset -c'
fi

alias nf='nodeset -f'
alias ne='exp NODES'


# run Clustershell using the NODES environment variable
alias rush='clush -l root -w $NODES'

alias nodeset-accessible='noglob nodeset-accessible'
alias na=nodeset-accessible

nodeset-fping() { fping $(nodeset -e $NODES) 2>$- ; }

alias np=nodeset-fping
