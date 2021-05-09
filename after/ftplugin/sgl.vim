" For my *.sgl files, custom "Smart Go Format".

call PgSep_All('b')
setl autoindent
setl comments=n:#
setl formatoptions=tcq
setl nosmartindent
setl nowrapscan
    " ´ ¨
setl isk+=180,168
setl tw=66
setl ts=2 sw=2 sts=2
inoremap <buffer> ,a ´
inoremap <buffer> ,s ¨

