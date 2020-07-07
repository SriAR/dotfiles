mcd () {
    if [ ! -d $1 ]; then
        echo "Creating directory $1"
        mkdir -p -- "$1"
    fi
    cd -P -- "$1"
}
