if ! type fzf &>/dev/null; then
  print "zsh fzf plugin: fzf not found. Please install fzf before using this plugin." >&2
  return 1
fi

function _brew_fzf() {
  prefix=$(brew --prefix fzf)
  bindir="${prefix}/bin"

  source "${prefix}/shell/completion.zsh"
  source "${prefix}/shell/key-bindings.zsh"
}

if type brew &>/dev/null; then
  _brew_fzf
fi

# Specify a custom fzf command to use for a a given completion
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    bat|cat)  fzf --preview 'bat --color=always {}' "$@";;
    cd)       fzf --preview 'tree -C {}'   "$@";;
    *)        fzf "$@";;
  esac
}

# ENV variables
export FZF_COMPLETION_TRIGGER="?"
export FZF_DEFAULT_COMMAND="rg --files"
# Scroll preview window (up/down) with ctrl-n/ctrl-p, page up/down with ctrl-f/ctrl-b
export FZF_DEFAULT_OPTS="--height 90% --bind ctrl-q:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up"
# Display preview for for selecting files with ctrl-t and cd'ing with alt-c
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
