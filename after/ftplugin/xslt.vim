call PgSep_All('h')
setl autoindent
setl formatoptions=crql
setl nosmartindent
setl syntax=xml

    " Insert XML header and stylesheet declaration.
nnoremap <buffer> ,,x i<?xml version="1.0" encoding="iso-8859-1"??><CR>
    \<xsl:stylesheet<CR>  version="1.0"<CR>
    \xmlns:xsl="http://www.w3.org/1999/XSL/Transform"<CR>>
    \<ESC>0xxo</xsl:stylesheet><CR><ESC>kko<ESC>

nnoremap <buffer> ,,a i<xsl:apply-templates/><ESC>
nnoremap <buffer> ,,f i<xsl:for-each select=""><ESC>2F"a
nnoremap <buffer> ,,c i<xsl:choose><ENTER>
    \<TAB><xsl:when test=""><ENTER></xsl:when>
    \<ENTER></xsl:choose><ESC><CTRL-D><ESC>
nnoremap <buffer> ,,e i<xsl:element name=""><ESC>2F"a
nnoremap <buffer> ,,m i<xsl:message><ENTER></xsl:message><ESC>^
nnoremap <buffer> ,,i i<xsl:if test=""><ESC>2F"a
nnoremap <buffer> ,,p i<xsl:param select=""><ESC>2F"a
nnoremap <buffer> ,,tm i<xsl:template match=""><ESC>2F"a
nnoremap <buffer> ,,tn i<xsl:template name=""><ESC>2F"a
nnoremap <buffer> ,,tc i<xsl:call-template name=""><ESC>2F"a
nnoremap <buffer> ,,tt i<xsl:text/><ESC>
nnoremap <buffer> ,,vo i<xsl:value-of select=""/><ESC>2F"a
nnoremap <buffer> ,,vn i<xsl:variable name=""><ESC>2F"a
nnoremap <buffer> ,,w i<xsl:with-param name="" select=""/><ESC>4F"a
    " Transform an xsl element to a closing one.
nnoremap <buffer> ,,/ 0iX<ESC>f<a/<ESC>0xf/f dt>
    " Comment out a line.
nnoremap <buffer> ,,oi ^hi<!--<ESC>A --><ESC>j
    " Uncomment a line.
nnoremap <buffer> ,,oo ^5x$xxxxj

