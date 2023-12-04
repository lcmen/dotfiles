#!/usr/bin/env zsh

# Load functions
fpath=($ZDOTDIR/functions $fpath)
autoload -Uz prompt && prompt

# Load files
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/completions.zsh
source $ZDOTDIR/plugins.zsh

# Bash like navigation
autoload -U select-word-style
select-word-style bash

# Enable default Emacs like keybindings (vi-mode is default if `$EDITOR` is set to vim)
bindkey -e
