wiki () {
    pandoc -f latex -t mediawiki "$1" | xclip -selection clipboard
}
