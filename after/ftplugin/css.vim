" Maintainer:       Nikolai Weibull <now@bitwi.se>
" Latest Revision:  2007-05-08

let b:undo_ftplugin = "setl com< cms< inc< fo< ofu<"

setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
setlocal formatoptions-=t formatoptions+=croql
setlocal omnifunc=csscomplete#CompleteCSS

let &l:include = '^\s*@import\s\+\%(url(\)\='
call PgSep_All('c')
setl autoindent
setl nosmartindent
setl syntax=css
setl iskeyword+=-

