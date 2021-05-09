" "Smart Go Lucs" format

synt match  Node '´\w*'
synt match  Attr '¨\w*'
synt match  Obrk '´('
synt match  Cbrk '¨)'
high Node   ctermfg=Red
high Attr   ctermfg=LightRed
high Obrk   ctermfg=Cyan
high Cbrk   ctermfg=LightCyan

