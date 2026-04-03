# Language runtime configurations
# Consolidated from: elixir.fish, golang.fish, nodejs.fish, ruby.fish

# Elixir / Erlang
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx MIX_HOME "$XDG_DATA_HOME/mix"
set -gx HEX_HOME "$XDG_CACHE_HOME/hex"
fish_add_path "$XDG_DATA_HOME/mix/escripts"

abbr -a mc 'iex -S mix'
abbr -a mdg 'mix deps.get'
abbr -a mdu 'mix deps.update'
abbr -a phx 'mix phx.server'

# Go
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GOMODCACHE "$XDG_CACHE_HOME/go/mod"
fish_add_path "$XDG_DATA_HOME/go/bin"

# Node.js
set -gx NPM_CONFIG_PREFIX "$XDG_DATA_HOME/npm"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
fish_add_path "$XDG_DATA_HOME/npm/bin"

# Ruby
function _rails_command --description "Run rails command"
  if test -e "bin/stubs/rails"
    bin/stubs/rails $argv
  else if test -e "bin/rails"
    bin/rails $argv
  else if command -v bundle >/dev/null 2>&1; and test -e "Gemfile"
    bundle exec rails $argv
  else
    command rails $argv
  end
end

function _rake_command --description "Run rake command"
  if test -e "bin/stubs/rake"
    bin/stubs/rake $argv
  else if test -e "bin/rake"
    bin/rake $argv
  else if command -v bundle >/dev/null 2>&1; and test -e "Gemfile"
    bundle exec rake $argv
  else
    command rake $argv
  end
end

function rails
  _rails_command $argv
end

function rake
  _rake_command $argv
end

set -gx BUNDLE_USER_HOME "$XDG_CONFIG_HOME/bundle"
set -gx GEMRC "$XDG_CONFIG_HOME/gem/config"
set -gx GEM_HOME "$XDG_DATA_HOME/gems"
set -gx BUNDLE_PATH "$XDG_DATA_HOME/bundle"
fish_add_path "$XDG_DATA_HOME/gems/bin"

abbr -a bi 'bundle install'
abbr -a bl 'bundle list'
abbr -a bu 'bundle update'
abbr -a be 'bundle exec'
abbr -a br 'bundle exec gem remove'
abbr -a rc 'rails console'
abbr -a rs 'rails server'
abbr -a rdb 'rails dbconsole'
abbr -a rdc 'rails db:create'
abbr -a rdd 'rails db:drop'
abbr -a rdm 'rails db:migrate'
abbr -a rdr 'rails db:rollback'
abbr -a rdbg 'bundle exec rdbg'
abbr -a rspec 'bundle exec rspec'
