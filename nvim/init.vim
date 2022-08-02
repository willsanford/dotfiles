set number relativenumber
set hidden
set mouse=a
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
call plug#begin('~/.config/nvim/plugged')

" Styling
" Plug 'morhetz/gruvbox'
Plug 'zacanger/angr.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
Plug 'itchyny/lightline.vim'

" Fuzzy Finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" hot key support
Plug 'liuchengxu/vim-which-key'

" Linting
Plug 'dense-analysis/ale'

" Animate Colors
Plug 'chrisbra/Colorizer'

call plug#end()

" Fuzzy finding
let g:rooter_patterns = ['.git', 'Makefile', 'build']
let g:fzf_layout = { 'down': '40%' }

" Styling
colorscheme angr

" Linting
let g:ale_linters = {
      \   'python': ['flake8'],
      \   'cpp': ['cc']
      \}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['yapf'],
\}

let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 0
let g:ale_lint_on_enter = 0

" Which key mappings
set timeoutlen=500
map <Space> <Leader>
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
" Leader Key Mappings

let g:which_key_map = {}


" Fix the file with Ale
map <leader>f :ALEFix<CR>

" Move buffers with arrow keys
map <leader><Right> :bn<CR>
map <leader><Left> :bp<CR>

" Close buffer with q
map <leader>q :bd<CR>

" Open FZF with double space
map <leader><Space> :FZF<CR>

" Save File with w
map <leader>w :w<CR>

" Save and quit with x
nnoremap <silent><leader>x :x<CR>
let g:which_key_map.x = ["x", 'save and close']

" COC jump to definitions and references
map <leader>d :<Plug>(coc-definition)
map <leader>r :<Plug>(coc-references)
" Force quit with !
map <leader>! :q!<CR>
