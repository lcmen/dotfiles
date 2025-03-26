if not command -q tmux
  echo "fish tmux plugin: tmux not found. Please install tmux before using this plugin." >&2
  exit 1
end

if test -e $HOME/.tmux.conf
  set -g TMUX_CONFIG "$HOME/.tmux.conf"
else if test -e "$XDG_CONFIG_HOME/tmux/tmux.conf"
  set -g TMUX_CONFIG "$XDG_CONFIG_HOME/tmux/tmux.conf"
else
  set -g TMUX_CONFIG "$HOME/.tmux.conf"
end

# Aliases
function txa
  tmux attach-session -dt $argv
end

function txl
  tmux ls
end

function txk
  tmux kill-session -t $argv
end

function txcfg
  $EDITOR $TMUX_CONFIG
end
