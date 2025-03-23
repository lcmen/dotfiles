function _brew_completions() {
  local prefix="$(brew --prefix mise)"
  local completions="${prefix}/share/zsh/site-functions"
  fpath+=("$completions")
}

eval "$(mise activate zsh)"

if type brew &>/dev/null; then
  _brew_completions
fi
