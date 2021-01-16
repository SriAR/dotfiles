pdfkeep () {
    gs -sPageList=$2 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dSAFER  -sOutputFile=tmppdfkeep.pdf "$1"
    [ "$?" != "0" ] && echo "THERE WAS AN ERROR" && rm tmppdfkeep.pdf && return 1
    mv tmppdfkeep.pdf "$1"
}
