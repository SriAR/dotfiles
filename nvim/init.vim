set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

lua << EOF
require('nvim-treesitter.configs').setup {
    ensure_installed = { "haskell", "cpp", "c", "javascript", "markdown" },
    highlight = { -- Be sure to enable highlights if you haven't!
        enable = true,
    }
}
EOF
