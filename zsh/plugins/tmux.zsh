if ! type tmux &>/dev/null; then
  print "zsh tmux plugin: fzf not found. Please install tmux before using this plugin." >&2
  return 1
fi

if [[ -e $HOME/.tmux.conf ]]; then
  ZSH_TMUX_CONFIG="${HOME}/.tmux.conf"
elif [[ -e ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf ]]; then
  ZSH_TMUX_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
else
  ZSH_TMUX_CONFIG="${HOME}/.tmux.conf"
fi

# Aliases
alias txa="tmux attach-session -dt "
alias txl="tmux ls"
alias txk="tmux kill-session -t "
alias txcfg="$EDITOR $ZSH_TMUX_CONFIG"
