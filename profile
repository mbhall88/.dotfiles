# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

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
export MANPATH="$HOME/sw/share/man:$HOME/sw/man:$MANPATH"

case "$HOSTNAME" in
bunya[0-9]* | bun[0-9]*)
    # allow user and group read, write, and execute permissions on all files/dirs I create
    umask 002

    export CARGO_HOME="${HOME}/.cargo"
    export RUSTUP_HOME="${HOME}/.rust"
    export PATH="${CARGO_HOME}/bin:${PATH}"
    . "${CARGO_HOME}/env"
    export APPTAINER_CACHEDIR="/scratch/user/uqmhal11/.apptainer"

    # set the default squeue format - https://slurm.schedmd.com/squeue.html#OPT_format
    export SQUEUE_FORMAT="%.10i %.30j %.10T %.10P %.20R %.10q %.17S %.10l %.10L %.6m"
    export SQUEUE_USERS="$USER"
    # set the default output format for sacct - https://slurm.schedmd.com/sacct.html#SECTION_Job-Accounting-Fields
    export SACCT_FORMAT="JobID,JobName%30,ExitCode,State,ReqMem,MaxRSS,Timelimit,Elapsed,Start,End"
    # set the default slurm time format - https://slurm.schedmd.com/sacct.html#OPT_SLURM_TIME_FORMAT
    export SLURM_TIME_FORMAT="%X %d/%m/%y"

    export BAKTA_DB="/scratch/opendata/genomics/Bakta/v6/db"
    export CHECKM2DB="/scratch/opendata/genomics/CheckM2/version_3/CheckM2_database"

    # a function that gets the current usage of my home and scratch space(s) and outputs an error to the screen when
    # I log in if they are over 80% of the limit
    check_rquota_usage() {
        command -v rquota >/dev/null 2>&1 || return 0

        local threshold=80
        rquota 2>/dev/null | awk -v t="$threshold" '
            NR==1 { next }  # skip header
            {
              fs=$1; ug=$2; lg=$3; uf=$4; lf=$5
              # require numeric values; skip lines with missing data
              if (fs=="" || ug=="" || lg=="" || uf=="" || lf=="") next
              if (ug !~ /^[0-9.]+$/ || lg !~ /^[0-9.]+$/ || uf !~ /^[0-9.]+$/ || lf !~ /^[0-9.]+$/) next

              gbpct = (lg==0 ? -1 : int((ug/lg)*100 + 0.5))
              filepct = (lf==0 ? -1 : int((uf/lf)*100 + 0.5))

              warn = (gbpct != -1 && gbpct >= t) || (filepct != -1 && filepct >= t)
              if (warn) {
                printf("\033[1;31m\n")
                print  "###############################################"
                printf("###  WARNING: USAGE HIGH ON %s ###############\n", fs)
                print  "###############################################"
                printf("Used: %s GB out of %s GB (%s)\n", ug, lg, (gbpct==-1 ? "unlimited" : gbpct "%"))
                printf("Files: %s out of %s (%s)\n",       uf, lf, (filepct==-1 ? "unlimited" : filepct "%"))
                print  "###############################################"
                printf("\033[0m\n")
              }
            }'
    }
    check_rquota_usage
    ;;
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
        module load OpenSSL/3
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
        export APPTAINER_BIND="${APPTAINER_BIND%?}" # remove trailing comma
        export FZF_ALT_C_COMMAND='fd -It d --search-path /data/scratch/projects/punim2009 --search-path /data/scratch/projects/punim1703 --search-path /data/gpfs/projects/punim1703 --search-path /data/gpfs/projects/punim2009 -E "*.snakemake*" -E "*.git" -E "*/conda/*'
        export FZF_CTRL_T_COMMAND='fd -I --search-path /data/scratch/projects/punim2009 --search-path /data/scratch/projects/punim1703 --search-path /data/gpfs/projects/punim1703 --search-path /data/gpfs/projects/punim2009 -E "*.snakemake*" -E "*.git" -E "*/conda/*"'

        # Example: Assuming `check_home_usage` outputs "mihall has used 33GB out of 50GB in /home/mihall"
        USAGE=$(check_home_usage | grep -oP 'used \K[0-9]+(?=GB)')   # Extract the used space in GB
        QUOTA=$(check_home_usage | grep -oP 'out of \K[0-9]+(?=GB)') # Extract the quota in GB

        if [ -z "$USAGE" ] || [ -z "$QUOTA" ]; then
            echo "Error: Unable to retrieve home usage information."
            return
        fi

        PERCENTAGE=$(echo "($USAGE / $QUOTA) * 100" | bc -l | awk '{printf "%.0f", $0}')

        if [ "$PERCENTAGE" -ge 80 ]; then
            echo -e "\e[1;31m"
            echo "###############################################"
            echo "##########  WARNING: DISK USAGE HIGH  #########"
            echo "###############################################"
            echo -e "You have used $PERCENTAGE% of your quota in $HOME ($USAGE GB out of $QUOTA GB)."
            echo "###############################################"
            echo "###############################################"
            echo -e "\e[0m"
        fi
        ;;
    esac
    ;;

*Mac-mini*)
    export POETRY_HOME="$SOFTWAREDIR/poetry"
    export PATH="$POETRY_HOME/bin:$PATH"
    ;;
esac

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
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
export VISUAL=nvim
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

# theme config file for eza
export EZA_CONFIG_DIR="$HOME/.config/eza"

. "$HOME/.local/bin/env"
