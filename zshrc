# User configuration
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# set vim mode for terminal
set -o vi

# The file to save the history in when an interactive shell exits. If unset, the history is not saved.
HISTFILE="${HOME}/.zsh_history"
# If this is set, zsh sessions will append their history list to the history file, rather than replace it.
setopt append_history
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt hist_ignore_all_dups
# the number of commands to save
HISTSIZE=50000
# The history is trimmed when its length excedes SAVEHIST by 20%.
SAVEHIST=10000
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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Aliases are kept in ~/.aliases

# Source zsh plugins
ZSHDIR="${HOME}/.zsh/"
if [ -d "$ZSHDIR" ];then
    source "$ZSHDIR"/zsh-autosuggestions/zsh-autosuggestions.zsh
    source "$ZSHDIR"/alias-tips/alias-tips.plugin.zsh
    source "$ZSHDIR"/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    echo "Warning: zsh directory could not be found at $ZSHDIR"
fi

fpath=( "$HOME/.zsh/zfunctions" $fpath )

# =================================
# auto-suggestion configuration

# will first try to find a suggestion from your history, but, if it can't find a match, will find a suggestion from the completion engine.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# ====================================

# initialise starship - https://starship.rs/
eval "$(starship init zsh)"

# initialise zoxide - https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# add pyenv to path
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi

# add rbenv to path
export PATH="$HOME/.rbenv/bin:$PATH"
if [ -x "$(command -v rbenv)" ]; then
    eval "$(rbenv init -)"
fi

