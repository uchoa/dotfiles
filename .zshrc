# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vi=nvim
alias vim=nvim
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias lazydot='lazygit --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias cat='bat --style=numbers'
alias tgit='git -C $HOME/.local/share/task/'

export EDITOR=nvim
export ZK_NOTEBOOK_DIR=$HOME/notebook/
# export SSH_AUTH_SOCK='$XDG_RUNTIME_DIR/ssh-agent.socket'

# Make sure ssh-agent is running
eval 'keychain 2>/dev/null'
source $HOME/.keychain/$HOST-sh

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Activate syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable underline when highlighting
(( ${+ZSH_HIGHLIGH_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
