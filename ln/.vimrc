
" Most of this config was grabbed from Seth House
" https://github.com/whiteinge/dotfiles/blob/master/.vimrc

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" vundle-ception
Plugin 'gmarik/Vundle.vim'

" Syntax highlighting etc
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'scrooloose/syntastic'
Plugin 'jnwhiteh/vim-golang'
Plugin 'chase/vim-ansible-yaml'
Plugin 'gmarik/vim-markdown'
Plugin 'saltstack/salt-vim'
Plugin 'scrooloose/nerdtree'

" Git integration
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on

" General {{{
set nobackup
set noswapfile
set shiftwidth=4  " number of spaces to use for autoindenting
set tabstop=4     " a tab is four spaces
nmap <silent> ,/ :nohlsearch<CR>

" force myself to learn vim "aarows"
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" }}}

" Search {{{

set incsearch                   "is:    automatically begins searching as you type
set ignorecase                  "ic:    ignores case when pattern matching
set smartcase                   "scs:   ignores ignorecase when pattern contains uppercase characters
set hlsearch                    "hls:   highlights search results
set expandtab
set smarttab
set autoindent

" }}}

" Window Layout {{{

set encoding=utf-8
if exists('+relativenumber')
    set relativenumber              "rnu:   show line numbers relative to the current line; <leader>u to toggle
endif
set number                      "nu:    show the actual line number for the current line in relativenumber
set showmode                    "smd:   shows current vi mode in lower left
set cursorline                  "cul:   highlights the current line
set showcmd                     "sc:    shows typed commands
set cmdheight=2                 "ch:    make a little more room for error messages
set sidescroll=2                "ss:    only scroll horizontally little by little
set scrolloff=1                 "so:    places a line between the current line and the screen edge
set sidescrolloff=2             "siso:  places a couple columns between the current column and the screen edge
set laststatus=2                "ls:    makes the status bar always visible
set ttyfast                     "tf:    improves redrawing for newer computers
set history=200                 "hi:    number of search patterns and ex commands to remember
                                "       (also used by viminfo below for /, :, and @ options)
set viminfo='200                "vi:    For a nice, huuuuuge viminfo file

" NERDtree options

" auto open if no file sent as arg
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Toggle NERDtree with C-n
map <C-n> :NERDTreeToggle<CR>
" Autoclose if only NERDtree is left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" }}}

" Multi-buffer/window/tab editing {{{
set splitright                  "spr:   puts new vsplit windows to the right of the current
set splitbelow                  "sb:    puts new split windows to the bottom of the current

" NERDTree options
" auto open NERDTree if vim run without args
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" close vim if only NERDTree pane is left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
" }}}

set mouse=                      "       Disable mouse control for console

syntax enable

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" fix dark blue color
"hi comment ctermfg=blue
set background=dark
