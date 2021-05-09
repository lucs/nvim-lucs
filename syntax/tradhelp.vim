syntax region remText matchgroup=foo concealends start=/↑/ end=/↓/
highlight remText ctermfg=darkred guifg=darkred
syntax region addText matchgroup=foo concealends start=/→/ end=/←/
highlight addText ctermfg=darkgreen guifg=darkgreen
highlight foo ctermfg=black guifg=black
setl conceallevel=3
setl concealcursor=nv

