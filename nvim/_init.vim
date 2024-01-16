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
set rtp^="/home/wsanf/.opam/default/share/ocp-indent/vim"
let mapleader = " "

call plug#begin()
 Plug 'craftzdog/solarized-osaka.nvim'
 Plug 'nvim-lua/plenary.nvim'
 Plug 'github/copilot.vim'
 Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
 Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
 Plug 'morhetz/gruvbox'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'rust-lang/rust.vim'
 Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
 Plug 'lervag/vimtex'
 Plug 'neovim/nvim-lspconfig'
 Plug 'simrat39/rust-tools.nvim'
 Plug 'hrsh7th/nvim-cmp'
 Plug 'hrsh7th/cmp-nvim-lsp'
 Plug 'onsails/lspkind-nvim'
call plug#end()
let g:rustfmt_autosave = 1
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

set noshowmode

lua << EOF
require'lspconfig'.clangd.setup{}
require'lspconfig'.rust_analyzer.setup{}
require('rust.lua')
EOF

set termguicolors

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" set the darkest cappuccin colorscheme
colorscheme solarized-osaka 
