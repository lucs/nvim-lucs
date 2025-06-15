" --------------------------------------------------------------------
" Globals
"
"       ⦃/home/lucs⦄, ⦃/root⦄, usually set in …<.init.⟨user⟩.vim>.
"   g:user_home_dir
"
"       ⦃lucs⦄, ⦃c_suz_vch⦄, usually set in …<.init.vim>.
"   g:prj_nick

" --------------------------------------------------------------------
func! _PasteOptVal (opt)
    let l:savedB = @b
    redir @b
    exec 'echon &' . a:opt
    redir end
    normal "bP
    let @b = l:savedB
endfunc
command! -nargs=1 PasteOptVal :call _PasteOptVal("<args>")

" --------------------------------------------------------------------
" Use "very magic" regexes (☰2025-05-03.Sat) and keep allowing
" toggling search highlight, but turn it back on when a search is
" done.

nnoremap <silent> <c-n> :set hls!<cr>
nnoremap <silent> n     :set hls<cr>n
nnoremap <silent> N     :set hls<cr>N
nnoremap <silent> /     :set hls<cr>/\v
nnoremap <silent> ?     :set hls<cr>?\v
cnoremap <silent> %s/   %s/\v
cnoremap <silent> .,$s/ .,$%s/\v
nnoremap <silent> *     :set hls<cr>*
nnoremap <silent> g*     :set hls<cr>g*

" There appears to be no way to concoct a mapping to generalize
" ‹:⟨range⟩s/⋯› to use "very magic", so will just have to be careful
" to add the ‹\v› manually to such invocations, or to use the regular
" "magic" notation or such.

" --------------------------------------------------------------------
" ʈ open frequent

" ‹K⋯h›: $HOME dir
" ‹K⋯s›: Subproject dir
" ‹K⋯u›: Logged-in-user dir

    " ‹Kf⋯›: ‹.freq⋯›
    " List of frequently used files or URLs for project.
    " opening with ‹gf› (built-in) or ‹,gm› (defined here elsewhere).
nnoremap Kfh :e $HOME/.freq<cr>
nnoremap Kfs :e $dSP/.freq<cr>
nnoremap Kfu :exec ':e ' . g:user_home_dir . '/.frequ'<cr>

    " ‹Kj⋯›: ‹...›
    " Junk text for project, but kept around anyway.
nnoremap Kjh :e $HOME/...<cr>
nnoremap Kjs :e $dSP/...<cr>
nnoremap Kju :exec ':e ' . g:user_home_dir . '/...u'<cr>

    " ‹Kh⋯›: ‹...›
    " Project memo file.
nnoremap Khh :e $HOME/_
nnoremap Khs :e $dSP/_
nnoremap Khu :e <c-r>=g:user_home_dir<cr>/_

    " ‹Kk⋯›: Misc.
nnoremap Kkk :exec ':e ' . g:nvim_lucs_pack . '/after/plugin/lucs.vim'<cr>
nnoremap Kkd :e /shome/lucs/gdoc<cr>
nnoremap Kkl :exec ':e ' . g:user_home_dir . '/.llog'<cr>
nnoremap Kkm :e /mnt/hKpop/opt/prj<cr>
nnoremap Kkp :exec ':e ' . g:user_home_dir . '/prj/'<cr>

" --------------------------------------------------------------------
" ʈ Other ‹K› mappings

nnoremap Kb :call InsertBillingElem()<cr>

    " Change to "- -⋯" my old style "# -⋯" text separator lines.
nnoremap Kc :%s/^\(\s*\)\# -/\1- -/gc<cr>

nnoremap Km :call FormatManPage()<cr>

    " Replace keyed surrounders by more recent mechanism
    " ☰2024-11-23.Sat.
"nnoremap Kr :%s/\([◆…∿ū]\)<\(.\{-}\)>/\1❬\2❭/gc<cr>

    " Replace old by new timestamp indicator.
    " ⌚1 U+231a
    " ⌘21 U+2318
nnoremap Kt :%s,[\u231a\u2318],☰,gc<cr>

" --------------------------------------------------------------------
" ☰2024-12-27.Fri
" Restore these ❬⋯❭ to <⋯>

nnoremap ,r :%s/❬/</gc<cr>
nnoremap ,R :%s/❭/>/gc<cr>

    " Make it easier to leave terminal mode.
    " (Enter with ⦃:vsplit term://zsh⦄, then ‹i›.)
:tnoremap <c-g><c-g> <c-\><c-n>

" --------------------------------------------------------------------
" ☰2024-12-11.Wed
"
func! s:MidWindow ()
    :vnew
    :vnew
    :vert res 46
    exec "normal! 2\<c-w>l"
    :vert res 78
    exec "normal! \<c-w>x\<c-w>h"
endfunc
nnoremap ,<f2> :call <SID>MidWindow()<cr>

" --------------------------------------------------------------------
" These allow saving the current visual selection and resetting it to
" what it then was later.

func! GetVisual ()
    return [visualmode(), getpos("'<"), getpos("'>")]
endfunc

func! SetVisual (want_visual)
    let l:mode    = a:want_visual[0]
    let l:beg_lyn = a:want_visual[1][1]
    let l:beg_col = a:want_visual[1][2]
    let l:end_lyn = a:want_visual[2][1]
    let l:end_col = a:want_visual[2][2]
    let l:cmd = ''
    if l:mode == 'V'
        let l:cmd = l:beg_lyn . 'GV' . l:end_lyn . 'G'
    elseif l:mode =~ "[v\<c-v>]"
        let l:cmd =
          \  l:beg_lyn . 'G0' .
          \ (l:beg_col - 1) . 'l' . l:mode .
          \  l:end_lyn . 'G0' .
          \ (l:end_col - 1) . 'l'
    else
        return
    endif
    let l:winview = winsaveview()
    exec "normal! " . l:cmd . "\<esc>"
    call winrestview(l:winview)
endfunc

" --------------------------------------------------------------------
" ʈ open evince
" ☰2025-01-18.Sat

nnoremap gbv :call GetOpenInEvince()<cr>

" For example, place cursor within this string and press ‹gbv›:
" …</home/lucs/prj/t/raku/vol/Parsing-Moritz/Parsing-Moritz.pdf>

func! GetOpenInEvince ()
    let l:winview = winsaveview()
    let l:saved_visual = GetVisual()
    let l:saved_0 = getreg("0")
    let l:curr_line = getpos(".")[1]
    let l:quit_msg = ''
    try
        normal! vi<y
            " Make sure selection is on the current line.
        if getpos("'<")[1] != l:curr_line
            exec "normal! \<esc>"
            let l:quit_msg = "Bad selection."
            throw "moo"
        endif
        normal! y
        let l:want = getreg("0")
        if match(l:want, '^\s*$') == 0
            let l:quit_msg = "Nothing to open"
            throw "mee"
        endif
        let l:quit_msg = OpenInEvince(l:want)
    catch
    finally
        call setreg('0', l:saved_0)
        call SetVisual(l:saved_visual)
        call winrestview(l:winview)
    endtry
    redraw | echo substitute(l:quit_msg, '\n\+$', '', '')
endfunc

func! OpenInEvince (wut)
    return system(printf("evince '%s'", a:wut))
endfunc

" --------------------------------------------------------------------
" ʈ open browser
" ☰2024-09-23.Mon

    " ⦃:call EchoSleep(3, "baz")⦄
func! EchoSleep (dura, msg)
    redraw
    echo a:msg
    exec "sleep " . a:dura
    exec "normal! \<esc>"
endfunc

nnoremap gbut :call GetOpenInBrowser('u', 't')<cr>
nnoremap gbuw :call GetOpenInBrowser('u', 'w')<cr>
nnoremap gbft :call GetOpenInBrowser('f', 't')<cr>
nnoremap gbfw :call GetOpenInBrowser('f', 'w')<cr>

func! GetOpenInBrowser (url_or_file, tab_or_window)
    let l:winview = winsaveview()
    let l:saved_visual = GetVisual()
    let l:saved_0 = getreg("0")
    let l:curr_line = getpos(".")[1]
    let l:quit_msg = ''
    try
        normal! vi<y
            " Make sure selection is on the current line.
        if getpos("'<")[1] != l:curr_line
            exec "normal! \<esc>"
            let l:quit_msg = "Bad selection."
            throw "moo"
        endif
        normal! y
        let l:want = getreg("0")
        if match(l:want, '^\s*$') == 0
            let l:quit_msg = "Nothing to open"
            throw "mee"
        endif
        let l:quit_msg = OpenInBrowser(l:want, a:url_or_file, a:tab_or_window)
    catch
    finally
        call setreg('0', l:saved_0)
        call SetVisual(l:saved_visual)
        call winrestview(l:winview)
    endtry
    redraw | echo substitute(l:quit_msg, '\n\+$', '', '')
endfunc

" ū<ssd3go111ogle.com>
" <  >
" ū<google.com>

