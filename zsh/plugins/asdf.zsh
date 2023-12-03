function _brew_completions() {
  local prefix="$(brew --prefix asdf)"
  local completions="${prefix}/share/zsh/site-functions"
  fpath+=("$completions")
}

if [ -x "$(command -v asdf)" ]; then
  asdf_path=$(realpath $(which asdf))
  . $(dirname $asdf_path)/../libexec/asdf.sh
fi

if type brew &>/dev/null; then
  _brew_completions
fi

autoload -Uz _asdf
compdef _asdf asdf

# ENV variables
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/config"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=".config/asdf/tool-versions"
