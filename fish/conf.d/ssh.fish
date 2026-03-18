# Start SSH agent in WSL
if set -q WSL_DISTRO_NAME
  if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) > /dev/null

    if not ssh-add -l > /dev/null 2>&1
      ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1
    end
  end
end
