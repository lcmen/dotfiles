# Go
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GOMODCACHE "$XDG_CACHE_HOME/go/mod"
fish_add_path "$XDG_DATA_HOME/go/bin"
