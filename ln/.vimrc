" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" fix dark blue color
"hi comment ctermfg=blue
set background=dark
