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
alias less='less -rF'

eval "$(starship init zsh)"

# sesh
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    # session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ' --preview 'sesh preview {}')
    # session=$(sesh list -t -c | tv --preview-command "script -q -c 'sesh preview {}' /dev/null")
    # session=$(sesh list -t -c | tv --preview-command "unbuffer sesh preview {}")

		session=$(sesh list --icons | fzf --height 40% \
			--no-sort --ansi --border-label ' sesh ' --border --prompt '⚡  ' \
			--header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
			--bind 'tab:down,btab:up' \
			--bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
			--bind 'ctrl-t:change-prompt(  )+reload(sesh list -t --icons)' \
			--bind 'ctrl-g:change-prompt(󰢻  )+reload(sesh list -c --icons)' \
			--bind 'ctrl-x:change-prompt(  )+reload(sesh list -z --icons)' \
			--bind 'ctrl-f:change-prompt(  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
			--bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
			--preview-window 'right:55%' \
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

# Activate fuzzy history search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zmodload zsh/complist

source <(jj util completion zsh)

eval "$(zoxide init zsh)"

# The next line enables shell command completion for gcloud.
if [ -f '/home/uchoa/.local/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/uchoa/.local/share/google-cloud-sdk/completion.zsh.inc'; fi
