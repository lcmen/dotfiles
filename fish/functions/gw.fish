function gw --description "Git worktree wrapper"
  command gw $argv
  and if test "$argv[1]" = remove
    exit
  end
end
