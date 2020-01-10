# Install Zsh Antigen from GitHub
# https://github.com/zsh-users/antigen
if ! [ -f ~/.zsh/antigen.zsh ]
then

        mkdir ~/.zsh 2>/dev/null
        wget -q -O ~/.zsh/antigen.zsh \
                https://github.com/zsh-users/antigen/releases/download/v2.2.3/antigen.zsh
        echo Zsh Antigen installed to ~/.zsh/antigen.zsh
fi

if [ -f ~/.zsh/antigen.zsh ]
then
        ##
        ## Install plugins/bundels
        ##

        source ~/.zsh/antigen.zsh
        # list of bundles to install
        antigen bundle git
        antigen bundle zsh-users/zsh-completions           # https://github.com/zsh-users/zsh-completions
        antigen bundle zsh-users/zsh-autosuggestions       # https://github.com/zsh-users/zsh-autosuggestions
        antigen bundle zsh-users/zsh-syntax-highlighting   # https://github.com/zsh-users/zsh-syntax-highlighting
        antigen bundle olivierverdier/zsh-git-prompt
        # install packages
        antigen apply

        # https://github.com/zsh-users/antigen/wiki/Configuration
fi
