if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export GTK_IM_MODULE="simple"
fi

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt append_history
setopt extended_history
setopt inc_append_history

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vi=nvim
alias vim=nvim
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias lazydot='lazygit --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias cat='bat --style=numbers'
alias tgit='git -C $HOME/.local/share/task/'
alias ttui='taskwarrior-tui'
alias open='xdg-open'
alias sc='sc-im'
alias scim='sc-im'
alias md='glow --tui'
alias docker='podman'

export EDITOR=nvim
export FZF_DEFAULT_OPTS='--multi --tmux bottom,40%'

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Go programming language configuration
export GOPRIVATE=github.com/begen-ai,github.com/scienti-io,github.com/uchoa
export PATH=$PATH:$HOME/go/bin

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
export PATH="$PATH:/home/uchoa/.local/bin"
