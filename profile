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

# ===================================
# Section for loading profile for cluster

case "$HOSTNAME" in
    *noah* | *yoda* | *gpu*)

        # Source global definitions
        if [ -f /etc/bashrc ]; then
        	. /etc/bashrc
        fi

        case "$HOSTNAME" in
            *noah*)
                LUSTRE="/hps/nobackup/research/zi/mbhall"
                NFS="/nfs/research1/zi/mbhall"
                export ftp_site=/ebi/ftp/private/madagascox
                export SOFTWAREDIR="${NFS}/Software"
                ;;
            *yoda*)
                LUSTRE="/hps/nobackup/iqbal/mbhall"
                NFS="/nfs/leia/research/iqbal/mbhall"
                export SOFTWAREDIR="${NFS}/Software"
                ;;
            esac

        . "${SOFTWAREDIR}/sourceme"

        export PATH="${SOFTWAREDIR}/bin/:$PATH"

        # added by Miniconda3 4.5.12 installer
        export PATH="${PATH}:${SOFTWAREDIR}/miniconda3/bin"

        # make --user pip installs in path
        export PATH="$HOME/.local/bin:$PATH"

        # required to run jupyter
        export XDG_RUNTIME_DIR=""

        # set the singularity cache directory to where I want it rather than the default
        export SINGULARITY_CACHEDIR="${SOFTWAREDIR}/Singularity_images"

        # allow user and group read, write, and execute permissions on all files/dirs I create
        umask 002

        alias lustre="cd ${LUSTRE}"
        alias nfs="cd ${NFS}"

        # farmpy needs to know what memory units LSF uses
        export FARMPY_LSF_MEMORY_UNITS="MB"
        ;;
esac

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

OS=$(uname -s)
if [ "$OS" = Darwin ]; then
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

# set location of starship config https://starship.rs/
export STARSHIP_CONFIG="${HOME}/.starship.toml"

export PATH="$HOME/.poetry/bin:$PATH"

# set nord theme as default for dircolors - https://www.nordtheme.com/docs/ports/dircolors/
if [ -r "${HOME}/.dir_colors" ]; then
    if [ "$OS" = Darwin ]; then
        eval "$(gdircolors ~/.dir_colors)"
    else
        eval "$(dircolors ~/.dir_colors)"
    fi
fi
