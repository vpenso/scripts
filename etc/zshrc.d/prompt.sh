setopt INTERACTIVE_COMMENTS

export ZSH_THEME_GIT_PROMPT_PREFIX="("
export ZSH_THEME_GIT_PROMPT_SUFFIX=")"
export ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
export ZSH_THEME_GIT_PROMPT_CLEAN="✔"
export ZSH_THEME_GIT_PROMPT_STAGED="%F{32}*"
export ZSH_THEME_GIT_PROMPT_CONFLICTS="%F{32}X"
export ZSH_THEME_GIT_PROMPT_CHANGED="%F{31}+"
export ZSH_THEME_GIT_PROMPT_BRANCH="%F{243}"
export ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{33}…"
export ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
export ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"

# TODO: specifically check for the plugin
if [ -f ~/.zsh/antigen.zsh ]
then
        export PROMPT=$'\n\e[32m%n\e[0m@\e[34m%m\e[0m:\e[31m%~\e[0m $(git_super_status) \n>>> '
else
        export PROMPT=$'\n\e[32m%n\e[0m@\e[34m%m\e[0m:\e[31m%~\e[0m\n>>> '
fi
