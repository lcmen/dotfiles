function procs --description "Filter processes with PID, CPU, and MB memory usage"
  # Added 'pid' to the start of the ps command
  set -l ps_command "ps -eo pid,pcpu,pmem,rss,args --sort=-rss"

  if test -n "$argv[1]"
    set -l search_term "$argv[1]"
    set -l first_char (string sub -l 1 -- $search_term)
    set -l rest (string sub -s 2 -- $search_term)

    # $1=PID, $2=CPU, $4=RSS, $5=CMD
    eval $ps_command | grep "[$first_char]$rest" | awk '{printf "PID: %-7s | CPU: %5s%% | RSS: %7.2f MB | CMD: %s\n", $1, $2, $4/1024, $5}'
  else
    # NR>1 skips the header row
    eval $ps_command | awk 'NR>1 {printf "PID: %-7s | CPU: %5s%% | RSS: %7.2f MB | CMD: %s\n", $1, $2, $4/1024, $5}'
  end
end
