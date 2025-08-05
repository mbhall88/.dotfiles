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

case "$HOSTNAME" in
    bunya[0-9]|bun[0-9]*)
        # allow user and group read, write, and execute permissions on all files/dirs I create
        umask 002

        export CARGO_HOME="${HOME}/.cargo"
        export RUSTUP_HOME="${HOME}/.rust"
        export PATH="${CARGO_HOME}/bin:${PATH}"
        . "${CARGO_HOME}/env"

        # set the default squeue format - https://slurm.schedmd.com/squeue.html#OPT_format
        export SQUEUE_FORMAT="%.10i %.30j %.10T %.10P %.20R %.10q %.17S %.10l %.10L %.6m" 
        export SQUEUE_USERS="$USER"
        # set the default output format for sacct - https://slurm.schedmd.com/sacct.html#SECTION_Job-Accounting-Fields
        export SACCT_FORMAT="JobID,JobName%30,ExitCode,State,ReqMem,MaxRSS,Timelimit,Elapsed,Start,End"
        # set the default slurm time format - https://slurm.schedmd.com/sacct.html#OPT_SLURM_TIME_FORMAT
        export SLURM_TIME_FORMAT="%X %d/%m/%y"

        # a function that gets the current usage of my home and scratch space(s) and outputs an error to the screen when
        # I log in if they are over 80% of the limit
        check_rquota_usage() {
            local threshold=80
            local rquota_output
            rquota_output=$(rquota 2>/dev/null)

            # Skip header line and loop over each filesystem
            echo "$rquota_output" | tail -n +2 | while read -r fs used_gb limit_gb used_files limit_files; do
                # Skip lines with missing data
                if [ -z "$used_gb" ] || [ -z "$limit_gb" ] || [ -z "$used_files" ] || [ -z "$limit_files" ]; then
                    continue
                fi

                # Calculate usage percentages
                gb_pct=$(awk -v u="$used_gb" -v l="$limit_gb" 'BEGIN { printf "%.0f", (u/l)*100 }')
                file_pct=$(awk -v u="$used_files" -v l="$limit_files" 'BEGIN { printf "%.0f", (u/l)*100 }')

                if [ "$gb_pct" -ge "$threshold" ] || [ "$file_pct" -ge "$threshold" ]; then
                    echo -e "\e[1;31m"
                    echo "###############################################"
                    echo "###  WARNING: USAGE HIGH ON $fs ###############"
                    echo "###############################################"
                    echo "Used: $used_gb GB out of $limit_gb GB (${gb_pct}%)"
                    echo "Files: $used_files out of $limit_files (${file_pct}%)"
                    echo "###############################################"
                    echo -e "\e[0m"
                fi
            done
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
                export APPTAINER_BIND="${APPTAINER_BIND%?}"  # remove trailing comma
                export FZF_ALT_C_COMMAND='fd -It d --search-path /data/scratch/projects/punim2009 --search-path /data/scratch/projects/punim1703 --search-path /data/gpfs/projects/punim1703 --search-path /data/gpfs/projects/punim2009 -E "*.snakemake*" -E "*.git" -E "*/conda/*'
                export FZF_CTRL_T_COMMAND='fd -I --search-path /data/scratch/projects/punim2009 --search-path /data/scratch/projects/punim1703 --search-path /data/gpfs/projects/punim1703 --search-path /data/gpfs/projects/punim2009 -E "*.snakemake*" -E "*.git" -E "*/conda/*"'

		# Example: Assuming `check_home_usage` outputs "mihall has used 33GB out of 50GB in /home/mihall"
		USAGE=$(check_home_usage | grep -oP 'used \K[0-9]+(?=GB)')  # Extract the used space in GB
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

# git tab auto-completion
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# theme config file for eza
export EZA_CONFIG_DIR="$HOME/.config/eza"

. "$HOME/.local/bin/env"
