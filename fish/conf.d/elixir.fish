# Elixir / Erlang
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx MIX_HOME "$XDG_DATA_HOME/mix"
set -gx HEX_HOME "$XDG_CACHE_HOME/hex"
fish_add_path "$XDG_DATA_HOME/mix/escripts"

abbr -a mc 'iex -S mix'
abbr -a mdg 'mix deps.get'
abbr -a mdu 'mix deps.update'
abbr -a phx 'mix phx.server'
