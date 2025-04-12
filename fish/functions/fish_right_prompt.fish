function fish_right_prompt
  # Check if we're in a git repository
  if git rev-parse --is-inside-work-tree &>/dev/null
    set -l branch (git branch --show-current)
    set -l git_status (git status --porcelain)
    set -l git_ahead (git rev-list --count HEAD@{upstream}..HEAD 2>/dev/null)
    set -l git_behind (git rev-list --count HEAD..HEAD@{upstream} 2>/dev/null)

    # Show ahead/behind status
    if test -n "$git_ahead" && test "$git_ahead" -gt 0
      set_color green
      echo -n "↑ "
    end
    if test -n "$git_behind" && test "$git_behind" -gt 0
      set_color red
      echo -n "↓ "
    end

    # Show dirty status
    if test -n "$git_status"
      set_color yellow
      echo -n "✘ "
    end

    # Set color based on git status
    if test -n "$git_status"
      set_color red
    else
      set_color green
    end

    echo -n "[$branch] "

    # Reset color
    set_color normal
  end
end