func! OpenInBrowser (wut, url_or_file, tab_or_window)
    let l:url_or_file = ''
    if a:url_or_file == 'f'
        let l:url_or_file = '-f'
    endif
    let l:tab_or_window = ''
    if a:tab_or_window == 'w'
        let l:tab_or_window = '-w'
    endif
    return system(
      \ printf("ffox %s %s '%s'",
      \     l:url_or_file,
      \     l:tab_or_window,
      \     a:wut
      \ )
    \)
endfunc

" --------------------------------------------------------------------
" ☰2024-06-18.Tue
" Line/line: line number
" Vcol/vCol: virtual column
" Ccol/cCol: byte column
" Bpos/bPos: buffer position: #{Line:⟨Line⟩, vCol:⟨Vcol⟩, cCol:⟨Ccol⟩}

func! GetCursorBpos ()
    return #{Line: line('.'), vCol: virtcol('.'), cCol: col('.')}
endfunc

func! GetCharAtBpos (bPos)
    return strcharpart(strpart(getline(a:bPos.Line), a:bPos.cCol - 1), 0, 1)
endfunc

func! GetCharAtCursor ()
    return GetCharAtBpos(GetCursorBpos())
endfunc

func! MoveCursorToBpos (bPos)
    call setcharpos('.', [0, a:bPos.Line, a:bPos.cCol, 0])
endfunc

" --------------------------------------------------------------------
" ʈ Debugging::Tool
" ☰2024-08-06.Tue

    " For use with Debugging::Tool.
nnoremap ,dp /\$dt\.p/e<cr>

nnoremap ,ds /\$dt\.s/e<cr>
nnoremap ,dd /\$dt\.[ps]/e<cr>
nnoremap ,d. /\$dt\._/e<cr>
nnoremap ,da /\$dt\./e<cr>

" --------------------------------------------------------------------
" ☰2024-03-23.Sat
"
" When in a Makefile, the syntax setting has ‹:set noexpandtab›, which
" is usually what one wants. But in comments, I would like to
" be able to use tabs to indent text, but have spaces, not tabs, in
" the text. This macro somewhat helps.

imap <s-tab> <esc>:call TabAsSpaces()<cr>a

func! TabAsSpaces ()
    let l:saved_expandtab = &expandtab
    setl expandtab
    if getcharpos('.')[2] > 1
        exec "normal! a\<tab>"
    else
        exec "normal! i\<tab>"
    endif
    if l:saved_expandtab
        setl expandtab
    else
        setl noexpandtab
    endif
endfunc

" --------------------------------------------------------------------
" ʈ search slash
" ☰2024-03-04.Mon
" Search for pattern with slashes.
"
" Another way is to search backwards with ‹?› instead of ‹/›.

" Found at:
" https://vim.fandom.com/wiki/Searching_for_expressions_which_include_slashes

    " ⦃:Ss /baz/foo⦄ Escape slashes.
command! -nargs=1 Ss let @/ = escape(<q-args>, '/')|normal! /<C-R>/<CR>

    " ⦃:SS /baz*/foo⦄ Escape all special characters.
