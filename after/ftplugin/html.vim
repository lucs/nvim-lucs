call PgSep_All('h')
setl autoindent
setl formatoptions=crql
setl nosmartindent
setl syntax=html
setl ts=4 sts=4 sw=4

if &ft == "php"
    call PgSep_All('j', 'h')
    setl ts=4 sts=4 sw=4
   " setl comments=n://
endif
