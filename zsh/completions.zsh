autoload -U compinit; compinit          # Enable auto completion
_comp_options+=(globdots)               # With hidden files

setopt AUTO_LIST                        # Automatically list choices on ambiguous completion.
setopt AUTO_MENU                        # Automatically use menu completion.
setopt AUTO_PARAM_SLASH                 # Add trailing slash for directories.
setopt COMPLETE_IN_WORD                 # Complete from both ends of a word.
setopt GLOB_COMPLETE                    # Show autocompletion menu with globs

# Custom completion functions and widgets
function expand-alias-with-space {
  zle _expand_alias
  zle self-insert
}
zle -N expand-alias-with-space

# Define compilers
zstyle ':completion:*' completer _expand_alias _extensions _complete _approximate # expand aliases, file extensions, main completion, did you mean?
zstyle ':completion:*' regular true

# Configuration
zstyle ':completion:*' file-list all    # Always display (ls -l) details for files
zstyle ':completion:*' menu select      # Select with menu

# Styling
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{green} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# Group completions in a specified order
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# Completion key bindings
zmodload zsh/complist

bindkey -M menuselect '^[' autosuggest-accept      # Accept autosuggestion on escape so we can bound it to enter.
bindkey -M menuselect '^[[Z' reverse-menu-complete # Shift tab to reverse menu complete.
bindkey -M menuselect -s '^M' '^[^[^xa '           # Accept on enter and expand (for unknown reason, escape needs to be pressed twice).
bindkey -M main ' ' expand-alias-with-space        # Expand aliases on space automatically.
