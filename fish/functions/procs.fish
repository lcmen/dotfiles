function procs --description "Filter processes with PID, CPU, and MB memory usage"
  set -l fmt '{printf "PID: %-7s | CPU: %5s%% | RSS: %7.2f MB | CMD: %s\n", $1, $2, $4/1024, $5}'
  set -l ps_command "ps -eo pid,pcpu,pmem,rss,args"

  if test -n "$argv[1]"
    set -l search_term "$argv[1]"
    set -l first_char (string sub -l 1 -- $search_term)
    set -l rest (string sub -s 2 -- $search_term)

    eval $ps_command | sort -k4 -rn | grep "[$first_char]$rest" | awk $fmt
  else
    eval $ps_command | sort -k4 -rn | awk "NR>1 $fmt"
  end
end
