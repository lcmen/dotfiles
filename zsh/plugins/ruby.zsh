function _rails_command () {
  if [ -e "bin/stubs/rails" ]; then
    bin/stubs/rails $@
  elif [ -e "bin/rails" ]; then
    bin/rails $@
  elif type bundle &> /dev/null && [[ -e "Gemfile" ]]; then
    bundle exec rails $@
  else
    command rails $@
  fi
}

function _rake_command () {
  if [ -e "bin/stubs/rake" ]; then
    bin/stubs/rake $@
  elif [ -e "bin/rake" ]; then
    bin/rake $@
  elif type bundle &> /dev/null && [[ -e "Gemfile" ]]; then
    bundle exec rake $@
  else
    command rake $@
  fi
}

# ENV variables
export BUNDLE_USER_HOME="${XDG_CONFIG_HOME}/bundle"
export GEMRC="${XDG_CONFIG_HOME}/gem/config"

# Aliases
alias RED='RAILS_ENV=development'
alias REP='RAILS_ENV=production'
alias RET='RAILS_ENV=test'

alias bi="bundle install"
alias bl="bundle list"
alias bu="bundle update"
alias be="bundle exec"
alias br="bundle exec gem remove"

alias rails='_rails_command'
alias rake='_rake_command'

alias rc='rails console'
alias rs='rails server'
alias rdb='rails dbconsole'
alias rdc='rails db:create'
alias rdd='rails db:drop'
alias rdm='rails db:migrate'
alias rdr='rails db:rollback'
alias rdbg='bundle exec rdbg -An'
