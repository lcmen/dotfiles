# Configuration
Pry.color = true
Pry.editor = 'vim'
Pry.config.prompt = PryRails::RAILS_PROMPT if defined?(PryRails::RAILS_PROMPT)

# Aliases
Pry.commands.alias_command '?', 'show-doc -d'

# Helpers
def pp(obj)
  Pry::ColorPrinter.pp(obj)
end
