call PgSep_All('h')
setl autoindent
setl formatoptions=crql
setl nosmartindent
setl syntax=xml

    " Insert XML declaration.
nnoremap <buffer> ,,x i<?xml version="1.0" encoding="iso-8859-1"?><CR>
    " Comment out a line.
nnoremap <buffer> ,,oi ^hi<!--<ESC>A --><ESC>j
    " Uncomment a line.
nnoremap <buffer> ,,oo ^5x$xxxxj
    " Transform an element to a closing one.
nnoremap <buffer> ,,/ 0iX<ESC>f<a/<ESC>0xf/f dt>

