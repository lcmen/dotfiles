# Completions for gw (git worktree helper)

function __gw_worktree_names
  git worktree list --porcelain 2>/dev/null | string replace -r --filter '^worktree .*/\.worktrees/([^/]+)$' '$1'
end

function __gw_needs_worktree_name
  set -l tokens (commandline -opc)
  test (count $tokens) -eq 2; and contains -- $tokens[2] open remove
end

# No file completions by default.
complete -c gw -f

set -l commands add remove open list

complete -c gw -n "not __fish_seen_subcommand_from $commands" -a 'add' -d 'Add a new worktree'
complete -c gw -n "not __fish_seen_subcommand_from $commands" -a 'remove' -d 'Remove a worktree'
complete -c gw -n "not __fish_seen_subcommand_from $commands" -a 'open' -d 'Open a worktree'
complete -c gw -n "not __fish_seen_subcommand_from $commands" -a 'list' -d 'List worktrees'

complete -c gw -n '__gw_needs_worktree_name' -a '(__gw_worktree_names)'
