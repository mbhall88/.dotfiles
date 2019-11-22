# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
#         . "$HOME/.bashrc"
#     fi
# fi
#
# # if running zsh
# if [ -n "$ZSH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.zshrc" ]; then
#         . "$HOME/.zshrc"
#     fi
# fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

OS=$(uname -s)
if [ "$OS" = Linux ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ "$OS" = Darwin ]; then
    eval "$(/usr/local/Homebrew/bin/brew shellenv)"
    # readline is keg-only, which means it was not symlinked into /usr/local,
    # because macOS provides the BSD libedit library, which shadows libreadline.
    # In order to prevent conflicts when programs look for libreadline we are
    # defaulting this GNU Readline installation to keg-only.
    #
    # For compilers to find readline you may need to set:
    export LDFLAGS="-L/usr/local/opt/readline/lib"
    export CPPFLAGS="-I/usr/local/opt/readline/include"
    #
    # For pkg-config to find readline you may need to set:
    export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"
else
    echo "Warning: OS '$OS' is not Linux or Darwin."
fi

# added by travis gem
if [ -f "${HOME}/.travis/travis.sh" ]; then
    . "${HOME}/.travis/travis.sh"
fi


# Add rust cargo-installed programs in PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Preferred editor for local and remote sessions
export VISUAL=vim
export EDITOR="$VISUAL"

# add pulse sercure to LD PATH
if [ -d /usr/local/pulse ]; then
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/pulse"
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.aliases ]; then
    # shellcheck source=/dev/null
    . ~/.aliases
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
