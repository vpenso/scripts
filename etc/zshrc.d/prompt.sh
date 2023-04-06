setopt INTERACTIVE_COMMENTS

nice_exit_code() {
	local exit_status="${1:-$(print -P %?)}";
	# nothing to do here
	[[ -z $exit_status || $exit_status == 0 ]] && return;

	local sig_name;

	# is this a signal name (error code = signal + 128) ?
	case $exit_status in
		129)  sig_name=HUP ;;
		130)  sig_name=INT ;;
		131)  sig_name=QUIT ;;
		132)  sig_name=ILL ;;
		134)  sig_name=ABRT ;;
		136)  sig_name=FPE ;;
		137)  sig_name=KILL ;;
		139)  sig_name=SEGV ;;
		141)  sig_name=PIPE ;;
		143)  sig_name=TERM ;;
	esac

	# usual exit codes
	case $exit_status in
		-1)   sig_name=FATAL ;;
		1)    sig_name=WARN ;; # Miscellaneous errors, such as "divide by zero"
		2)    sig_name=BUILTINMISUSE ;; # misuse of shell builtins (pretty rare)
		126)  sig_name=CCANNOTINVOKE ;; # cannot invoke requested command (ex : source script_with_syntax_error)
		127)  sig_name=CNOTFOUND ;; # command not found (ex : source script_not_existing)
	esac

	# assuming we are on an x86 system here
	# this MIGHT get annoying since those are in a range of exit codes
	# programs sometimes use.... we'll see.
	case $exit_status in
		19)  sig_name=STOP ;;
		20)  sig_name=TSTP ;;
		21)  sig_name=TTIN ;;
		22)  sig_name=TTOU ;;
	esac

	echo "\e[38;5;23mexit\e[0m:${exit_status}:${sig_name:-$exit_status}$ZSH_PROMPT_EXIT_SIGNAL_SUFFIX ";
}




prompt_additions() {
        local prompt_additions=""
        # read environment variables prefixed with PROMPT_ADDITIONS and trim to a single line
        prompt_additions=$(env | grep PROMPT_ADDITIONS | cut -d'=' -f2 | sort | sed -z 's/\n/·/g' | sed 's/.$//')
	[[ "$prompt_additions" = "" ]] && return;
        echo " %F{252}env:%F{245}$prompt_additions%{$reset_color%}"
}

autoload -U colors && colors

if [ -f ~/.zsh/antigen.zsh ] ; then

        export ZSH_THEME_GIT_PROMPT_PREFIX="git:"
        export ZSH_THEME_GIT_PROMPT_SUFFIX=""
        export ZSH_THEME_GIT_PROMPT_SEPARATOR=":"
        export ZSH_THEME_GIT_PROMPT_CLEAN="-"
        export ZSH_THEME_GIT_PROMPT_STAGED="%F{32}*"
        export ZSH_THEME_GIT_PROMPT_CONFLICTS="%F{32}X"
        export ZSH_THEME_GIT_PROMPT_CHANGED="%F{31}+"
        export ZSH_THEME_GIT_PROMPT_BRANCH="%F{243}"
        export ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
        export ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
        export ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"

        export PROMPT=$'\n\e[32m%n\e[0m@\e[34m%m\e[0m:\e[31m%~\e[0m $(nice_exit_code)$(git_super_status)$(prompt_additions)\n%{$fg[red]%}>%{$reset_color%}%{$fg[black]%}>%{$reset_color%}%{$fg[blue]%}>%{$reset_color%} '

elif [ -d ~/.zplug/repos/woefe/git-prompt.zsh ] ; then

        source ~/.zplug/repos/woefe/git-prompt.zsh/git-prompt.zsh

        ZSH_THEME_GIT_PROMPT_PREFIX="git:"
        ZSH_THEME_GIT_PROMPT_SUFFIX=""
        ZSH_THEME_GIT_PROMPT_SEPARATOR=""
        ZSH_THEME_GIT_PROMPT_DETACHED="%F{92}:"
        ZSH_THEME_GIT_PROMPT_BRANCH="%F{250}"
        ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
        ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
        ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
        ZSH_THEME_GIT_PROMPT_BEHIND="↓"
        ZSH_THEME_GIT_PROMPT_AHEAD="↑"
        ZSH_THEME_GIT_PROMPT_UNMERGED="%F{160}x"
        ZSH_THEME_GIT_PROMPT_STAGED="%F{22}*"
        ZSH_THEME_GIT_PROMPT_UNSTAGED="%F{88}+"
        ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{166}…"
        ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}!"
        ZSH_THEME_GIT_PROMPT_CLEAN=""
        
        export PROMPT=$'\n%F{253}%~\e[0m $(nice_exit_code)$(gitprompt)$(prompt_additions)\n%F{253}>>>%{$reset_color%} '

else
        export PROMPT=$'\n\e[32m%n\e[0m@\e[34m%m\e[0m:\e[31m%~\e[0m\n>>> '
fi

