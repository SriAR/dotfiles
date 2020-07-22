gmail() {
    git add --all && git commit --all --message "$(echo "$@")" && git push
}
