# shell options

# setopt correct
setopt auto_menu auto_cd auto_name_dirs auto_remove_slash
setopt extended_history hist_ignore_dups hist_ignore_space
setopt pushd_ignore_dups rm_star_silent rmstar_wait sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys

# color

local BLACK=$'%{\e[30m%}'
local RED=$'%{\e[31m%}'
local GREEN=$'%{\e[32m%}'
local YELLOW=$'%{\e[33m%}'
local BLUE=$'%{\e[34m%}'
local PURPLE=$'%{\e[35m%}'
local WATER=$'%{\e[36m%}'
local WHITE=$'%{\e[37m%}'
local DEFAULT=$'%{\e[m%}'
local RANDOMC=$'%{\e[$[32+$RANDOM % 5]m%}'

# prompt

setopt prompt_subst
if [ $USER = "root" ]
then
    PROMPT="$RED%B$LOGNAME@%m[%W %T]:%b$DEFAULT %h# "
    RPROMPT="[%~]"
    PATH=${PATH}:/sbin:/usr/sbin:/usr/local/sbin
    HOME=/root
else
    #PROMPT="$RANDOMC$LOGNAME@%m%B[%W %T]:%b$DEFAULT %h%% "
    PROMPT=$RANDOMC"[$LOGNAME@%m]:$DEFAULT %h%% "
    # PROMPT="$RANDOMC[$USER@%m]%(!.#.$) $DEFAULT"
    RPROMPT=$GREEN"[%~]"$DEFAULT
fi

PATH=/opt/local/bin:/opt/local/sbin:${PATH}
MANPATH=/opt/local/man:${MANPATH}

# alias
alias rr="rm -rf"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

alias pd="pushd"
alias po="popd"

alias la="ls -lhAF --color=auto"
alias ll="ls -l"
alias ld="ls -dl"

alias j="jobs"

alias -g G="| grep "
alias -g M="| more"
alias -g L="| less"
alias -g H="| head "
alias -g T="| tail "
#alias -g W="| wc "
alias -g S="| sed "
#alias -g A="| awk "

#alias e="emacs &"
#alias enw="emacs -nw"

alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias gvim='env LANG=ja_JP.UTF-8 open -a /Applications/MacVim.app "$@"'

alias a="./a.out"
alias x="exit"

# tab

autoload -U compinit
compinit

# tab completion ignore case

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# history cd

setopt autopushd
alias gd='dirs -v; echo -n "select number: "; read newdir; cd -"$newdir"'

# Locale 
export LANG=C
#export LANG=ja_JP.eucJP
#export LANG=ja_JP.UTF-8

#
export PAGER=less

# screen statusline
if [ "$TERM" = "screen" ]; then
        #PROMPT=$RANDOMC"[%n@%m]%(!.#.$) %b$DEFAULT%h%% "
        #RPROMPT=""

	chpwd () { echo -n "_`dirs`\\" }
	preexec() {
		# see [zsh-workers:13180]
		# http://www.zsh.org/mla/workers/2000/msg03993.html
		emulate -L zsh
		local -a cmd; cmd=(${(z)2})
		case $cmd[1] in
			fg)
				if (( $#cmd == 1 )); then
					cmd=(builtin jobs -l %+)
				else
					cmd=(builtin jobs -l $cmd[2])
				fi
				;;
			%*) 
				cmd=(builtin jobs -l $cmd[1])
				;;
			cd)
				if (( $#cmd == 2)); then
					cmd[1]=$cmd[2]
				fi
				;&
			*)
				echo -n "k$cmd[1]:t\\"
				prev=$cmd[1]
				return
				;;
		esac

		local -A jt; jt=(${(kv)jobtexts})

		$cmd >>(read num rest
			cmd=(${(z)${(e):-¥$jt$num}})
			echo -n "k$cmd[1]:t\\") 2>/dev/null

		prev=$cmd[1]
	}
    precmd() {
        #local prev; prev=`history -1 | sed "s/^[ 0-9]*//" | sed "s/ .*$//"  `
        echo -n "k$:$prev\\"
    }
	chpwd
fi

