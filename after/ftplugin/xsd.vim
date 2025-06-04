call PgSep_All('h')
setl autoindent
setl formatoptions=crql
setl nosmartindent
setl showmatch
setl syntax=xml

  " Complete the abbreviation with ^-].
abbr <buffer> x xsd: 

" --------------------------------------------------------------------
" Delete current line if it is blank and not the last line of the file.
func! Dblk()
 " echo "<" . getline(".") . ">"
  if ( getline(".") =~ "^\\s*$" && line(".") != line("$"))
    normal! dd
  endif 
endfunc

" --------------------------------------------------------------------
  " Insert a schema declaration, with an XML declaration
noremap <buffer> ,,x i<?xml version="1.0" encoding="iso-8859-1"?><CR>
    \<xsd:schema<CR>  xmlns:xsd="http://www.w3.org/2001/XMLSchema"<CR>
    \<esc>0xxo</xsd:schema><CR><esc>kko<esc>

" --------------------------------------------------------------------
noremap <buffer> ,,gc :call Dblk()<cr>ko
    \<tab><xsd:group ref=""/><esc>0f"a

noremap <buffer> ,,go :call Dblk()<cr>ko
    \<tab><xsd:group name=""><ENTER></xsd:group><ESC>ko
    \<space><space><esc>k0f"a

" --------------------------------------------------------------------
noremap <buffer> ,,ec :call Dblk()<cr>ko<tab>
    \<xsd:element name="" type=""/><ESC>0f"a

noremap <buffer> ,,eo :call Dblk()<cr>ko<tab>
    \<xsd:element name=""><ENTER></xsd:element><ESC>
    \ko<space><space><esc>k0f"a

noremap <buffer> ,,s :call Dblk()<cr>ko<tab><xsd:sequence>
    \<ENTER></xsd:sequence><ESC>ko<space><space><esc>

  " Transform an element to a closing one.
nnoremap <buffer> ,,/ 0iX<ESC>f<a/<ESC>0xf/f dt>

  " Comment out a line.
nnoremap <buffer> ,,oi ^hi<!--<ESC>A --><ESC>j

  " Uncomment a line.
nnoremap <buffer> ,,oo ^5x$xxxxj

nnoremap <buffer> ,,c i<xsd:choose><ENTER><TAB>
    \<xsd:when test=""><ENTER></xsd:when><ENTER>
    \</xsd:choose><ESC><CTRL-D><ESC>

nnoremap <buffer> ,,m i<xsd:message><ENTER></xsd:message><ESC>^

nnoremap <buffer> ,,w i<xsd:with-param name="" select=""/><ESC>4F"a

