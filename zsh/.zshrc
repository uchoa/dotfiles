# Environment & PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.local/bin:$BUN_INSTALL/bin:$PATH"

# Google Cloud SDK PATH
if [ -f '/home/uchoa/.local/share/google-cloud-sdk/path.zsh.inc' ]; then
  . '/home/uchoa/.local/share/google-cloud-sdk/path.zsh.inc'
fi

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
setopt append_history
setopt extended_history
setopt inc_append_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
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

# Completion module and init
zmodload zsh/complist
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

# Tool completions
command -v jj >/dev/null 2>&1 && source <(jj util completion zsh)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v herdr >/dev/null 2>&1 && eval "$(herdr completion zsh)"
command -v omp >/dev/null 2>&1 && eval "$(omp completions zsh)"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Google Cloud SDK completions
if [ -f '/home/uchoa/.local/share/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/home/uchoa/.local/share/google-cloud-sdk/completion.zsh.inc'
fi

# Herdr session switcher
hsch() {
  local session
  session=$(herdr session list | awk 'NR>1 {print $1}' | fzf --border --header="Switch Herdr Session")

  zle reset-prompt > /dev/null 2>&1 || true
  [[ -z "$session" ]] && return

  BUFFER="herdr session attach ${(q)session}"
  zle accept-line
}
zle -N hsch_widget hsch
bindkey -M emacs '\eh' hsch_widget
bindkey -M vicmd '\eh' hsch_widget
bindkey -M viins '\eh' hsch_widget

# Sesh session switcher
function sesh-sessions() {
  local session
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

  BUFFER="sesh connect ${(q)session}"
  zle accept-line
}
zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# Autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Fuzzy history substring search
if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

  # Bind Up and Down arrow keys for both ANSI and application cursor modes
  bindkey '^[[A' history-substring-search-up
  bindkey '^[OA' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^[OB' history-substring-search-down

  # Bind k/j in vicmd mode
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi

# Syntax Highlighting - MUST BE LAST
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  # Disable underline when highlighting paths
  (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[path]=none
  ZSH_HIGHLIGHT_STYLES[path_prefix]=none

  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
