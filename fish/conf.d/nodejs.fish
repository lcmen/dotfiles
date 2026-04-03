# Node.js
set -gx NPM_CONFIG_PREFIX "$XDG_DATA_HOME/npm"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
fish_add_path "$XDG_DATA_HOME/npm/bin"
