# System
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# Specify config paths to use XDG_CONFIG_HOME
set -gx PSQLRC "$XDG_CONFIG_HOME/psql/config"
set -gx PGPASSFILE "$XDG_CONFIG_HOME/psql/pgpass"
set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"

# PATHs
fish_add_path "./node_modules/.bin"  # Local node_modules binaries
fish_add_path "$HOME/.bin"           # Local binaries
fish_add_path "/usr/local/sbin"      # Homebrew binaries (if installed)

# Load all plugins
for file in $XDG_CONFIG_HOME/fish/plugins/*.fish
  source $file
end
