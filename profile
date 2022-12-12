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
if [ -z "$HOSTNAME" ] && [ ! -z $HOST ]; then
    export HOSTNAME="$HOST"
fi

case "$HOSTNAME" in
    *coinlab* | *awoonga* | *wiener* | *tinaroo* | *spartan*)
        export SOFTWAREDIR="$HOME/sw"
        export LD_LIBRARY_PATH="${SOFTWAREDIR}/lib:$LD_LIBRARY_PATH"
        export PKG_CONFIG_PATH="${SOFTWAREDIR}/lib/pkgconfig/:$PKG_CONFIG_PATH"
        export PATH="${SOFTWAREDIR}/bin/:$PATH"
        # allow user and group read, write, and execute permissions on all files/dirs I create
        umask 002
        # rust installed as per https://github.com/rust-lang/rustup/issues/618#issuecomment-570951132
        export CARGO_HOME="${SOFTWAREDIR}/.cargo"
        export RUSTUP_HOME="${SOFTWAREDIR}/.rust"
        export PATH="${PATH}:${CARGO_HOME}/bin"
        . "${CARGO_HOME}/env"

        # set the default squeue format - https://slurm.schedmd.com/squeue.html#OPT_format
        export SQUEUE_FORMAT="%.10i %.20j %.10T %.10P %.20R %.10q %.17S %.10l %.10L %.6m" 
        export SQUEUE_USERS="$USER"
        # set the default output format for sacct - https://slurm.schedmd.com/sacct.html#SECTION_Job-Accounting-Fields
        export SACCT_FORMAT="JobID,JobName%20,ExitCode,State,ReqMem,MaxRSS,Timelimit,Elapsed,Start,End"
        # set the default slurm time format - https://slurm.schedmd.com/sacct.html#OPT_SLURM_TIME_FORMAT
        export SLURM_TIME_FORMAT="%X %d/%m/%y"

        case "$HOSTNAME" in
            *wiener*)
                module load singularity/3.4.1
                ;;
            *awoonga* | *tinaroo*)
                # load modules
                module load singularity/3.5.0
                ;;
            *coinlab*)
                # remove system conda from PATH
                export PATH=$(echo $PATH | sed -e 's;:\?/opt/conda/bin;;' -e 's;/opt/conda/bin:\?;;')
                ;;
            *spartan*)
                module load git/2.23.0-nodocs singularity/3.8.5

                # create array of projects
                export TB_PROJECT="punim1703"
                export DRNA_PROJECT="punim1068"
                PROJECTS="$TB_PROJECT $DRNA_PROJECT"

                # manually set the project dirs to bind
                SINGULARITY_BIND=""
                for prj in ${PROJECTS}; do
                    SINGULARITY_BIND="${SINGULARITY_BIND}/data/scratch/projects/${prj},"
                    SINGULARITY_BIND="${SINGULARITY_BIND}/data/gpfs/projects/${prj},"
                done
                export SINGULARITY_BIND="${SINGULARITY_BIND%?}"  # remove trailing comma

                ;;
        esac
        # add conda to path
        export PATH="${SOFTWAREDIR}/miniconda3/bin:${PATH}"

        ;;
    *codon*)
        # Source global definitions
        if [ -f /etc/bashrc ]; then
        	. /etc/bashrc
        fi

        # load modules
        module load singularity-3.7.0-gcc-9.3.0-dp5ffrp \
          gcc-9.3.0-gcc-9.3.0-lnsweiq \
          cmake-3.19.5-gcc-9.3.0-z5ntmum \
          zlib-1.2.11-gcc-9.3.0-7oy27qp \
          cuda-11.1.1-gcc-9.3.0-oqr2b7d

        export LUSTRE="/hps/nobackup/iqbal/mbhall/"
        export NFS="/nfs/research/zi/mbhall/"
        export SOFTWAREDIR="${NFS}/Software"
        export LD_LIBRARY_PATH="${SOFTWAREDIR}/lib:$LD_LIBRARY_PATH"
        export PKG_CONFIG_PATH="${SOFTWAREDIR}/lib/pkgconfig/:$PKG_CONFIG_PATH"
        export PATH="${SOFTWAREDIR}/bin/:$PATH"
        # avoids singularity failing
        export SINGULARITY_CONTAIN=TRUE
        export SINGULARITY_BINDPATH="$(dirname $NFS),$(dirname $LUSTRE),/homes,/tmp"

        # required to run jupyter
        export XDG_RUNTIME_DIR=""

        # set the singularity cache directory to where I want it rather than the default
        export SINGULARITY_CACHEDIR="${SOFTWAREDIR}/.singularity_cache/"

        # allow user and group read, write, and execute permissions on all files/dirs I create
        umask 002

        alias lustre="cd ${LUSTRE}"
        alias nfs="cd ${NFS}"

        # farmpy needs to know what memory units LSF uses
        export FARMPY_LSF_MEMORY_UNITS="MB"

        # prevent bash overridding byobu session names.
        # see https://stackoverflow.com/questions/28475335/byobu-renames-windows-in-ssh-session
        unset PROMPT_COMMAND

        # rust installed as per https://github.com/rust-lang/rustup/issues/618#issuecomment-570951132
        export CARGO_HOME="${SOFTWAREDIR}/.cargo"
        export RUSTUP_HOME="${SOFTWAREDIR}/.rust"
        export PATH="${PATH}:${CARGO_HOME}/bin"

        # fast access software dir
        export FASTSW_DIR="/hps/software/users/iqbal/mbhall"
        export PATH="${FASTSW_DIR}/bin/:$PATH"

        # add conda to path
        export PATH="${FASTSW_DIR}/miniconda3/bin:${PATH}"
        ;;

    *noah* | *yoda* | *gpu*)

        # Source global definitions
        if [ -f /etc/bashrc ]; then
        	. /etc/bashrc
        fi

        # load singularity v3
        module load singularity/3.5.0

        case "$HOSTNAME" in
            *noah*)
                export LUSTRE="/hps/nobackup/research/zi/mbhall"
                export NFS="/nfs/research1/zi/mbhall"
                export ftp_site=/ebi/ftp/private/madagascox
                export SOFTWAREDIR="${NFS}/Software"
                export LD_LIBRARY_PATH="${SOFTWAREDIR}/lib:$LD_LIBRARY_PATH"
                export PKG_CONFIG_PATH="${SOFTWAREDIR}/lib/pkgconfig/:$PKG_CONFIG_PATH"
                ;;
            *yoda*)
                export LUSTRE="/hps/nobackup/iqbal/mbhall"
                export NFS="/nfs/leia/research/iqbal/mbhall"
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

        # pyenv setup
        export PYENV_ROOT="${SOFTWAREDIR}/.pyenv"

        # prevent bash overridding byobu session names.
        # see https://stackoverflow.com/questions/28475335/byobu-renames-windows-in-ssh-session
        unset PROMPT_COMMAND
        ;;
    *XPS*)
        export SOFTWAREDIR="$HOME/sw"
        export LD_LIBRARY_PATH="${SOFTWAREDIR}/lib:$LD_LIBRARY_PATH"
        export PKG_CONFIG_PATH="${SOFTWAREDIR}/lib/pkgconfig/:$PKG_CONFIG_PATH"
        export PATH="${SOFTWAREDIR}/bin/:$PATH"
        # rust installed as per https://github.com/rust-lang/rustup/issues/618#issuecomment-570951132
        export CARGO_HOME="${HOME}/.cargo"
        export RUSTUP_HOME="${HOME}/.rustup"
        export PATH="${PATH}:${CARGO_HOME}/bin"
        . "${CARGO_HOME}/env"
        # add conda to path
        export PATH="${SOFTWAREDIR}/miniconda3/bin:${PATH}"

        ;;
    *)

        export GOPATH="${HOME}/go"

        # add conda to PATH
        export PATH="${HOME}/Programs/miniconda3/bin:${PATH}"
        ;;
esac


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
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

# add GO to PATH
export PATH="$PATH:/usr/local/go/bin"

# Add rust cargo-installed programs in PATH
if [ -d "${HOME}/.cargo/bin" ]; then
    fi

# Preferred editor for local and remote sessions
export VISUAL=vim
export EDITOR="$VISUAL"

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

# set theme for bat
export BAT_THEME="Nord"

# set location of starship config https://starship.rs/
export STARSHIP_CONFIG="${HOME}/.starship.toml"

# use pyenv python for byobu
export BYOBU_PYTHON='/usr/bin/env python3'

# set nord theme as default for dircolors - https://www.nordtheme.com/docs/ports/dircolors/
if [ -r "${HOME}/.dir_colors" ]; then
    if [ "$OS" = Darwin ]; then
        eval "$(gdircolors ~/.dir_colors)"
    else
        eval "$(dircolors ~/.dir_colors)"
    fi
fi
<<<<<<< Updated upstream

export PATH="$HOME/.poetry/bin:$PATH"
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
=======
>>>>>>> Stashed changes
