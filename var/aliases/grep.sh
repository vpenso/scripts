# colorize matched patterns when using `grep` by default
grep_command='--color=auto'
# exclude version control repositories from search
for PATTERN in .cvs .git .hg .svn; do
   grep_command="$grep_command --exclude-dir=$PATTERN"
done
export GREP_COLOR='1;38;5;52;48;5;166'
export GREP_COLORS='ms=00;34:mc=00;34:sl=:cx=:fn=35:ln=37:bn=32:se=36'
alias grep="grep $grep_command"
alias agrep=tre-agrep

export ACK_PAGER_COLOR="less -x4SRFX"

alias ack='ack-grep -a'
