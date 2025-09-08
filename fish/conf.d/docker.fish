function docker-ip --description "Get IP address of a Docker container"
    set -l ip (docker inspect $argv[1] --format '{{.NetworkSettings.IPAddress}}')
    echo "IP address for $argv[1]: $ip"
end

function docker-cleanup --description "Remove all stopped containers and dangling images"
    set -l stopped_containers (docker ps -a -q -f "status=exited" -f "status=created")
    if test (count $stopped_containers) -gt 0
        docker rm $stopped_containers
    end

    set -l dangling_images (docker images -f "dangling=true" -q)
    if test (count $dangling_images) -gt 0
        docker rmi $dangling_images
    end
end

if test -d "$HOME/.docker/bin"
    fish_add_path "$HOME/.docker/bin"
end

if test -f ~/.orbstack/shell/init2.fish
    source ~/.orbstack/shell/init2.fish
end

abbr -a dcl 'docker-cleanup'
abbr -a dim 'docker images -a'
abbr -a dip 'docker-ip'
abbr -a dps 'docker ps -a'
