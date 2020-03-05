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

# set spaceship themed prompt https://github.com/denysdovhan/spaceship-prompt
autoload -U promptinit; promptinit
prompt spaceship


# Number of folders of cwd to show in prompt, 0 to show all
SPACESHIP_DIR_TRUNC=0
# While in git repo, show only root directory and folders inside it
SPACESHIP_DIR_TRUNC_REPO=false

SPACESHIP_TIME_SHOW=true

spaceship_vi_mode_enable

SPACESHIP_RPROMPT_ORDER=(
  time          # Time stamps section
)
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  rust          # Rust section
  venv          # virtualenv section
  pyenv         # Pyenv section
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# add pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
