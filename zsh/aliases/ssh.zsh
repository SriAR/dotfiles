alias send="rsync --modify-window=1 --recursive --links --perms --times --partial --progress /home/cs/Study/ arsricharan@access2.cmi.ac.in:~/Study"
alias try="send --dry-run --itemize-changes --verbose"
alias receive="rsync --modify-window=1 --recursive --links --perms --times --partial --progress arsricharan@access2.cmi.ac.in:~/Study/ /home/cs/Study"
alias rtry="receive --dry-run --itemize-changes --verbose"

