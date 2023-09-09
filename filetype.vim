" Detect miscellaneous file types.

au! BufNewFile,BufRead *..zshrc setf zsh
au! BufNewFile,BufRead *.xres setf xres
au! BufNewFile,BufRead *.pmrc setf procmail
au! BufNewFile,BufRead *.sgl setf sgl
au! BufNewFile,BufRead .llog setf lucslog
au! BufNewFile,BufRead dist.ini setf distini
au! BufNewFile,BufRead *.ad setf asciidoc
au! BufNewFile,BufRead *.i setf invoc
au! BufNewFile,BufRead *.vroomx setf vroomx
au! BufNewFile,BufRead *.conf setf conf
au! BufNewFile,BufRead *.tsv setf tsv
au! BufNewFile,BufRead *.cln setf cln
au! BufNewFile,BufRead *.scen setf scen
au! BufNewFile,BufRead *.ly setf lilypond
au! BufNewFile,BufRead *.sco,*.orc,*.csd setf csound
au! BufNewFile,BufRead *.txh setf txh
au! BufNewFile,BufRead *.pod setf pod
au! BufNewFile,BufRead *.vpl,*.cons setf perl
au! BufNewFile,BufRead,BufWritePost *.memo,*.txt,*.poy setf text
au! BufNewFile,BufRead *.tt2,*.tt set filetype=tt2
au! BufNewFile,BufRead /home/lucs/.mutt/aliases setf mailaliases
au! BufWritePost * if &filetype == 'text' | exec 'filetype detect' | endif
au! BufEnter * if &filetype == "" | setlocal ft=text | endif

