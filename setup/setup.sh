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
        echo "Symlinking $2 to $1"
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
                        ["dunst/dunstrc"]=".config/dunst/dunstrc"
                        ["zsh/zshrc"]=".zshrc"
                        ["picom/picom.conf"]=".config/picom/picom.conf"
                        ["i3/config"]=".config/i3/config"
                        ["rofi/config.rasi"]=".config/rofi/config.rasi"
                    )

for file in "${!mappings[@]}"; do
    newfile=${mappings[$file]}
    infile=$DOTFILES/$file
    outfile=$HOME/$newfile
    echo -e "------------\e[38;5;47m${file}\e[0m------------"
    dotinstall $infile $outfile
done

# vim:foldmethod=marker