command! -nargs=1 SS let @/ = '\V'.escape(<q-args>, '/\')|normal! /<C-R>/<CR>

" --------------------------------------------------------------------

   " Identify the syntax highlighting group used at the cursor
   " ū<http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor>
:map <f10> :echo
    \     "hi<"    . synIDattr(synID(line("."), col("."), 1), "name")
    \ . '> trans<' . synIDattr(synID(line("."), col("."), 0), "name")
    \ . "> lo<"    . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
    \ . ">"<cr>

    " To help match code snippet id`s.
nnoremap gW /ID:<space>\.\?

" --------------------------------------------------------------------
" ʈ timestamps

    " Insert a timestamp with a format of 7, 8, 9, or 0 (cf.
    " _InsertTimestamp) and either at (i) the cursor position, or
    " after (o) it.
nnoremap <c-u>6i      :call _InsertTimestamp(6, "i")<cr>
inoremap <c-u>6i <esc>:call _InsertTimestamp(6, "i")<cr>a
nnoremap <c-u>6o      :call _InsertTimestamp(6, "o")<cr>
inoremap <c-u>6o <esc>:call _InsertTimestamp(6, "o")<cr>a

nnoremap <c-u>7i      :call _InsertTimestamp(7, "i")<cr>
inoremap <c-u>7i <esc>:call _InsertTimestamp(7, "i")<cr>a
nnoremap <c-u>7o      :call _InsertTimestamp(7, "o")<cr>
inoremap <c-u>7o <esc>:call _InsertTimestamp(7, "o")<cr>a

nnoremap <c-u>8i      :call _InsertTimestamp(8, "i")<cr>
inoremap <c-u>8i <esc>:call _InsertTimestamp(8, "i")<cr>a
nnoremap <c-u>8o      :call _InsertTimestamp(8, "o")<cr>
inoremap <c-u>8o <esc>:call _InsertTimestamp(8, "o")<cr>a

nnoremap <c-u>9i      :call _InsertTimestamp(9, "i")<cr>
inoremap <c-u>9i <esc>:call _InsertTimestamp(9, "i")<cr>a
nnoremap <c-u>9o      :call _InsertTimestamp(9, "o")<cr>
inoremap <c-u>9o <esc>:call _InsertTimestamp(9, "o")<cr>a

nnoremap <c-u>0i      :call _InsertTimestamp(0, "i")<cr>
inoremap <c-u>0i <esc>:call _InsertTimestamp(0, "i")<cr>a
nnoremap <c-u>0o      :call _InsertTimestamp(0, "o")<cr>
inoremap <c-u>0o <esc>:call _InsertTimestamp(0, "o")<cr>a

    " These have to "remap".
nmap <c-u><c-t>6      0itodo0<esc><c-u>6oa<space><esc>
nmap <c-u><c-t>7      0itodo0<esc><c-u>7oa<space><esc>
nmap <c-u><c-t>8      0itodo0<esc><c-u>8oa<space><esc>
nmap <c-u><c-t>9      0itodo0<esc><c-u>9oa<space><esc>
nmap <c-u><c-t>0      0itodo0<esc><c-u>0oa<space><esc>

imap <c-u><c-t>6 <esc>0itodo0<esc><c-u>6oa<space><esc>a
imap <c-u><c-t>7 <esc>0itodo0<esc><c-u>7oa<space><esc>a
imap <c-u><c-t>8 <esc>0itodo0<esc><c-u>8oa<space><esc>a
imap <c-u><c-t>9 <esc>0itodo0<esc><c-u>9oa<space><esc>a
imap <c-u><c-t>0 <esc>0itodo0<esc><c-u>0oa<space><esc>a

    " When placed on a 'todo' line, insert a ~done line preceding it.
    " For example, this:
    "
    "   todo0☰2023-04-15.Sat As heard on "Stuff You Should Know", see about
    "
    " becomes this:
    "
    "       ☰2023-05-07.Sun Fixed bla bla medeo inunt speciasum
    "       lorem ipsum.
    "   todo☰2023-04-15.Sat As heard on "Stuff You Should Know", see about
    "   Ferrante/Teicher piano duet.

    " These have to "remap".
nmap <c-u><c-d>7 0xRtodo<esc>O<c-u>7o<esc>I    <esc>A<space>
nmap <c-u><c-d>8 0xRtodo<esc>O<c-u>8o<esc>I    <esc>A<space>
nmap <c-u><c-d>9 0xRtodo<esc>O<c-u>9o<esc>I    <esc>A<space>
nmap <c-u><c-d>0 0xRtodo<esc>O<c-u>0o<esc>I    <esc>A<space>

" --------------------------------------------------------------------
" Insert a current moment timestamp.

func! CalcTimestamp (format)
   " let l:cmdb = 'echo $PATH >> /tmp/zvim'
   " :call system(l:cmdb)
   " let l:dapath = $PATH
   " call writefile([l:dapath], "/tmp/zvim")
    let l:cmd = 'raku ' . g:nvim_lucs_pack . '/plugin/tstamp.raku ' . a:format
    return system(
      \ (has('win16') || has('win32') || has('win64'))
      \     ? shellescape(l:cmd)
      \     : l:cmd
    \)
endfunc

    " a:format:
    "     7: ⦃☰2023-03-29T07:43:45-04:00⦄
    "     8: ⦃☰2023-03-29.Wed⦄
    "     9: ⦃☰2023-03-29.Wed.07-42-39⦄
    "     0: ⦃☰2023c.Mar29.Wed.07:43.03⦄
    " a:where:
    "     8: Insert bef cursor position
    "     9: Insert aft cursor position
func! _InsertTimestamp (format, where)
    let l:saved_b = getreg("b")
    let @b = '☰' . CalcTimestamp(a:format)
    if a:where == 'i'
        normal! "bP
    elseif a:where == 'o'
        normal! "bp
    endif
    call setreg('b', l:saved_b)
endfunc

" --------------------------------------------------------------------
" Fix a timestamp, adding the day of week. so that:
"   ☰2023-01-24 becomes ☰2023-01-24.Tue
" and:
"   ☰2023-01-24.20-45-15 becomes ☰2023-01-24.Tue.20-45-15
"
" This is not very smart. It will work correctly only only if the
" cursor is already placed on the '☰' character.

"func! AddDOW ()
"endfunc

" --------------------------------------------------------------------
" ʈ billing elem
" Given ⦃g:prj_nick = 'vch'⦄, look for lines that start like ⦃vchf…⦄
" (note the appended 'f') and insert a block before it, like
" ‹vchf!0'043- ☰2019l.Dec02.Mon.09:44.06›

func! InsertBillingElem ()
    if ! exists('g:prj_nick')
        echo "Set g:prj_nick to use InsertBillingElem()"
        return
    endif

   " set lazyredraw
    call SaveWinView()
    normal! gg
    let l:last_elem = search('^' . g:prj_nick . 'f')
    if l:last_elem != 0
            " Move to found matching line and copy it
        exec 'normal! ' . l:last_elem . 'G'
        let l:saved_x = getreg("x")
        normal! "xyy
        let l:saved_b = getreg("b")
        let l:num = matchstr(@x, '\d\d\+')
        let l:num += 1
        let @b = CalcTimestamp(0)
            " Fabricate the new line.
        let @b = printf("%sf-0'%03d- %s", g:prj_nick, l:num, @b)
       " echo @b
        let @x = '- ' . repeat('-', 68)
       " echo @x
        normal! kk
        put x
        put b
        call setreg('x', l:saved_x)
        call setreg('b', l:saved_b)
        normal! o
        normal! zzk2f-l
        startinsert
    else
        call RestoreWinView()
    endif
   " set nolazyredraw
endfunc

" --------------------------------------------------------------------
" Delete current paragraph and empty lines following it and move to
" next one.

func! DelPara ()
    let l:savedSearch = @/

    normal! {jV}/.kd
        " Restore saved search pattern.
    let @/ = l:savedSearch
endfunc

" --------------------------------------------------------------------
" Take a string like ‹foo=$bar/noy› and have it evaluate so that the
" Vim session recognizes $foo.
"
" Meh, complicated. Just copy the line and eval that
" ⦃
"   foo=bar
"   " $foo = 'bar'
" ⦄

" --------------------------------------------------------------------
func! FixPerl6PodAnsi ()
    :%s/\[4m/[33;4m/g
    :%s/\[1m/[33;1m/g
    :AnsiEsc
endfunc

" --------------------------------------------------------------------

    " Especially don't want ‹q› to quit Vim when I'm reading a file
    " that has ‹set ft=man›. See
    " ‥<vim.app/share/vim/vim80/ftplugin/man.vim>.
let no_man_maps = 1

nnoremap __ :e ~/⋯*<cr>
nnoremap _. :e ./⋯*<cr>
nnoremap _t :e ./…*<cr>
nnoremap _l :e ./⋯*<cr>

" --------------------------------------------------------------------
" If ‹:set textwidth› is not equal to 70, set it to 70, else set it to
" 70 (minus 4) plus however far is the first character on the line
" where the cursor is.

nnoremap gp :call _ReTextWidth()<cr>
func! _ReTextWidth ()
    let l:curr_wid = &textwidth
    if l:curr_wid != 70
        set tw=70
    else
       " let l:curr_cursor = getcurpos()
        let l:cursor_col = getcurpos()[4]
       " echo l:curr_cursor[4]
        echo l:cursor_col
        exec "setl tw=" . (l:cursor_col + 66)
    endif
endfunc

" --------------------------------------------------------------------
" ʈ
" I use lines that look like ‹ʈ ⟨subject⟩› in pretty much all my
" documentation files, to identify sections. For example:
" 
"     - --------------------------------------------------------------------
"     ʈ parse binary
" 
"     https://dev.to/uzluisf/dbase-parsing-a-binary-file-format-with-raku-2fm6
" 
"     - --------------------------------------------------------------------
"     ʈ irc logs : …<~/doc/_irc.memo>
" 
"     See ~/doc/cookbook.memo
" 
"     ū<https://fosstodon.org/@rakulang>
" 
"     - --------------------------------------------------------------------
"     ʈ ´binding ´Set ´SetHash
" 
"         ☰2025-02-03.Mon
"     ū<https://stackoverflow.com/...>
" 
"     ⋯
" 
" Some of these files have thousands of lines and dozens of sections.
" 
" The following code first builds a page like this:
" 
"     /tmp/pel.memo
"      6   parse binary
"     11   irc logs : …<~/doc/_irc.memo>
"     18   ´binding ´Set ´SetHash
"     31   parse binary
"     36   irc logs : …<~/doc/_irc.memo>
"     43   ´binding ´Set ´SetHash
"     ⋯
" 
" So I can scan that visually, or search for some text, whatever, and
" when I move my cursor to the desired line, for example ‹31   parse
" binary›, it closes that window and moves the cursor to line 31 in the
" original file.

nnoremap <c-f8> :call _ProgFunc(
  \ 'if $line ~~ /^ [$<indentl-level> = \s*] ' .
  \ '$<entry> = [[sub\|method\|class\|grammar\|multi] ｢ ｣ .* ] / {'
  \ )<cr>

nnoremap <f8>   :call _ProgFunc(
  \ 'if $line ~~ /^ .*? ｢ʈ｣ [$<indentl-level> = \d+]? \s+ $<entry> = [.*] / {'
  \ )<cr>

func! _ProgFunc (rakuRegex)
    if &modified
        echo "File is modified. Save it first."
        return
    endif

    let l:fRead = expand("%:p")
    let l:fWryt = tempname()

    let l:rakuFuncBeg =<< EoP
        sub foo ($fRead, $fWryt) {
            my $line-num = 0;
            my @found;
            $fRead.IO.lines.map: {
                my $line = $_;
                ++$line-num;
EoP

    let l:rakuFuncEnd =<< EoP
                    @found.push([$line-num, $<indentl-level> ~ $<entry>]);

                }
            }
            my $precis = ($line-num.log / 10.log).truncate + 1;
            my $toc-lines = "";
            for @found -> $d {
                my ($line-num, $line) = @$d;
                $toc-lines ~= sprintf "%{$precis}d   %s\n", $line-num, $line;
            }
            $fWryt.IO.spurt: "$fRead\n$toc-lines";
        };
EoP

    let l:rakuInvoc = [ printf("foo(q|%s|, q|%s|)", l:fRead, l:fWryt) ]
    let l:cmd = printf("raku -e '%s'", join(l:rakuFuncBeg + [ a:rakuRegex ] + l:rakuFuncEnd + l:rakuInvoc, "\n"))

   " echo l:cmd | echo input("Press a key to continue...")
    call system(l:cmd)
    exec "edit " . l:fWryt
        " Pressing Enter on a line will open the file at the line
        " number that it happens
    nnoremap <buffer> <cr> :call OpenHere()<cr>
endfunc

    " Current line should read like ⦃582 Chomp a string⦄. Open the
    " file that was shown on line-1 at the line number that is shown
    " on the current line.
func! OpenHere ()
    let l:saved_ = getreg("")
    let l:saved_x = getreg("x")
    normal! "xyy
    let l:num = matchstr(@x, '\d\+')
    normal! gg"xyy
    let l:file = matchstr(@x, '[^\n]\+')
    call setreg('x', l:saved_x)
    bd
    exec "edit " . l:file
    exec "normal! " . l:num . "Gzt"
    call setreg('', l:saved_)
endfunc

" --------------------------------------------------------------------
" ʈ surrounders
" This works with Tim Pope's ‹surround› plugin. For example, in normal
" mode, surround visually selected text by typing ‹S› followed by
" either a lowercase, uppercase, or smallcaps letter to surround
" respectively plainly, padding with spaces, or padding with
" non-breaking spaces.
"
" It also allows inserting empty boilerplate surrounders by entering
" <f2> followed by the letter (lowercase, uppercase, or smallcaps),
" which will also properly place the cursor for insertion.

func! BigSurr (char_lower, pfx, sfx, ...)
    let l:lL = a:char_lower     " lowercase Letter
    let l:lN = char2nr(l:lL)    " lowercase letter Number value

    let l:uN = l:lN - 32        " uppercase letter Number value
    let l:uL = nr2char(l:uN)    " uppercase Letter

        " These globals are used by the ‹surround› package. The
        " carriage return will be replaced by the original text.
    exec printf("let g:surround_%d = '%s\r%s'",   l:lN, a:pfx, a:sfx)
    exec printf("let g:surround_%d = '%s \r %s'", l:uN, a:pfx, a:sfx)

        " If there is a 4th arg to the function, it will be placed
        " midway.
    if a:0 != 0
        let l:mid = a:1
        exec 'nnoremap <f2>' . l:lL   ' i' . a:pfx .       l:mid .       a:sfx . '<esc>i'
        exec 'nnoremap <f2>' . l:uL . ' i' . a:pfx . ' ' . l:mid . ' ' . a:sfx . '<esc>hi'
        exec 'inoremap <f2>' . l:lL   '  ' . a:pfx .       l:mid .       a:sfx . '<esc>hi'
        exec 'inoremap <f2>' . l:uL . '  ' . a:pfx . ' ' . l:mid . ' ' . a:sfx . '<esc>2hi'
    else
        exec 'nnoremap <f2>' . l:lL   ' i' . a:pfx .                     a:sfx . '<esc>i'
        exec 'nnoremap <f2>' . l:uL . ' i' . a:pfx . ' ' .         ' ' . a:sfx . '<esc>hi'
        exec 'inoremap <f2>' . l:lL   '  ' . a:pfx .                     a:sfx . '<esc>i'
        exec 'inoremap <f2>' . l:uL . '  ' . a:pfx . ' ' .         ' ' . a:sfx . '<esc>hi'
    endif
endfunc

        " The 
    call BigSurr('a', '◆<', '>'     ) " Program name: Launch ◆<nvim> in your terminal.
  " call BigSurr('b',                 " SEEMS NOT TO BE MAPPABLE ☰2025-05-31.Sat.
    call BigSurr('c', '❲',  '❳', '∣') " Choice: Choose one of ❲a∣b∣c❳.
    call BigSurr('d', '⌊',  '⌉'     ) " Consequence of example: ⦃21*2⦄ gives ⌊42⌉.
    call BigSurr('e', '⦃',  '⦄'     ) " Example value: ⦃21*2⦄ gives ⌊42⌉.
    call BigSurr('f', '…<', '>'     ) " File or directory: …</etc/passwd>
    call BigSurr('g', '⟪',  '⟫'     ) " GUI: Select ⟪Inksc⇣tools:Bezier Tool (⇧F6)⇣mode:⦃…regular…⦄⟫.
  " call BigSurr('h',
  " call BigSurr('i',
    call BigSurr('j', '∿<', '>'     ) " Project directory: ∿<t/nvim>
    call BigSurr('k', '｢',  '｣'     ) " Literal Raku quoting: ｢No $interpolation.\n｣
  " call BigSurr('l',
  " call BigSurr('m',
  " call BigSurr('n',
    call BigSurr('o', '᚜', '᚛'      ) " Operator: Going back to this ☰2025-05-03.Sat
    call BigSurr('p', 'ᴘ<', '>'     ) " Password location: ᴘ<lp/bazfoo/s>
  " call BigSurr('q',
    call BigSurr('r', '⟦',  '⟧'     ) " Reftag: ⟦⋯ p_36/23⟧
    call BigSurr('s', '«',  '»'     ) " French guillemets: «Le film L'argent».
    call BigSurr('t', '⟨',  '⟩'     ) " A kind of something: ▸ cp ⟨file from⟩ ⟨file to⟩
    call BigSurr('u', 'ū<', '>'     ) " URL: ū<https://github.com/lucs/>
    call BigSurr('v', 'ε<', '>'     ) " LaTeX environment name:
  " call BigSurr('w',
    call BigSurr('x', 'κ<', '>'     ) " Packages LaTeX et Vim: κ<fontspec>, κ<pgsep>
  " call BigSurr('y',
    call BigSurr('z', '‹',  '›'     ) " Quotes: Quote ‹like this›.

" --------------------------------------------------------------------

    " In the past, needed to fix these too:
    "   \ 'ª' : '´',
    "   \ '£' : '◆',
    "   \ '※' : '‼',
    "   \ 'Ť' : '⁇',
    "   \ '‣' : '▸',
    "   \ '←' : '◂',
    "   \ '₋' : 'FIXME',
    "   \ '⟨' : 'FIXME',
    "   \ '⟩' : 'FIXME',
    "   \ 'Ŏ' : 'ɱ',
    "   \ 'Ň' : 'Ɲ',
func! L_fixMarkers ()
    call _FixEncoding({
      \ '⌘' : '☰',
    \})
endfunc

func! L_fixEncodingSimple ()
    call _FixEncoding({
      \ 'Â§'  : '§',
      \ 'Ã§'  : 'ç',
      \ 'Ã¢'  : 'â',
      \ 'Ã€'  : 'À',
      \ 'Ã®'  : 'î',
      \ 'Ã\*' : 'É',
      \ 'Ã©'  : 'é',
      \ 'Ã '  : 'à',
      \ 'Â '  : ' ',
      \ 'Ã´'  : 'ô',
      \ 'Ã¨'  : 'è',
      \ 'Å“'  : 'œ',
      \ 'Ã¹'  : 'ù',
      \ 'â€“' : '–',
      \ 'Â«'  : '«',
      \ 'Â»'  : '»',
      \ 'Ãª'  : 'ê',
      \ 'Ã«'  : 'ë',
      \ 'Ã»'  : 'û',
      \ 'â€™' : '’',
      \ 'â€¦' : '…',
    \})
endfunc

func! L_fixEncodingDouble ()
    call _FixEncoding({
      \ 'â€¦' : '…',
      \ 'â€™' : '',
      \ 'â€¢' : ':',
      \ 'آ°'  : '°',
      \ 'أ¢'  : 'â',
      \ 'أ§'  : 'ç',
      \ 'أ©'  : 'é',
      \ 'أ¨'  : 'è',
      \ 'أ´'  : 'ô',
      \ 'أ '  : 'à',
      \ 'إ“'  : 'œ',
      \ 'â€œ' : '"',
      \ 'â€“' : '–',
      \ 'â€*' : '"',
      \ 'ﺃ®'  : 'î',
      \ 'ﺃ»'  : 'û',
    \})
endfunc

func! _FixEncoding (pairs)
    for l:key in keys(a:pairs)
        let l:val = get(a:pairs, l:key)
        try
            exec "%s/" . l:key . "/" . l:val . "/gc"
        catch
        endtry
    endfor
endfunc

    " Yank full path of current file into unnamed register.
nnoremap ,yp :let @" = expand("%:p")<cr>

" --------------------------------------------------------------------
" Save timestamped file. The filename will be a timestamp, and the
" file will be placed in the shown directory under the project
" directory. Make sure the file is referenced in the Log file, to make
" it easy to know what they're about.

func! L_saveasTimestamped ()
    let l:dRoot = $PRJ_DIR
    let l:dSnip = 'Timestamped'
    let l:dTs = l:dRoot . "/" . l:dSnip
    if ! isdirectory(l:dTs)
        echo "No such directory: " . l:dTs
    else
        let l:fTs = _CalcTimestamp('NOW', 2) . ".txt"
        let l:fSpec = l:dTs . "/" . l:fTs
        try
            let l:saved_b = getreg("b")
            exec "normal! Go‥<\$PRJ_DIR/" . l:dSnip . "/" . l:fTs . ">\r\<esc>"
            exec "saveas " . l:fSpec
        catch
            echo "Caught" v:exception
        endtry
    endif
endfunc

" --------------------------------------------------------------------
nnoremap :: :w<cr>
nnoremap :' :w<bar>:bd<cr>
nnoremap :/ :bd<cr>

nnoremap g9 :setl noma!<cr>

" --------------------------------------------------------------------
let NERDTreeWinPos = "right"
let NERDTreeQuitOnOpen = 1

" --------------------------------------------------------------------
if has('perl')
    let myINC = system("perl -e '$,=\" \";print @INC'")
    perl push @INC, split(/ /,VIM::Eval("myINC"))
endif

" --------------------------------------------------------------------
" Underline, etc., with Unicode combining characters.
" From
" http://vim.wikia.com/wiki/Create_underlines,_overlines,_and_strikethroughs_using_combining_characters#

    " Modify selected text using combining diacritics.
command! -range -nargs=0 Overline        call _CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call _CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call _CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 StrikeThrough   call _CombineSelection(<line1>, <line2>, '0336')
command! -range -nargs=0 SlashThrough    call _CombineSelection(<line1>, <line2>, '0338')

func! _CombineSelection(line1, line2, cp)
    let l:savedB = @b
    normal! mb
    execute 'let char = "\u'.a:cp.'"'
    execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
    normal! `b
    let @b = l:savedB
endfunc

vnoremap CO :Overline<cr>
vnoremap CU :Underline<cr>
vnoremap CD :DoubleUnderline<cr>
vnoremap CS :StrikeThrough<cr>
vnoremap CL :SlashThrough<cr>

" --------------------------------------------------------------------
" Toggle HTML/XML style comments.
"
"   |<!-- foo ⋯ -->
"   |<foo ⋯>
"
"   |    <foo ⋯>
"   |    <!-- foo ⋯ -->

func! XmlStyleOneLine ()
        " Remove the comment.
    if match(getline('.'), '<!--.*-->') != -1
        exec ':s,<!--\s*,<,'
        exec ':s,\s*-->,>,'
    elseif match(getline('.'), '<!--') != -1
        echo "Multiline comment: fix by hand."
        " Convert to comment.
    elseif match(getline('.'), '<') == -1
        echo "No tag here."
    else
        exec ':s,<,<!-- ,'
        exec ':s,\s*>, -->,'
    endif
    nohl
endfunc

nnoremap <silent><Plug>XmlStyleOneLine :call
  \ XmlStyleOneLine()<cr>:call repeat#set("\<Plug>XmlStyleOneLine")<cr>
nnoremap ,cx <Plug>XmlStyleOneLine

" --------------------------------------------------------------------
" Toggle ‹/*⋯*/› style one line comments.
"
"   |int main() ⋯
"   |/*0 int main() ⋯ */
"
"   | printf ⋯

"
"   |  printf ⋯
"   |/* printf ⋯ */
"
"   |   printf ⋯
"   | /* printf ⋯ */
"
"   |    printf ⋯
"   |  /* printf ⋯ */
"
" /*0 adcfadf */
" /*1  adcfadf */
"  /* adcfadf */
"   /* adcfadf */

func! CStyleOneLine ()
    let l:savedSearchReg = @/

        " Remove the comment.
    if match(getline('.'), '^/\*0') != -1
        echo getline(".")
        exec ':s,/\*0\s*,,'
        exec ':s,\s*\*/,,'
    elseif match(getline('.'), '^/\*1') != -1
        echo getline(".")
        exec ':s,/\*1\s*, ,'
        exec ':s,\s*\*/,,'
    elseif match(getline('.'), '/\*') != -1
        exec ':s,/\*\s*,  ,'
        exec ':s,\s*\*/,,'

        " Convert to comment.
    else
            " LS : Leading Spaces.
        let nbLSCurr = indent(line("."))
        if nbLSCurr == 0
            exec ':s,^,/*0 ,'
            exec ':s,$, */,'
        elseif nbLSCurr == 1
            exec ':s,^,/*1 ,'
            exec ':s,$, */,'
        else
            let LSWant = repeat(" ", nbLSCurr - 2)
            exec ':s,^\s*,' . LSWant . '/* ,'
            exec ':s,$, */,'
        endif
    endif
    nohl
    let @/ = l:savedSearchReg
endfunc

nnoremap <silent><Plug>CComment :call
  \ CStyleOneLine()<cr>:call repeat#set("\<Plug>CComment")<cr>
nnoremap ,cc <Plug>CComment

" --------------------------------------------------------------------
" Toggle single character ｢#⋯｣ prefix style one line comments.
" Presumes that the code starts in column 1 or is indented with 4
" spaces or more. So converts between pairs of lines like these:
"
"   |my $x ⋯
"   |#0 my $x ⋯
"
"   | my $x ⋯
"   |#1 my $x ⋯
"
"   |  my $x ⋯
"   | # my $x ⋯
"
"   |    my $x ⋯
"   |   # my $x ⋯

func! PfxLine (pfx_char)
    let l:line = getline('.')
    if strlen(l:line) == 0
        return
    endif
    let l:col_1_char = (l:line)[0]
    if l:col_1_char != ' '
        if l:col_1_char == a:pfx_char
            exec ':.s,' . a:pfx_char . ',,'
        else
            exec ':.s,^,' . a:pfx_char . ','
        endif
    else

        let l:first_nonblank_char = matchstr(l:line, '  \zs\S\ze')
        if l:first_nonblank_char == a:pfx_char
            exec ':.s, ' . a:pfx_char . ', ,'
        else
            exec ':.s,\( \S\),' . a:pfx_char . '\1,'
        endif
    endif
    normal! ll
endfunc

" --------------------------------------------------------------------
nnoremap <silent><Plug>XresPfx :call
  \ PfxLine('!')<cr>:call repeat#set("\<Plug>XresPfx")<cr>
nnoremap ,c! <Plug>XresPfx

nnoremap <silent><Plug>TextPfx :call
  \ PfxLine('-')<cr>:call repeat#set("\<Plug>TextPfx")<cr>
nnoremap ,c- <Plug>TextPfx

nnoremap <silent><Plug>PerlPfx :call
  \ PfxLine('#')<cr>:call repeat#set("\<Plug>PerlPfx")<cr>
nnoremap ,c# <Plug>PerlPfx

nnoremap <silent><Plug>VimPfx :call
  \ PfxLine('"')<cr>:call repeat#set("\<Plug>VimPfx")<cr>
nnoremap ,c" <Plug>VimPfx

nnoremap <silent><Plug>TexPfx :call
  \ PfxLine('%')<cr>:call repeat#set("\<Plug>TexPfx")<cr>
nnoremap ,c% <Plug>TexPfx

    " Try to abstract out the commonality, failed so far. Try again
    " later.
" func! Florb (name, nmap, pfx_char)
"     let l:plug_name = 'Florb' . a:name
"     exec ':nnoremap <silent><Plug>' . l:plug_name .
"       \ ':call PfxLine('a:pfx_char')<cr>i
"     :call repeat#set("\<Plug>l:plug_name")<cr>
"     nmap a:nmap <Plug>Florb . a:name
" endfunc
" Florb('text', ',cx', '-')

" --------------------------------------------------------------------
" Similar to something found at
" http://vim.wikia.com/wiki/Easier_buffer_switching
func! _BufSel (pattern, listunlisted)
    let bufcount = bufnr("$")
    let currbufnr = 1
    let nummatches = 0
    let firstmatchingbufnr = 0
    if a:pattern == ""
        let pattern = "."
    else
        let pattern = a:pattern
    endif
    while currbufnr <= bufcount
        if (bufexists(currbufnr))
            if (buflisted(currbufnr) || a:listunlisted == 1)
                let currbufname = bufname(currbufnr)
                if (match(currbufname, pattern) > -1)
                    echo currbufnr . ": ". bufname(currbufnr)
                    let nummatches += 1
                    let firstmatchingbufnr = currbufnr
                endif
            endif
        endif
        let currbufnr = currbufnr + 1
    endwhile
    if (nummatches == 1)
        execute ":buffer ". firstmatchingbufnr
    elseif (nummatches > 1)
        let desiredbufnr = input("Enter buffer number: ")
        if (strlen(desiredbufnr) != 0)
            execute ":buffer ". desiredbufnr
        endif
    else
        echo "No matching buffers"
    endif
endfunc
command! -nargs=* Bs  :call _BufSel("<args>", 1)
command! -nargs=* Bs2 :call _BufSel("<args>", 0)
nnoremap <f6> :Bs<cr>
nnoremap <f5> :Bs2<cr>

" --------------------------------------------------------------------
" To make sure ftdetect are reread.
"
    " Clear autocommands.
"autocmd!
filetype on
"filetype off
filetype plugin on

" --------------------------------------------------------------------
" http://vim.wikia.com/wiki/Avoid_scrolling_when_switch_buffers

    " Save current view settings on a per-window, per-buffer basis.
func! SaveWinView()
    if ! exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunc

    " Restore current view settings.
func! RestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunc

    " When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call SaveWinView()
    autocmd BufEnter * call RestoreWinView()
endif

" --------------------------------------------------------------------
" ʈ Options

    " Disable loading of the plugin.
let loaded_matchparen = 1

setglobal fileencoding=utf-8

" set autowrite
set noautoread
set backspace=indent,eol,start
set confirm
set encoding=utf-8
set expandtab
set ffs=unix,dos,mac

    " The default is '│' (U+2502), which ◆<urxvt> appears not to
    " accept in its "cutchars", so changing it here allows capturing
    " text with the mouse without grabbing the vertical window
    " separator character.
set fillchars+=vert:\|

set hidden
set history=1000
set hlsearch
set incsearch
set laststatus=2
set modeline
set modelines=3

    " ☰2024-11-29.Fri Allows me to mouse-resize split windows.
set mouse=n
    " ☰2024-11-26.Tue Mouse disabled to try to make ◆<urxvt>'s
    " ‹cutchars› work -- but it didn't work, something else must be
    " interfering.
"set mouse=

set nobackup
set nodigraph
set nojoinspaces
set nostartofline
set notimeout ttimeout ttimeoutlen=0
"set notimeout ttimeout ttimeoutlen=200
set title
set nowrapscan
set nowritebackup
set shortmess=atIToO
set showcmd
set showmatch
set splitbelow
set tabstop=4 softtabstop=4 shiftwidth=4
set textwidth=70
set noruler
set whichwrap+=<,>,[,]
set wildmenu

" --------------------------------------------------------------------
let s:do_list = 0
func! ToggleList ()
    if s:do_list == 0
        set list listchars=tab:→․,trail:·
    else
        set list listchars=tab:\ \ ,trail:·
    endif
    let s:do_list = 1 - s:do_list
endfunc
call ToggleList()
nnoremap ,<f4> :call ToggleList()<cr>

" --------------------------------------------------------------------
if has("gui_running")
    set guifont=Monospace\ 12
    set lines=48
    set columns=123
endif

" --------------------------------------------------------------------
" "Execute the vimscript that is visually highlighted."
"
" That is, you visually highlight some vimscript, press F9 (you can
" change that, eh) and that highlighted vimscript will be executed. I
" find this Sofa King Useful when developing shortcuts or pretty much
" any vimscript code.
"
"   ☰2024-07-11.Thu
"   Much simpler method can be derived from this post.
" https://vi.stackexchange.com/a/36440
"
"   The idea is to source a yanked block of text.
"   nnoremap <silent> <LEADER>sy :@"<CR>
"
"   :map <f12> :exec "echo 'Hi' " .
"   \ "'there."<cr>

function! ExecHighlighted () range
        " Grab the highlighted text: save the contents of an arbitrary
        " register, yank the highlighted text to it, copy the register
        " contents to a local variable, and restore the register
        " contents.
    let l:saved_a = @a
    silent! normal! gv"ay
    let l:text = @a
    let @a = l:saved_a

        " Concatenate continuation lines, else for some reason it
        " fails to work.
    let l:text = substitute(l:text, '\n\s*\\\s*', ' ', 'g')

        " Execute the grabbed text.
   " echo '⦃' . l:text . '⦄'
    exec l:text

endfunction

    " Have a Visual-mode-only mapping to invoke the function.
xnoremap <f9> :call ExecHighlighted()<cr>

" --------------------------------------------------------------------
" Miscellaneous mappings

    " Why?
"nnoremap ' `
"nnoremap ` '

    " Toggle between ‹paste› and ‹nopaste›.
nnoremap <silent> <f3> :call _TogglePaste()<cr>
func! _TogglePaste ()
    if &paste == 0
        set paste
    else
        set nopaste
    endif
    call BuildUpStatusLine()
endfunc

nnoremap <silent> <f4> :call _ToggleScrollOffset()<cr>
func! _ToggleScrollOffset ()
    if &scrolloff == 0
        set scrolloff=100
    elseif &scrolloff == 100
        set scrolloff=0
    endif
    call BuildUpStatusLine()
    normal! jk
endfunc

    " Move between buffers.
nnoremap H <Nop>
nnoremap L <Nop>
nnoremap HH :bp<cr>
nnoremap Hh H
nnoremap LL :bn<cr>
nnoremap Ll L

    " ☰2024-11-11.Mon I just commented this out. Not sure why I used
    " to do this. So now, ‹J› concatenates current line with following
    " one inserting a space between, and ‹gJ›, with no space between.
    "
    " To have an equivalent to the original ‹J› mapping.
"nnoremap J. J

    " Maybe... ☰2024-11-11.Mon
"nmap gj Jx
"nnoremap gJ gJ

    " To trap the ISO_Left_Tab xterm (I guess) mapping.
" nmap <esc>[Z <s-tab>

    " Force UTF-8 encoding.
    " 2021-06-25 Don't waste 'gt' for a too infrequent operation.
"nmap gt8 :set fenc=utf-8<cr>

    " Keep highlighting when shifting text in or out.
vnoremap < <gv
vnoremap > >gv

    " Prompt for clearing lines of trailing blanks.
func! _ClearTrailingBlanks ()
    try
            " Spell out: space, tab, U+00A0.
        %s/[ \t ]\+$//c
    catch
        echo "No trailing blanks found."
    endtry
    nohl
endfunc
nnoremap <silent> gs :call _ClearTrailingBlanks()<cr>

    " ʈ Yank string under cursor into search register.
map gy "ayiW:let @/ = @a<cr>

" " --------------------------------------------------------------------
" 2019-09-23.21-06-03
" Meh. This fails with 'nvr', or something. Forget about it. Temporary
" files created by 'vv' are now named with suffix '.gentmp'.
"
" func! _DeleteUnloaded ()
"     let fname = expand('<afile>')
"     let bname = bufname(fname)
"    " let junk = input(bname)
"     exec ":bwipeout " . bname
"     return system("rm " . fname)
" endfunc
" autocmd BufUnload *.TO_DELETE :call _DeleteUnloaded()

" --------------------------------------------------------------------
" Open file or directory (FoD) browser under cursor.

    " Fails if string contains UTF-8 characters.
func! _GrabDelimitedString (lft_delim_chars, rgt_delim_chars)
    let l:cursor_col = getcurpos()[2]
    let l:line  = getline(".")
    let l:grab_beg_at = l:cursor_col
    let l:grab_end_at = l:cursor_col
        " See how far left we need to go.
    let l:lookat_col = l:cursor_col
    while l:lookat_col >= 1
        if match(a:lft_delim_chars, "\\V" . l:line[l:lookat_col - 1]) >= 0
            break
        endif
        let l:grab_beg_at -= 1
        let l:lookat_col -= 1
    endwhile
    let l:grab_beg_at += 1
        " And now, how far right.
    let l:lookat_col = l:cursor_col
    let l:line_len = strlen(getline("."))
    while l:lookat_col <= l:line_len
        if match(a:rgt_delim_chars, "\\V" . l:line[l:lookat_col - 1]) >= 0
            break
        endif
        let l:grab_end_at += 1
        let l:lookat_col += 1
    endwhile
    let l:grab_end_at -= 1
    return strpart(l:line, l:grab_beg_at - 1, l:grab_end_at - l:grab_beg_at + 1)
endfunc

func! _GetFileOrDirUnderCursor (accept_spaces)
    let l:delim_rgt = '>"'
    let l:delim_lft = '<"'
    if ! a:accept_spaces
        let l:delim_rgt .= ' '
        let l:delim_lft .= ' '
    endif
    let l:delim_str = _GrabDelimitedString(l:delim_lft, l:delim_rgt)

        " In case the string contains things that need to be expanded,
        " like envvars or ⦃~⦄ or ⦃~lucs⦄ or something.
    let l:delim_str = expand(l:delim_str)
    return l:delim_str
endfunc

     " \ "^\\~\\([^/]\\+\\)",
     " \ '\="/home/" . submatch(1) . "/"',

func! _LoadFileOrDir (closeAfter, openUnmodifiable)
    let l:FoD = _GetFileOrDirUnderCursor(0)
    if isdirectory(l:FoD)
        if has("gui_running")
            exec ":set bsdir=" . escape(l:FoD, '\')
            if a:closeAfter
                bdelete
            endif
            emenu File.Open\.\.\.
        else
            if a:closeAfter
                exec ":bd | :e " . l:FoD
            else
                exec ":e " . l:FoD
            endif
        endif
    else
        if filereadable(l:FoD)
            if a:closeAfter
                bdelete
            endif
            exec ":e " . l:FoD
            if a:openUnmodifiable
                setl noma
            endif
        else
            echo "Can't read file '" . l:FoD . "'."
        endif
    endif
endfunc
nnoremap ,gm :call _LoadFileOrDir(1, 0)<cr>
nnoremap ,gM :call _LoadFileOrDir(0, 0)<cr>
nnoremap ,gu :call _LoadFileOrDir(1, 1)<cr>
nnoremap ,gU :call _LoadFileOrDir(0, 1)<cr>

" --------------------------------------------------------------------
" Force filetype. ⦃:Fft vim⦄
func! _Fft (ft)
    if exists('b:did_ftplugin')
        unlet b:did_ftplugin
    endif
    exec "set ft=" . a:ft
endfunc
com! -nargs=1 Fft call _Fft("<args>")

" " --------------------------------------------------------------------
" func! _Errmess ()
"     let l:tmp_file = g:lucs_tmp_dir . "/mess.vim"
"     exec "redir! > " . l:tmp_file
"     silent mess
"     redir END
"     exec "sp " . l:tmp_file
"     norm G
" endfunc
" com! -nargs=0 M call _Errmess()

" --------------------------------------------------------------------
" Open a Raku doc file in the current Vim session. ⦃:Rd Module::Install⦄

func! _Rd (module)
    let l:savedB = @b
    let @b = system("RAKUDOC_PAGER=cat rakudoc " . a:module)[:-2]
    if v:shell_error != 0
        echo a:module "not found."
    else
        exec "normal! :new\<cr>"
        exec "normal! \<c-w>p\<c-w>c"
        normal! "bP
        setl ft=pod ro nomod noma
    endif
    let @b = l:savedB
endfunc
com! -nargs=1 Rd call _Rd("<args>")

" --------------------------------------------------------------------
" Open a Perl module in the current Vim session. ⦃:Pm Module::Install⦄
func! _Pm (module)
    let f = system("perl -MModule::Locate "
      \ . "-e 'print scalar(Module::Locate::locate(" . a:module . "))'")
    if empty(f)
        echo a:module "not found."
        return
    endif
    exec ":e " . f
    setl ft=perl ro nomod noma
endfunc
com! -nargs=1 Pm call _Pm("<args>")

" --------------------------------------------------------------------
" Open a Perl POD file in the current Vim session. ⦃:Pd Module::Install⦄
func! _Pd (module)
    let f = system("perldoc -l " . a:module)[:-2]
    if v:shell_error != 0
        echo a:module "not found."
        return
    endif
    exec ":e " . f
    setl ft=pod ro nomod noma
endfunc
com! -nargs=1 Pd call _Pd("<args>")

" " --------------------------------------------------------------------
" " View a Perl POD file in the current Vim session. ⦃:Pod
" " Module::Install⦄
" func! _Pod (module)
"         " We will read the data into this file.
"     let fname = g:lucs_tmp_dir . "/" . a:module . ".TO_DELETE"
"         " Move to it if it's already open.
"     let bnum = bufnr(fname)
"     if bnum != -1
"         exec ":e #" . bnum
"         return
"     endif
"     let f = system("perldoc -l " . a:module)[:-2]
"     if v:shell_error != 0
"         echo a:module "not found."
"         return
"     endif
"         " Open a new buffer unless the current one is available.
"     if bufname('%') != '' || &modified
"         new
"         only
"     endif
"    " echo "r!" . "pod2man -u " . f . " | /usr/bin/man -Tutf8 -l - | col -bx"
"    " return
"    "
"    " exec "r!" . "pod2man -u " . f . " | /usr/bin/man -Tutf8 -l - "
"         "Good line.
"     exec "r!" . "pod2man -u " . f . " | /usr/bin/man -Tutf8 -l - | col -bx"
"
"    " exec "r!" . "pod2man " . f . " | nroff -man | col -bpx | iconv -c"
"     setl ft=man nolist fenc=utf8 ro nomod noma
"     norm gg
"     exec ":w " . fname
" endfunc
" com! -nargs=1 Pod call _Pod("<args>")

" " --------------------------------------------------------------------
" " View a Perl6 synopsis (design doc) POD file in the current Vim
" " session. ⦃:Sod 12⦄
" func! _Sod (synopsis_num)
"         " We will read the data into this file.
"     let fname = g:lucs_tmp_dir . "/S" . a:synopsis_num . ".TO_DELETE"
"         " Move to it if it's already open.
"     let bnum = bufnr(fname)
"     if bnum != -1
"         exec ":e #" . bnum
"         return
"     endif
"     let l:cmd = "find " . g:lucs_perl6specs_dir . " -name 'S" . a:synopsis_num . "*'"
"     let f = substitute(system(l:cmd), '\n\+$', '', '')
"     if v:shell_error != 0
"         echo "Synopsis" a:synopsis_num "not found."
"         return
"     endif
"     exec "edit " f
"    "     " Open a new buffer unless the current one is available.
"    " if bufname('%') != '' || &modified
"    "     new
"    "     only
"    " endif
"    " let l:cmd = "pod2man -u " . f . " | /usr/bin/man -Tutf8 -l - | col -bx"
"    " exec "r!" . l:cmd
"    " setl ft=man nolist fenc=utf8 ro nomod noma
"    " norm gg
"    " exec ":w " . fname
" endfunc
" com! -nargs=1 Sod call _Sod("<args>")

" " --------------------------------------------------------------------
" nvim implements :Man, so forget about this.
"
" " View a man page in the current Vim session. ⦃:Man ls⦄
" func! _Man (page)
"         " We will read the data into this file.
"     let fname = g:lucs_tmp_dir . "/" . a:page . ".TO_DELETE"
"         " Move to it if it's already open.
"     let bnum = bufnr(fname)
"     if bnum != -1
"         exec ":e #" . bnum
"         return
"     endif
"         " Open a new buffer unless the current one is available.
"     if bufname('%') != '' || &modified
"         new
"         only
"     endif
"     exec "r!" . "/usr/bin/man -Tutf8 " . a:page . " | col -b"
"    " exec "r!" . "/usr/bin/man -Tascii " . a:page . " | col -bpx | iconv -c"
"     setl ft=man nolist fenc=utf8 ro nomod noma
"     norm gg
"     exec ":w " . fname
" endfunc
" com! -nargs=1 Man call _Man("<args>")

" --------------------------------------------------------------------
" Enable Vim to syntax highlight specially wrapped text in a given
" syntax highlight style. For example, if we want text wrapped like
" this:
"
"   <ps-> ... <-ps>
"
" to be syntax highlighted as 'postscr' (PostScript), then invoke:
"
"   _TextEnableCodeSnip('postscr', '<ps->', '<-ps>')
"
" Sometimes, the highlighting does not end where it ought to. This
" appears to be a known bug:
"
" http://vim.wikia.com/wiki/Different_syntax_highlighting_within_regions_of_a_file

func! _TextEnableCodeSnip(filetype, start, end) abort
        " Some syntax files change the keywords identifiers, so we
        " save it here and restore it at the end.
    let l:savedIsk = &isk
    let l:ft = toupper(a:filetype)
    let l:group = 'textGroup' . l:ft
    if exists('b:current_syntax')
        let s:current_syntax = b:current_syntax
            " Remove current syntax definition, as some syntax files
            " (like cpp.vim) do nothing if b:current_syntax is
            " defined.
        unlet b:current_syntax
    endif
    execute 'syntax include @' . l:group . ' syntax/' . a:filetype . '.vim'
    try
        execute 'syntax include @' . l:group . ' after/syntax/' . a:filetype . '.vim'
    catch
    endtry
    if exists('s:current_syntax')
        let b:current_syntax = s:current_syntax
    else
        unlet b:current_syntax
    endif
    execute 'syntax sync fromstart'
    execute 'syntax region textSnip' . l:ft . '
      \ matchgroup = SpecialComment
      \ start = "' . a:start . '" end = "' . a:end . '"
      \ contains = @' . l:group
    let &isk = l:savedIsk
endfunc

func! _CodeSnipNick (filetype, nick)
    let l:start = '<'  . a:nick . '->'
    let l:end   = '<-' . a:nick . '>'
    call _TextEnableCodeSnip(a:filetype, l:start, l:end)
endfunc

func! _AllCodeSnips ()
    syntax off
    syntax on
    call _CodeSnipNick('make',       'mk')
    call _CodeSnipNick('muttrc',     'mr')
    call _CodeSnipNick('lua',        'lu')
    call _CodeSnipNick('vim',        'vi')
    call _CodeSnipNick('html',       'hl')
    call _CodeSnipNick('xml',        'xl')
    call _CodeSnipNick('javascript', 'js')
    call _CodeSnipNick('perl',       'pl')
    call _CodeSnipNick('raku',       'rk')
    call _CodeSnipNick('postscr',    'ps')
    call _CodeSnipNick('sh',         'sh')
    call _CodeSnipNick('haskell',    'hs')
    call _CodeSnipNick('css',        'cs')
    call _CodeSnipNick('sql',        'sq')
    call _CodeSnipNick('php',        'ph')
    call _CodeSnipNick('tex',        'te')
endfunc
"call _AllCodeSnips()<cr>
nnoremap <silent> gh :call _AllCodeSnips()<cr>

" --------------------------------------------------------------------
" My log entries look like this:
"
"   ⋯
"
"   .2014h.Aug27.Wed.14:12.47 .´larch Make $Test::Selector::test_id.
"
"   ® Log entries added before this line.
"
" This function inserts two lines (the second one empty) like shown
" below before that '®' line:
"
"   ⋯
"
"   .2014h.Aug27.Wed.14:12.47 .´larch Make $Test::Selector::test_id.
"
"   .2014h.Aug28.Thu.13:35.39 .´
"
"   ® Log entries added before this line.
"
" and leaves you in insert mode at the end of the first added line.
"
" If no line starts with the '®' character, the function complains.

func! _AppendLogEntry ()
        " Save search register, then move to the end of the current
        " log entries and restore the register.
    let l:savedSearch = @/
    let @/ = '^®'
    let l:savedWrapscan = &wrapscan
    set wrapscan
    try
        set lazyredraw
        normal! n
            " Insert a timestamp, a couple of newlines, come back and
            " insert the project ID prefix, and go to insert mode.
        call _InsertTimestamp(0, 'i')
       " call _InsertTimestamp('n', 0, 0)
        exec "normal! a\<cr>\<cr>"
        exec "normal! kkA .´\<esc>zz"
        startinsert!
    catch /E486/
        echo "No end-of-log indicator (®) at the beginning of any line."
    finally
        set nolazyredraw
        let @/ = l:savedSearch
        let &wrapscan = l:savedWrapscan
    endtry
endfunc

imap ,a  ´
nnoremap ,aa :call _AppendLogEntry()<cr>
nnoremap ,ar :call _AppendLogEntry()<cr>
nnoremap ,as :call _AppendLogEntry()<cr>´
nnoremap ,ad :call _AppendLogEntry()<cr>-
nnoremap ,an :call _AppendLogEntry()<cr>.

" --------------------------------------------------------------------
func! _AcuTags (option)
    if &modified
        echo "File is modified. Save it first."
    else
     " let l:cmd = g:nvim_lucs_pack . '/plugin/build_toc.p6'
        let l:cmd = g:nvim_lucs_pack . "/plugin/acutags.pl -" . a:option . " " . expand("%")
        let l:foo = system(l:cmd)
        echo l:foo
        if a:option == "f"
                " Reload file.
            edit
        endif
    endif
endfunc
nnoremap ,tl :call _AcuTags("l")<cr>
nnoremap ,tf :call _AcuTags("f")<cr>

" --------------------------------------------------------------------
" Display ‹let›s sorted in a new file.

func! L_DisplayLetSorted ()
    let l:tmpfile = tempname()
    exe "redir > " . tmpfile
    silent let
    redir END
    echomsg l:tmpfile
    perl << EoP
        use strict;
        use warnings;
        use File::Slurp::Tiny 'read_file';
        my @sorted_keys = sort {
            my ($key_a) = $a =~ / ^ (\S+) /x;
            my ($key_b) = $b =~ / ^ (\S+) /x;
            $key_a cmp $key_b;
        } grep { /\S/ } split /\n/, read_file((VIM::Eval("l:tmpfile"))[1]);
        VIM::DoCommand(":new | :only");
        VIM::DoCommand(":let l:a_saved = \@a");
        for my $key (@sorted_keys) {
            $key =~ s/'/''/g;   # ' For syntax highlighting.
            VIM::DoCommand(":let \@a = '" . $key . "'");
            VIM::DoCommand(":put a");
        }
       # VIM::DoCommand(":let \@a = l:a_saved");
EoP
   " echo "Press a key to continue..."
    normal! gg
        " Get rid of spurious first line, which is blank.
    normal! dd
        " We don't care about the fact that this is a non-saved
        " file.
    set nomodified
endfunc

" --------------------------------------------------------------------
" ʈ display sorted mappings

func! L_DisplayMappingsSorted ()
    let l:tmpfile = tempname()
    exe "redir > " . tmpfile
    silent map
    redir END
    echomsg l:tmpfile
    perl << EoP
        use strict;
        use warnings;
        use File::Slurp::Tiny 'read_file';
        my @sorted_maps = sort {
            my ($mode_a, $map_a) = $a =~ / ^ (.+?) \s+ (\S+) /x;
            my ($mode_b, $map_b) = $b =~ / ^ (.+?) \s+ (\S+) /x;
            $map_a cmp $map_b;
        } grep { /\S/ } split /\n/, read_file((VIM::Eval("l:tmpfile"))[1]);
        VIM::DoCommand(":new | :only");
        VIM::DoCommand(":let l:a_saved = \@a");
        for my $map (@sorted_maps) {
            $map =~ s/'/''/g;   # ' For syntax highlighting.
            VIM::DoCommand(":let \@a = '" . $map . "'");
            VIM::DoCommand(":put a");
        }
       # VIM::DoCommand(":let \@a = l:a_saved");
EoP
   " echo "Press a key to continue..."
    normal! gg
        " Get rid of spurious first line, which is blank.
    normal! dd
        " We don't care about the fact that this is a non-saved
        " file.
    set nomodified
endfunc

" --------------------------------------------------------------------
" ☰2025-05-11.Sun
" From ū<https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7>
" 
" Redirect the output of a Vim or external command into a scratch buffer
" 
" Usage (any shell)
" 
"         Show full output of command :hi in scratch window.
"     :Redir hi
" 
"         Show full output of command :!ls -al in scratch window.
"     :Redir !ls -al 
" 
" Additional usage (depends on non-standard shell features so YMMV)
" 
" Evaluate current line with node and show full output in scratch window:
" 
" " current line
" console.log(Math.random());
" 
" " Ex command
" :.Redir !node
" 
" " scratch window
" 0.03987581000754448
" 
" Evaluate visual selection + positional parameters with bash and show
" full output in scratch window:
" 
" " content of buffer
" echo ${1}
" echo ${2}
" 
" " Ex command
" :%Redir !bash -s foo bar
" 
" " scratch window
" foo
" bar

function! Redir(cmd, rng, start, end)
    for win in range(1, winnr('$'))
        if getwinvar(win, 'scratch')
            execute win . 'windo close'
        endif
    endfor
    if a:cmd =~ '^!'
        let cmd = a:cmd =~' %'
            \ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
            \ : matchstr(a:cmd, '^!\zs.*')
        if a:rng == 0
            let output = systemlist(cmd)
        else
            let joined_lines = join(getline(a:start, a:end), '\n')
            let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
            let output = systemlist(cmd . " <<< $" . cleaned_lines)
        endif
    else
        redir => output
        execute a:cmd
        redir END
        let output = split(output, "\n")
    endif
    vnew
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    call setline(1, output)
endfunction

" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" " --------------------------------------------------------------------
" " Note that after forking, even if the Vim app itself is closed, the
" " server will still be running, so relaunching Vim with 'vv' will
"
" func! _ForkCmd (cmd, file)
"     perl << EOT
"     use strict;
"     use warnings;
"     my $file = (VIM::Eval('a:file'))[1];
"     if (-f $file) {
"         my $gPid = fork;
"         if (! defined $gPid) {
"             VIM::DoCommand(qq<echo "Couldn't fork.">);
"
"         }
"         elsif ($gPid == 0) {
"                 # Child process.
"             system(
"                 (VIM::Eval('a:cmd'))[1],
"                 $file
"             );
"             exit;
"         }
"         # Parent process does nothing special.
"     }
"     else {
"         VIM::DoCommand("echo '<$file> not found.'");
"     }
" EOT
" endfunc
" noremap ,ce0  :call _ForkCmd('evince'  , _GetFileOrDirUnderCursor(0))<cr>
" noremap ,cf1  :call _ForkCmd('firefox' , _GetFileOrDirUnderCursor(1))<cr>
" noremap ,cg0  :call _ForkCmd('gnumeric', _GetFileOrDirUnderCursor(0))<cr>
" noremap ,cg1  :call _ForkCmd('gnumeric', _GetFileOrDirUnderCursor(1))<cr>

" --------------------------------------------------------------------
" Syntax highlighting and colors.

    " Modified 2019-12-17
if $DISPLAY == ''
        " We are probably in a console terminal.
    colorscheme blue_lucs
else
        " We are probably in a X terminal.
    colorscheme desert256
endif

if $TMUX == ''
    set notermguicolors
else
    set termguicolors
endif

" --------------------------------------------------------------------
" ʈ Build up the status line

" Elements I use:
"
"   \       Insert a space.
"   -4.4    Set a width.
"   ➤
"   %f      Relative path to file in buffer.
"   %l      Line number.
"   %L      Total number of lines.
"   %m      Modified flag.
"   %n      Buffer number.
"   %P      Percentage through file.
"   %c      Real cursor position (often > %v).
"   %v      Apparent cursor position.
"   %*      Select 'statuslineNC' color set ("Not Current" window).
"   %1*     Select color set User1.
"   ⋯
"   %9*     Select color set User9.

" --------------------------------------------------------------------
func! BuildUpStatusLine ()
        " Initialize statusline.
    set statusline=

        " Buffer number.
    set statusline+=%3*\ %n

        " ‹mod. flag›.
    set statusline+=%3*%m\

        " ‹ ⟨line num.⟩/⟨nb. of lines⟩ ›.
    set statusline+=%*\ %l/%L\

        " Cursor position ‹ ⟨apparent⟩➤⟨real⟩/⟨and text width⟩›.
    set statusline+=%4*\ %v➤%c/%{&tw}\

        " Flag: vertical scroll holds cursor in middle of screen.
    set statusline+=%1*%{&scrolloff==100?'S':'\ '}

        " Flag: is Paste on?
    set statusline+=%2*%{&paste==1?'P':'\ '}

        " Relative file path.
        " ☰2023-06-14.Wed Used to be ‹⋯%f\ ›
    set statusline+=%*\ %t\

        " Rest of the line.
    set statusline+=%*
endfunc
call BuildUpStatusLine()

" --------------------------------------------------------------------
func! _ToggleSyntaxHi ()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
    endif
endfunc

    " Initialize.
syntax enable
nnoremap <silent> <f7> :call _ToggleSyntaxHi()<cr>

"set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
"set guicursor=n-v-c-sm:ver25,i-ci-ve:ver25,r-cr-o:hor20
"hhset guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
"hi Cursor guifg=black guibg=green gui=reverse
"set guicursor=a:block-blinkon100-Cursor/Cursor

