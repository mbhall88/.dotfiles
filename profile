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

export SOFTWAREDIR="$HOME/sw"
export LD_LIBRARY_PATH="${SOFTWAREDIR}/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="${SOFTWAREDIR}/lib/pkgconfig/:$PKG_CONFIG_PATH"
export PATH="${SOFTWAREDIR}/bin/:$PATH"
export CONDA_DIR="${SOFTWAREDIR}/miniforge3"
export PATH="${CONDA_DIR}/bin/:$PATH"

case "$HOSTNAME" in
    *coinlab* | *spartan* | *526080*)
        # allow user and group read, write, and execute permissions on all files/dirs I create
        umask 002
        # rust installed as per https://github.com/rust-lang/rustup/issues/618#issuecomment-570951132
        export CARGO_HOME="${SOFTWAREDIR}/.cargo"
        export RUSTUP_HOME="${SOFTWAREDIR}/.rust"
        export PATH="${CARGO_HOME}/bin:${PATH}"
        . "${CARGO_HOME}/env"

        # set the default squeue format - https://slurm.schedmd.com/squeue.html#OPT_format
        export SQUEUE_FORMAT="%.10i %.30j %.10T %.10P %.20R %.10q %.17S %.10l %.10L %.6m" 
        export SQUEUE_USERS="$USER"
        # set the default output format for sacct - https://slurm.schedmd.com/sacct.html#SECTION_Job-Accounting-Fields
        export SACCT_FORMAT="JobID,JobName%30,ExitCode,State,ReqMem,MaxRSS,Timelimit,Elapsed,Start,End"
        # set the default slurm time format - https://slurm.schedmd.com/sacct.html#OPT_SLURM_TIME_FORMAT
        export SLURM_TIME_FORMAT="%X %d/%m/%y"

        case "$HOSTNAME" in
            *coinlab*)
                # remove system conda from PATH
                export PATH=$(echo $PATH | sed -e 's;:\?/opt/conda/bin;;' -e 's;/opt/conda/bin:\?;;')
                ;;
            *spartan*)
                module load GCCcore/11.3.0
                module load Apptainer/1.1.8
                # add poetry to path
                export PATH="$HOME/.local/bin:$PATH"

                # create array of projects
                export TB_PROJECT="punim1703"
                export DRNA_PROJECT="punim1068"
                export DUNSTAN_PROJ="punim1637"
                export ONTVCB_PROJ="punim2009"
                PROJECTS="$TB_PROJECT $DRNA_PROJECT $DUNSTAN_PROJ $ONTVCB_PROJ"

                # manually set the project dirs to bind
                APPTAINER_BIND=""
                for prj in ${PROJECTS}; do
                    APPTAINER_BIND="${APPTAINER_BIND}/data/scratch/projects/${prj},"
                    APPTAINER_BIND="${APPTAINER_BIND}/data/gpfs/projects/${prj},"
                done
                export APPTAINER_BIND="${APPTAINER_BIND%?}"  # remove trailing comma
                export FZF_ALT_C_COMMAND='fd -It d --search-path /data/scratch/projects/punim2009 --search-path /data/scratch/projects/punim1703 --search-path /data/gpfs/projects/punim1703 --search-path /data/gpfs/projects/punim2009 -E "*.snakemake*"'

                ;;
        esac
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

    *XPS*)
        # rust installed as per https://github.com/rust-lang/rustup/issues/618#issuecomment-570951132
        export CARGO_HOME="${HOME}/.cargo"
        export RUSTUP_HOME="${HOME}/.rustup"
        export PATH="${PATH}:${CARGO_HOME}/bin"
        . "${CARGO_HOME}/env"
        ;;
    *tpgi.com*)
        export POETRY_HOME="$SOFTWAREDIR/poetry"
        export PATH="$POETRY_HOME/bin:$PATH"
        ;;
    *Mac-mini*)
        export POETRY_HOME="$SOFTWAREDIR/poetry"
        export PATH="$POETRY_HOME/bin:$PATH"
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
    eval "$(/opt/Homebrew/bin/brew shellenv)"
fi

# Add rust cargo-installed programs in PATH
if [ -d "${HOME}/.cargo/bin" ]; then
    export PATH="${HOME}/.cargo/bin:$PATH"
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

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

_byobu_sourced=1 . /opt/homebrew/Cellar/byobu/5.133_3/bin/byobu-launch 2>/dev/null || true
