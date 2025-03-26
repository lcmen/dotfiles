function fish_prompt
  # Save the status from the last command
  set -l last_status $status

  # Just show the current directory
  set_color blue
  echo -n (prompt_pwd)
  set_color normal

  # Add a space and prompt symbol
  echo -n ' > '
end
