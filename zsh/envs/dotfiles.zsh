DOTFILES="$HOME/dotfiles"
XDG_CONFIG_HOME="$HOME/.config/"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
path+=('/home/cs/dotfiles/bin')
path+=('/home/cs/.local/bin')
path+=('/home/cs/.npm_packages/bin')
path+=('/home/cs/.emacs.d/bin')
path+=('/home/cs/.config/emacs/bin')
path+=('/home/cs/perl5/bin')
export PATH

export PERL5LIB='/home/cs/perl5/lib/perl5'
export HARNESS_OPTIONS=j$(grep -c ^processor /proc/cpuinfo):c

export tex_cruft='\.aux|\.bbl|\.out|\.blg|\.bcf|\.brf|\-blx\.bib|\.fdb_latexmk|\.fls|\.log|\.run\.xml|\.synctex\.gz'
