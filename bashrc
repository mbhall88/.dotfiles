# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
source ~/.profile

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# # set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
#
# # uncomment for a colored prompt, if the terminal has the capability; turned
# # off by default to not distract the user: the focus in a terminal window
# # should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# set vim mode for terminal
set -o vi

case "$HOSTNAME" in
    *noah* | *yoda* | *gpu*)
        # bash_prompt
        # The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
        YELLOW="\[\033[0;33m\]"
        GREEN="\[\033[0;32m\]"
        BLUE="\[\033[1;34m\]"
        LIGHT_RED="\[\033[1;31m\]"
        LIGHT_GREEN="\[\033[1;32m\]"
        WHITE="\[\033[1;37m\]"
        LIGHT_GRAY="\[\033[0;37m\]"
        PURPLE="\[\e[38;5;13m\]"
        BOLD="\[\e[1m\]"
        COLOR_NONE="\[\e[0m\]"
         # Determine active Python virtualenv details.
        function set_virtualenv () {
            if test -z "$VIRTUAL_ENV" ; then
               PYTHON_VIRTUALENV=""
            else
                PYTHON_VIRTUALENV="${BLUE}($(basename $VIRTUAL_ENV))${COLOR_NONE} "
            fi
        }
        # change the bash prompt
        function prompt_right() {
          echo -e "${LIGHT_GREEN}\\\t${COLOR_NONE}"
        }

        function prompt_left() {
          set_virtualenv
          echo -e "${RED}\h${COLOR_NONE} in ${BOLD}${PURPLE}\w${COLOR_NONE}${COLOR_NONE}  ${YELLOW}$(git branch 2>/dev/null | sed -n "s/* \(.*\)/\1 /p")${COLOR_NONE} ${PYTHON_VIRTUALENV}"
          # echo -e "\033[0;32m\u\033[0m at \033[0;31m\h\033[0m in \033[38;1;13m\w\033[0m"
        }

        function prompt() {
            compensate=13
            PS1=$(printf "%*s\r%s\n\$ " "$(($(tput cols)+${compensate}))" "$(prompt_right)" "$(prompt_left)")
        }
        PROMPT_COMMAND=prompt
        # PS1='\[\e[38;5;14m\]\t\[\e[0m\]\r \[\e[38;32;14m\]\u\[\e[0m\] at \[\e[38;5;9m\]\H\[\e[0m\] in \[\e[1m\]\[\e[38;5;13m\]\w\[\e[0m\]  \[\e[38;5;11m\]$(git branch 2>/dev/null | sed -n "s/* \(.*\)/\1 /p")\[\e[0m\] \n \[\e[38;5;10m\]➜  \[\e[0m\]'
        # ls colours
        # https://askubuntu.com/questions/466198/how-do-i-change-the-color-for-directories-with-ls-in-the-console?newreg=ed7182979b8645b7924b41169df64ac4
        LS_COLORS=$LS_COLORS:'ex=0;31:' ; export LS_COLORS
        LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS

        # pyenv setup
        export PYENV_ROOT="${SOFTWAREDIR}/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        ;;
esac

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# init starship https://starship.rs
eval "$(starship init bash)"
