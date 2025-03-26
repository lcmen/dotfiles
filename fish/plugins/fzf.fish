function _brew_fzf --description "Set up fish completion for fzf"
  set -l prefix (brew --prefix fzf)
  set -l bindir "$prefix/bin"

  fzf --fish | source
end

if command -v brew >/dev/null 2>&1
  _brew_fzf
end

set -gx FZF_COMPLETION_TRIGGER "?"
set -gx FZF_DEFAULT_COMMAND "rg --files"

# Scroll preview window (up/down) with ctrl-n/ctrl-p, page up/down with ctrl-f/ctrl-b
set -gx FZF_DEFAULT_OPTS "--height 90% --bind ctrl-q:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up"

# Display preview for for selecting files with ctrl-t and cd'ing with alt-c
set -gx FZF_CTRL_T_OPTS "--preview 'bat -n --color=always {}'"
set -gx FZF_ALT_C_OPTS "--preview 'tree -C {}'"
