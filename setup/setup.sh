#!/bin/bash
DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"
TMP="/tmp/olddotfiles"

# Helper functions to install dotfiles {{{
mcd() {
    if [ ! -d $1 ]; then
        echo "Creating directory $1"
        mkdir -p -- "$1"
    fi
    cd -P -- "$1"
}

dotbackup() {
    file=${1##*/}
    mcd $TMP
    if [ -e $TMP/$file ]; then
        echo "$file already exists at $TMP, moving it to $file.bak"
        mv $TMP/$file $TMP/$file.bak
    fi
    echo "Moving $1 to $TMP/$file"
    mv $1 $TMP/$file
}

dotlink() {
    if [ -L "$2" ] && [ "$(readlink $2)" = "$1" ]; then
            echo "$2 is already symlinked to $1"
    else
        if [ -e "$2" ]; then
            echo -e "$2 already exists, \e[38;5;1mremoving it\e[0m."
            dotbackup $2
        fi
        echo -e "\e[38;5;202mSymlinking\e[0m $2 to $1"
        ln -s $1 $2
    fi
}

dotinstall() {
    outdir=${2%/*}
    mcd $outdir
    dotlink $1 $2
}

# }}}

declare -A mappings=(   ["vim/vimrc"]=".vimrc"
                        ["zathura/zathurarc"]=".config/zathura/zathurarc"
                        ["dunst"]=".config/dunst"
                        ["zsh/zshrc"]=".zshrc"
                        ["picom"]=".config/picom"
                        ["mpd/mpd.conf"]=".config/mpd/mpd.conf"
                        ["i3"]=".config/i3"
                        ["rofi"]=".config/rofi"
                        ["nvim"]=".config/nvim"
                        ["alacritty"]=".config/alacritty"
                        ["polybar"]=".config/polybar"
                        ["doom"]=".config/doom"
                        ["pubs/pubsrc"]=".pubsrc"
                    )
                        # ["x11/Xinitrc"]=".xinitrc"
                        # ["x11/Xdefaults"]=".Xdefaults"
                        # ["x11/Xmodmap"]=".Xmodmap"

for file in "${!mappings[@]}"; do
    newfile=${mappings[$file]}
    infile=$DOTFILES/$file
    outfile=$HOME/$newfile
    echo -e "------------\e[38;5;47m${file}\e[0m------------"
    dotinstall $infile $outfile
done

# vim:foldmethod=marker
