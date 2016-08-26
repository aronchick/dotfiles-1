
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
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'hashivim/vim-hashicorp-tools'
Plugin 'kchmck/vim-coffee-script'
Plugin 'scrooloose/syntastic'
Plugin 'jnwhiteh/vim-golang'
Plugin 'gmarik/vim-markdown'
Plugin 'saltstack/salt-vim'
Plugin 'stephpy/vim-yaml'
Plugin 'fatih/vim-go'

" Management plugins
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'airblade/vim-gitgutter'
Plugin 'Raimondi/delimitMate'
Plugin 'davidhalter/jedi-vim'
Plugin 'ciaranm/detectindent'
Plugin 'tomtom/tcomment_vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'yggdroot/indentLine'
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
set linebreak     " wrap lines on 'word' boundaries
set shiftwidth=2  " number of spaces to use for autoindenting
set tabstop=2     " a tab is four spaces
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

" Leader shortcuts
let mapleader = "\<Space>"
nnoremap <Leader>w  :w<CR>
nnoremap <Leader>an :set nonumber! norelativenumber!<CR>  " toggle all numbers
nnoremap <Leader>n  :set nonumber!<CR>
nnoremap <Leader>rn :set norelativenumber!<CR>
nnoremap <Leader>c  :noh<CR>                              " clear highlighting
nnoremap <Leader>l :IndentLinesToggle<CR> :set nonumber! norelativenumber!<CR>
nnoremap <Leader>p  :set paste!<CR>                       " toggle paste

" Make these commonly mistyped commands still work
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q
map q: :q

" press jj to escape insert mode  
imap jj <Esc>
set backspace=indent,eol,start

" Make the mouse work in normal and visual mode
set mouse=nv

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

" set .md as markdown without a plugin
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w! w !sudo tee > /dev/null %

" Highlight the 81st column on wide lines
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" fix dark blue color
"hi comment ctermfg=blue
set background=dark

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

function! ToggleColorColumn()
    if &colorcolumn != 0
        windo let &colorcolumn = 0
    else
        windo let &colorcolumn = 80
    endif
endfunction
