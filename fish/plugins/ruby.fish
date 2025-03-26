function _rails_command
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

function _rake_command
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

function bi
  bundle install
end

function bl
  bundle list
end

function bu
  bundle update
end

function be
  bundle exec $argv
end

function br
  bundle exec gem remove $argv
end

function rails
  _rails_command $argv
end

function rake
  _rake_command $argv
end

function rc
  rails console
end

function rs
  rails server
end

function rdb
  rails dbconsole
end

function rdc
  rails db:create
end

function rdd
  rails db:drop
end

function rdm
  rails db:migrate
end

function rdr
  rails db:rollback
end

function rdbg
  bundle exec rdbg -An
end

function rspec
  bundle exec rspec $argv
end

