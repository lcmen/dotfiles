function z --wraps zed --description "Open Zed in a new workspace window"
  if test (count $argv) -eq 0
    zed -n .
  else
    zed -n $argv
  end
end
