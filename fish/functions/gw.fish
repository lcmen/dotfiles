function gw --description "Git worktree wrapper"
  set -l output (command gw $argv)
  set -l status_code $status

  if test (count $output) -eq 1; and test -d "$output[1]"
    cd "$output[1]"
  else if test (count $output) -gt 0
    printf "%s\n" $output
  end

  return $status_code
end
