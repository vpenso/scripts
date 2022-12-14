
export ZPLUG_HOME=~/.zplug

test -d $ZPLUG_HOME \
        || git clone https://github.com/zplug/zplug $ZPLUG_HOME

source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "woefe/git-prompt.zsh"

