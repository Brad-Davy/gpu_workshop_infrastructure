" ========== BASIC SETTINGS ==========
set nocompatible              " Use Vim improvements over Vi
set number                    " Show line numbers
set tabstop=4                 " Number of spaces for a <Tab>
set shiftwidth=4              " Spaces for autoindent
set expandtab                 " Convert tabs to spaces
set autoindent                " Auto-indent new lines
set smartindent               " Smarter auto-indent
set wrap                      " Wrap long lines
set cursorline
syntax on                     " Enable syntax highlighting
filetype plugin indent on     " Enable filetype detection and indentation

" ========== PYTHON-SPECIFIC ==========
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType python setlocal tabstop=4 textwidth=79
autocmd FileType python setlocal autoindent smartindent

" ========== PLUGINS ==========
" Install vim-plug if not already installed:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" Python syntax and indent
Plug 'vim-python/python-syntax'
Plug 'dense-analysis/ale'             " Asynchronous linting engine
Plug 'psf/black', { 'do': ':BlackUpgrade' }  " Code formatting

call plug#end()

" ========== ALE SETTINGS ==========
let g:ale_linters = {
\   'python': ['flake8', 'mypy', 'pylint'],
\}
let g:ale_fixers = {
\   'python': ['black'],
\}
let g:ale_fix_on_save = 1

" ========== KEY MAPPINGS ==========
nmap <F8> :w<CR>:!python3 %<CR>    " Run current file with Python3
colorscheme desert
call plug#begin('~/.vim/plugged')

" Add the theme plugin
Plug 'morhetz/gruvbox'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'

call plug#end()

" Set the colorscheme
syntax on
set background=dark"
:set number
