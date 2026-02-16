# Completions for gw (git worktree helper)

# No file completions by default
complete -c gw -f

# Subcommands (only when no subcommand given yet)
complete -c gw -n '__fish_use_subcommand' -a 'add' -d 'Add a new worktree'
complete -c gw -n '__fish_use_subcommand' -a 'remove' -d 'Remove a worktree'

# "remove": complete with branches that have active worktrees
complete -c gw -n '__fish_seen_subcommand_from remove' -a '(git worktree list --porcelain 2>/dev/null | string match "branch refs/heads/*" | string replace "branch refs/heads/" "")'