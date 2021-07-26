alias sniptex="vim ~/.vim/UltiSnips/tex.snippets"
alias alias_add="cd /home/cs/dotfiles/zsh/"
alias tex_clean='find . -type f -regextype egrep -regex "(.*)(\.aux|\.bbl|\.out|\.blg|\.bcf|\.brf|\-blx\.bib|\.fdb_latexmk|\.fls|\.log|\.run\.xml|\.synctex\.gz)$" -delete'
alias camera="mpv --demuxer-lavf-format=video4linux2 --demuxer-lavf-o-set=input_format=mjpeg av://v4l2:/dev/video0"
alias airplay="systemctl start avahi-daemon && uxplay"
alias cheenta="xrandr --output HDMI-1 --right-of eDP-1 --auto && wacom-monitor && pkill picom"
