pa() {
    doc="`find /tmp/ -maxdepth 1 -type f -iname '*.pdf'`"
    [ "$doc" = "" ] && exit
    bib="`find /tmp/ -maxdepth 1 -type f -iname '*.bib'`"
    [ ! -f "$bib" ] && exit
    pubs add -M -d "$doc" "$bib" -t "$@" >> /home/cs/pubs/pubs.list
    rm "$bib"
    # pubs list > /home/cs/pubs/pubs.list
}
