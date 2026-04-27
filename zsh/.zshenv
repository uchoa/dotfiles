# Set up gpg-agent for SSH
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
# Ensure gpg-agent is running
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

export XCURSOR_THEME="phinger-cursors-dark"
export XCURSOR_SIZE=48
export BAT_PAGER="less -rF"

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export GTK_IM_MODULE="simple"
fi

export EDITOR=nvim
export TERMINAL=$(which ghostty)
export FZF_DEFAULT_OPTS='--multi --tmux bottom,40%'
export ZK_NOTEBOOK_DIR=$HOME/.notebook
export STARSHIP_CONFIG=~/.config/starship/starship.toml

export GOPRIVATE=github.com/begen-ai,github.com/scienti-io,github.com/uchoa,gitlab.com/scienti,gitlab.com/auchoa

# Ensure PATH entries are unique
typeset -U path PATH

path+=("$HOME/go/bin")
path+=("$HOME/.local/bin")
export PATH

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
path=("$PNPM_HOME" $path)
export PATH
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/uchoa/.local/share/google-cloud-sdk/path.zsh.inc' ]; then . '/home/uchoa/.local/share/google-cloud-sdk/path.zsh.inc'; fi


