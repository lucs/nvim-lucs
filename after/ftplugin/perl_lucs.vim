call PgSep_All('b')
setl autoindent
setl cinkeys=0{,0},!^F,o,O,e
setl cinoptions=t0,+4,(0,)60,u0,*100
setl cinwords=if,else,while,do,for,elsif,sub
setl comments=n:#
setl formatoptions=crql
setl nocindent
setl nosmartindent
setl isfname-=:
if (! exists('g:perl_sw'))
  setl tabstop=4 softtabstop=4 shiftwidth=4
else
  exec 'setl tabstop=' . g:perl_sw
  exec 'setl shiftwidth=' . g:perl_sw
  exec 'setl softtabstop=' . g:perl_sw
endif

