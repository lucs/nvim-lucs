call PgSep_All('b')
let b:did_indent = 1
setl autoindent
setl cinkeys=0{,0},!^F,o,O,e
setl cinoptions=t0,+4,(0,)60,u0,*100
setl cinwords=if,else,while,do,for,elsif,sub
setl comments=n:#
setl formatoptions=crql
setl nocindent
setl nosmartindent
"setl indentkeys-=0#
setl isfname-=:
setl tabstop=4 softtabstop=4 shiftwidth=2

    " Added for acutags. ☰2025-01-24.Fri
setl isk+=´

