function _brew_completions --description "Set up fish completion for mise installed with Homebrew"
  set -l prefix (brew --prefix mise)
  set -l completions "$prefix/share/fish/vendor_completions.d"
  set -p fish_complete_path "$completions"
end

if command -v brew >/dev/null 2>&1
  _brew_completions
end

mise activate fish | source
