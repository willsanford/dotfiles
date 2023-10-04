" Automatically download vim plug if not there
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"
" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

set number
set relativenumber
set clipboard=unnamed
set mouse=a

filetype plugin indent on
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

call plug#begin()
 Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
 Plug 'morhetz/gruvbox'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'rust-lang/rust.vim'
 Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
 Plug 'lervag/vimtex'
call plug#end()
let g:rustfmt_autosave = 1
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

set noshowmode

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> qf <Plug>(coc-fix-current)
set termguicolors

" Latex stuff


" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","
