#Clone the clipboard url into mentioned directory
clone() {
    url=`xclip -selection c -o`

    usage="Usage: clone <dir>"
    message="This tool clones the current url in clipboard to <dir>"

    [ $# -eq 0 ] && printf '%s\n' \
    "No directory given. Exiting" \
    $usage \
    $message && return

    check=`echo $url | grep git`
    [ ! $? -eq 0 ] && printf '%s\n' \
    "The url does not seem to be a git link. Exiting" \
    $usage \
    $message && return

    dir=$1
    if [ -e $dir ]; then
        echo "Directory $dir already exists."
    else
        echo "Cloning $url into $dir"
        git clone $url $dir
    fi
}
