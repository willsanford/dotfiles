set number
set relativenumber

call plug#begin()
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'patstockwell/vim-monokai-tasty'
 Plug 'rust-lang/rust.vim'
call plug#end()
let g:rustfmt_autosave = 1
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')


nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
