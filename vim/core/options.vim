" Enable plugins based on filetype
filetype indent on
filetype plugin on

" Enable syntax highlighting
syntax enable

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Fold code to make it easier to read
set foldmethod=marker
set foldmarker={{{,}}}

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Autoread when file is changed from outside
set autoread

" Setting encoding and spellcheck language
set encoding=utf-8
set spelllang=en_us

" Better commandline completion
set wildmenu
set wildignore=*.o,*~,*.pyc,*.aux,*.bbl,*.blg,*.fdb_latexmk,*.fls,*.log,*.pdf,*.gz

" Show line and column number of cursor
set ruler

" Show the current line number while showing other line numbers relatively
set number
set relativenumber

" Show the statusline below -> Fix for lightline
set laststatus=2
set noshowmode

"Open new window splits logically
set splitbelow
set splitright

" Change directory to wherever the file is open
set autochdir

" Search settings
set nohlsearch
set incsearch

" Something something
set wrap
set linebreak

" Confirm if quitting without saving
set confirm

" Don't redraw when executing macros
set lazyredraw

" Show matching brackets and blink for two tenths of a second
set showmatch
set mat=2

" Set an undo file for persisting through reboots
try
    set undodir=~/.cache/vim/undo
    set undofile
catch
endtry

" Do not hide mouse when typing
set nomousehide

set updatetime=300
set hidden               " Hide buffers when they are abandoned
set cmdheight=2          " Setting command height 2 for more space
set shortmess+=c         " Messages should be short

" Keep same indent on next line, and indent after {
set autoindent
set smartindent

" Visual wrapped text preserves indent
set breakindent

" Use spaces instead of tabs
set expandtab

" Set shifts to 4 spaces
set shiftwidth=4
set tabstop=4

" Makes all tabs 'look' like 4 spaces, but why this+expandtab?
set softtabstop=4

