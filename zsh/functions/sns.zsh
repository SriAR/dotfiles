sns () {
    sudo netctl stop-all &&
    sudo netctl start "$1"
}
