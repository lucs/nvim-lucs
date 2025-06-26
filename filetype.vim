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
au! BufNewFile,BufRead *.memo,*.txt,*.poy setf memo
au! BufNewFile,BufRead *.tt2,*.tt set filetype=tt2
au! BufNewFile,BufRead /home/lucs/.mutt/aliases setf mailaliases

au! BufEnter * if &filetype == "" | setf memo | endif
au! BufWritePost * if getline(1) =~ '^- --------' | setf memo | else | filetype detect | endif

