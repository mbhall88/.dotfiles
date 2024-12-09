# User configuration
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

ZSHDIR="${HOME}/.zsh/"

# set vim mode for terminal
# set -o vi

# ========================
# History setup using https://martinheinz.dev/blog/110

# The file to save the history in when an interactive shell exits. If unset, the history is not saved.
HISTFILE="${HOME}/.zsh_history"
# the number of commands to save
HISTSIZE=10000000
# The history is trimmed when its length excedes SAVEHIST by 20%.
SAVEHIST=10000000

HISTORY_IGNORE=('ls' 'ls *' 'cd' 'cd *' 'pwd' 'exit')
setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.
HIST_STAMPS="yyyy-mm-dd"     # adds a timestamp to each line in the history file instead of just the line number

plugins=(git zsh-vi-plugin fzf)

# With that, when you search history, ZSH will automatically use FZF for fuzzy search. This however might use find command in the background which isn't very fast.
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_OPTS='--height 40% --border --highlight-line'

bindkey -v
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget
bindkey '^[[A' fzf-history-widget

# ========================
# dont auto cd when typing the name of a dir
unsetopt auto_cd
# Adds support for command substitution. You'll need this for the suggestion plugins.
setopt prompt_subst
# allow commenting lines with '#' like in bash
setopt interactivecomments
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


# =================================
# auto-suggestion configuration

# will first try to find a suggestion from your history, but, if it can't find a match, will find a suggestion from the completion engine.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^W' forward-word  # accept next word in autosuggestions
bindkey '[1;6C' forward-word  
# ====================================

# git auto-completion needs to know where the bash git complrtion are
if [ -f ~/.git-completion.bash ]; then
    zstyle ':completion:*:*:git:*' script ~/.git-completion.bash
fi

# initialise starship - https://starship.rs/
eval "$(starship init zsh)"

# initialise zoxide - https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

if command -v fzf &> /dev/null
then
    source <(fzf --zsh)
fi

# add rbenv to path
export PATH="$HOME/.rbenv/bin:$PATH"
if [ -x "$(command -v rbenv)" ]; then
    eval "$(rbenv init -)"
fi

eval "$(/home/mihall/sw/miniforge3/bin/conda shell.zsh hook)"

if [ -f "$HOME/.atuin/bin/env" ]; then
    . "$HOME/.atuin/bin/env"
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Aliases are kept in ~/.aliases

# Source zsh plugins
if [ -d "$ZSHDIR" ];then
    source "$ZSHDIR"/zsh-autosuggestions/zsh-autosuggestions.zsh
    source "$ZSHDIR"/alias-tips/alias-tips.plugin.zsh
    source "$ZSHDIR"/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    echo "Warning: zsh directory could not be found at $ZSHDIR"
fi

fpath=( "$ZSHDIR" $fpath )
fpath=( "$HOME/.zsh/zfunctions" $fpath )
eval "$(${HOME}/sw/miniforge3/bin/conda shell.zsh hook)"
