if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export GTK_IM_MODULE="simple"
fi

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt append_history
setopt extended_history
setopt inc_append_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vi=nvim
alias vim=nvim
# alias cat='bat --style=numbers'
alias open='xdg-open'
alias sc='sc-im'
alias scim='sc-im'
alias md='glow --tui'
alias docker='podman'

export EDITOR=nvim
export FZF_DEFAULT_OPTS='--multi --tmux bottom,40%'

export ZK_NOTEBOOK_DIR=$HOME/.notebook

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Go programming language configuration
export GOPRIVATE=github.com/begen-ai,github.com/scienti-io,github.com/uchoa,gitlab.com/scienti,gitlab.com/auchoa
export PATH=$PATH:$HOME/go/bin

export PATH=$PATH:$HOME/.cache/.bun/bin

# sesh
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    # session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ' --preview 'sesh preview {}')
    # session=$(sesh list -t -c | tv --preview-command "script -q -c 'sesh preview {}' /dev/null")
    # session=$(sesh list -t -c | tv --preview-command "unbuffer sesh preview {}")

		session=$(sesh list --icons | fzf --height 80% \
			--no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
			--header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
			--bind 'tab:down,btab:up' \
			--bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
			--bind 'ctrl-t:change-prompt(  )+reload(sesh list -t --icons)' \
			--bind 'ctrl-g:change-prompt(󰢻  )+reload(sesh list -c --icons)' \
			--bind 'ctrl-x:change-prompt(  )+reload(sesh list -z --icons)' \
			--bind 'ctrl-f:change-prompt(  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
			--bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
			--preview 'sesh preview {}'
		)

    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# Activate syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable underline when highlighting
(( ${+ZSH_HIGHLIGH_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -Uz compinit
compinit

source <(jj util completion zsh)

eval "$(zoxide init zsh)"

# Created by `pipx` on 2025-06-20 01:00:54
export PATH="$PATH:$HOME/.local/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
