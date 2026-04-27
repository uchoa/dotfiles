# Setting up tmux-256color on Void Linux

Void Linux does not ship with the `tmux-256color` terminal definition (terminfo) by default. Without this definition, running `tmux` with `set -g default-terminal "tmux-256color"` will cause terminal applications (and line editors like `zsh`) to fall back to a dumb terminal mode, resulting in characters incorrectly echoing and overlapping on the prompt.

To fix this and enable proper truecolor and italics support inside `tmux`, download and compile the terminal definitions locally:

```bash
# Download the latest terminfo source file
curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz

# Extract the source file
gunzip terminfo.src.gz

# Compile the tmux-256color terminfo definition into your ~/.terminfo directory
tic -x -e tmux-256color terminfo.src

# Clean up
rm terminfo.src
```

After installing the terminfo file, fully restart the tmux server:

```bash
tmux kill-server
tmux
```
