
" Most of this config was grabbed from Seth House
" https://github.com/whiteinge/dotfiles/blob/master/.vimrc

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" vundle-ception
Plugin 'gmarik/Vundle.vim'

" Syntax highlighting etc
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'scrooloose/syntastic'
Plugin 'gmarik/vim-markdown'
Plugin 'stephpy/vim-yaml'
Plugin 'elzr/vim-json'
Plugin 'fatih/molokai'
Plugin 'fatih/vim-go'

" Management plugins
Plugin 'airblade/vim-gitgutter'
Plugin 'Raimondi/delimitMate'
Plugin 'ciaranm/detectindent'
Plugin 'yggdroot/indentLine'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'
Plugin 'rking/ag.vim'

" Git integration
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'

call vundle#end()

filetype plugin indent on

" General {{{
set nocp
set nobackup
set noswapfile
set backspace=indent,eol,start
set mouse=nv       " Make the mouse work in normal and visual mode
set linebreak      " wrap lines on 'word' boundaries
set shiftwidth=4   " number of spaces to use for autoindenting
set tabstop=4      " a tab is four spaces
set wildmenu       " visual autocomplete for command menu
set isk+=_,$,@,%,# " none of these should be word dividers, so make them not be"
nmap <silent> ,/ :nohlsearch<CR>

" force myself to learn vim "aarows"
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" pane resizing
map <silent> <A-h> <C-w><
map <silent> <A-j> <C-W>-
map <silent> <A-k> <C-W>+
map <silent> <A-l> <C-w>>

" Maps Alt-[s.v] to horizontal and vertical split respectively
map <silent> <A-s> :split<CR>
map <silent> <A-v> :vsplit<CR>

" misc maps
nmap , $p
noremap Y y$            " Y will yank to end of current line
inoremap <C-e> <C-o>$   " Ctrl-e will go to end of line in insert mode
" Jump to end of paste
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]
" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Leader shortcuts
let mapleader = "\<Space>"
nnoremap <Leader>w  :w<CR>
nnoremap <Leader>an :set nonumber! norelativenumber!<CR>  " toggle all numbers
nnoremap <Leader>n  :set nonumber!<CR>
nnoremap <Leader>rn :set norelativenumber!<CR>
nnoremap <Leader>c  :noh<CR>                              " clear highlighting
nnoremap <Leader>l :IndentLinesToggle<CR> :set nonumber! norelativenumber<CR>
nnoremap <Leader>p  :set paste!<CR>                       " toggle paste
" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" Make these commonly mistyped commands still work
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q
map q: :q

" This enables us to undo files even if you exit Vim.
if has('persistent_undo')
  set undofile
  set undodir=~/.config/vim/tmp/undo//
endif

" Custom commands
command Write call WriteMode()


" }}}

" Search {{{

set incsearch                   "is:    automatically begins searching as you type
set ignorecase                  "ic:    ignores case when pattern matching
set smartcase                   "scs:   ignores ignorecase when pattern contains uppercase characters
set hlsearch                    "hls:   highlights search results
set expandtab
set smarttab
set autoindent

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" }}}

" Window Layout {{{

set encoding=utf-8
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

" Ag options
let g:ag_working_path_mode="r"  " Always search from project root

" NERDtree options
" auto open if no file sent as arg
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Toggle NERDtree with C-n
map <C-n> :NERDTreeToggle<CR>
" Autoclose if only NERDtree is left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" CtrlP options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" search directory
" r=closest .git, .hg folder
" a=only look in direct ancestors
let g:ctrlp_working_path_mode = 'ra'
" ignore files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

let g:ctrlp_use_caching = 0
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor

    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
endif

" }}}

" Multi-buffer/window/tab editing {{{
set splitright                  "spr:   puts new vsplit windows to the right of the current
set splitbelow                  "sb:    puts new split windows to the bottom of the current

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
" }}}

syntax enable

augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal tabstop=4
    autocmd FileType python setlocal shiftwidth=4
    autocmd FileType python setlocal softtabstop=4
    autocmd BufEnter python setlocal expandtab
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.pp setlocal tabstop=4
    autocmd FileType *.pp setlocal shiftwidth=4
    autocmd FileType *.pp setlocal softtabstop=4
    autocmd FileType *.pp setlocal commentstring=#\ %s
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd FileType asciidoc      call WriteMode()
augroup END

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w! w !sudo tee > /dev/null %

" fix dark blue color
"hi comment ctermfg=blue
set background=dark

" vim-go settings
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" Colorscheme
syntax enable
set t_Co=256
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

" Make a simple "search" text object.
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap h :normal vs<CR>

let delimitMate_expand_cr = 1     " Enable expansions for delimitMate
set virtualedit=onemore " Allow the cursor to move just past the end of the line
set gdefault " The substitute flag g is on
" let &showbreak="\u21aa " " Show a left arrow when wrapping text

""" Prevent lag when hitting escape
set ttimeoutlen=0
set timeoutlen=1000 
au InsertEnter * set timeout
au InsertLeave * set notimeout

function! WriteMode()
    set nonumber
    set nocursorline
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
    GitGutterDisable
    IndentLinesDisable
endfunction
