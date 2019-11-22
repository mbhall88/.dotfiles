source "$HOME"/.bashrc
# User configuration

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
else
    echo "Warning: zsh directory could not be found at $ZSHDIR"
fi
