function gw --description "Git worktree wrapper"
  if test "$argv[1]" = "add"
    cd (command gw $argv | tail -n 1)
  else
    command gw $argv
  end
end
