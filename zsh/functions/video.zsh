video() {
    case "$1" in
        record )
            record "$2";;
        smaller )
            smaller "$2";;
        upload )
            upload "$2";;
        all )
            record "$2" && smaller "$2" && upload "$2";;
    esac
}

record() {
    ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :0.0 -c:v libx264rgb -crf 0 -preset ultrafast "$1".mkv
}

smaller() {
    ffmpeg -i "$1".mkv -c:v libx264rgb -crf 0 -preset veryslow "${1}smaller.mkv"
}

upload() {
    ffmpeg -i "${1}smaller.mkv" -preset slow -codec:a libfdk_aac -b:a 128k -codec:v libx264 -pix_fmt yuv420p -b:v 4500k -minrate 4500k -maxrate 9000k -bufsize 9000k -vf scale=-1:1080 "$1".mp4
}
