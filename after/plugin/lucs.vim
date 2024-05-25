" --------------------------------------------------------------------
" Globals
"
"       ⦃/home/lucs⦄, ⦃/root⦄, usually set in …<.init.⟨user⟩.vim>.
"   g:user_home_dir
"
"       ⦃lucs⦄, ⦃c_suz_vch⦄, usually set in …<.init.vim>.
"   g:prj_nick

    " Raku identifier stuff.
imap <c-r>2 ƻ
imap <c-r>a Λ
imap <c-r>d ď
imap <c-r>f ƒ
imap <c-r>h ͱ
imap <c-r>i ᵢ
imap <c-r>r ʀ
imap <c-r>t ť

    " Makes it possible to enter the characters when searching for
    " example.
cmap <c-r>2 ƻ
cmap <c-r>a Λ
cmap <c-r>d ď
cmap <c-r>f ƒ
cmap <c-r>h ͱ
cmap <c-r>i ᵢ
cmap <c-r>r ʀ
cmap <c-r>t ť

" --------------------------------------------------------------------
" ☰2024-03-23.Sat
"
" When in a Makefile, the syntax setting has ‹:set noexpandtab›, which
" is usually what one wants. But in comments, I would like to
" be able to use tabs to indent text, but have spaces, not tabs, in
" the text. This macro

imap <s-tab> <esc>:call TabAsSpaces()<cr>a

func! TabAsSpaces ()
    let l:saved_expandtab = &expandtab
    setl expandtab
    if getcharpos('.')[2] > 1
        exec "normal a\<tab>"
    else
        exec "normal i\<tab>"
    endif
    if l:saved_expandtab
        setl expandtab
    else
        setl noexpandtab
    endif
endfunc

" --------------------------------------------------------------------
" ʈ surround replace substitute
" Search for and replace ｢⋯｣ surrounders with either no change, ⟨⋯⟩,

" ｢⋯｣ ｢⋯ ｢⋯｣ ｣ ｢⋯｣ ｢⋯｣
" ｢⋯｣ ｢⋯ ｢⋯｣ ｣ ｢⋯｣ ｢⋯｣

" ｢⋯｣ ｢⋯ ｢⋯｣ ｣ ｢⋯｣ ｢⋯｣

func! ReplSurround ()
    try
        let l:saved_search = @/
        normal k
        /｢[^｢]\{-}｣
        set cursorline
        redraw
        echo "Replace with: 1:⟨⋯⟩ 2:‹⋯› other:abort : "
        let l:reply = getcharstr()
        if l:reply == '1'
            :s/｢\([^｢]\{-}\)｣/⟨\1⟩/gc
        elseif l:reply == '2'
            :s/｢\([^｢]\{-}\)｣/‹\1›/gc
        endif
        let @/ = l:saved_search
        set nocursorline
        echo ""
       " /｢[^｢]\{-}｣
        redraw
       " exec "normal 0\<esc>"
        exec "normal \<esc>"
    finally
        set nocursorline
        echo ""
       " /｢[^｢]\{-}｣
        redraw
    endtry
endfunc
nmap cd :call ReplSurround()<cr>

func! MoarReplSurround ()
    try
        while 1
            call ReplSurround()
        endwhile
    finally
        set nocursorline
        echo ""
       " /｢[^｢]\{-}｣
        redraw
    endtry
endfunc
nmap cm :call MoarReplSurround()<cr>

" --------------------------------------------------------------------
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
lua << EoF
-- Submitted by pel⧺☰2023-10-08.Sun.
--
-- Print out variable profile code
--
-- console.log('var: ' = var); // in JS
-- note("var: <$var>"); # in Raku

local function not_empty(s) return s ~= nil and s ~= '' end

_G.var_profiler = function()
    local lang_map = {
        ['javascript'] = 'JS',
        ['raku'] = 'Raku',
    }
    if lang_map[vim.bo.filetype] == nil then return end
    local output_map = {
        ['javascript'] = "console.log(`%s: ${%s}`);",
        ['raku'] = 'note("%s: <$%s>");',
    }
    local vars
    vim.ui.input(
        { prompt = string.format(
            'Enter %s var name(s): ', lang_map[vim.bo.filetype]
        )},
        function(input) vars = input end
    )
    if not_empty(vars) then
        for var in vars:gmatch('%S+') do
            local line = string.format(
                output_map[vim.bo.filetype], var, var
            )
            vim.api.nvim_put({ line }, 'l', false, true)
        end
    end
end

--vim.keymap.set('n', '<leader>p', var_profiler)

--[[
    I updated our variable profiler code. I do automagical (he he you
    don't like that word!) filetype detection. If the filetype is not
    supported, I have a guard clause that exits silently. I also used
    the leader key with p for profile. Of course, you can keep your Kn
    if you wish.

    I like this because I can easily add other languages in the
    future.
--]]

EoF

" --------------------------------------------------------------------

   " Identify the syntax highlighting group used at the cursor
   " ū<http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor>
:map <f10> :echo
    \     "hi<"    . synIDattr(synID(line("."), col("."), 1), "name")
    \ . '> trans<' . synIDattr(synID(line("."), col("."), 0), "name")
    \ . "> lo<"    . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
    \ . ">"<cr>

" --------------------------------------------------------------------

lua << EoF
    function map(mode, lhs, rhs, opts)
        local options = { noremap = true }
        if opts then
            options = vim.tbl_extend("force", options, opts)
        end
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end

        -- To have an equivalent to the original mappings;
      map("n", 'K', "<nop>", { silent = true })
      map("n", 'K"', "K", { silent = true })
   -- map("n", "M~", "M", { silent = true })
   -- map("n", "Q~", "Q", { silent = true })
   -- map("n", "U~", "U", { silent = true })
   -- map("n", "V~", "V", { silent = true })

        -- Formerly ｢nmap Kb :call InsertBillingElem()<cr>｣.
    map("n", "Kb.", ":call InsertBillingElem()<cr>")

        --[[ To help match code snippet ids, where ε (Alt-lge) prefix,
        ⦃ID: εgram⦄ designates the ID. Formerly, ｢:nmap gW
        /ID:<space>ε\.\?｣ (weird, why?)]]--
   -- map("n", "gW", "/ID: ε")

EoF

nmap gW /ID:<space>\.\?

" --------------------------------------------------------------------
" ｢K｣ mappings.

nmap Kb :call InsertBillingElem()<cr>

    " Change to "- -⋯" my old style "# -⋯" text separator lines.
nmap Kc :%s/^\(\s*\)\# -/\1- -/gc<cr>

"nmap Kd :e /opt/gdoc<cr>
nmap Kd :e /shome/lucs/gdoc<cr>

    " Open this file, which lists file names, one per line, for easy
    " opening with ｢gf｣ (built-in) or ｢gm｣ (defined here elsewhere).
nmap Kf :e $HOME/.freq<cr>
nmap Kg :exec ':e ' . g:user_home_dir . '/.freqg'<cr>
nmap Kk :exec ':e ' . '/mnt/hKpop/opt/prj/'<cr>
nmap Kl :exec ':e ' . g:user_home_dir . '/.llog'<cr>

nmap Km :call FormatManPage()<cr>

    " Open file browser in …<~lucs/prj/>.
nmap Kp :exec ':e ' . g:user_home_dir . '/prj/'<cr>

    " Change ｢⋯｣ surrounders to ⟨⋯⟩.
nmap Kr :.,$s/｢\(.\{-}\)｣/⟨\1⟩/gc<cr>

    " Replace old by new timestamp indicator.
    " ⌚1 U-231a
    " ⌘21 U-2318
nmap Kt :%s,[\u231a\u2318],☰,gc<cr>

    " Open my main Vim config file.
nmap Kz :exec ':e ' . g:nvim_lucs_pack . '/after/plugin/lucs.vim'<cr>

" --------------------------------------------------------------------
" Replace a Man page with so
func! FormatManPage ()
endfunc

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
        normal "bP
    elseif a:where == 'o'
        normal "bp
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
" Given ⦃g:prj_nick = 'vch'⦄, look for lines that start like ⦃vchf…⦄
" (note the appended 'f') and insert a block before it, like
" ｢vchf!0'043- ☰2019l.Dec02.Mon.09:44.06｣

func! InsertBillingElem ()
    if ! exists('g:prj_nick')
        echo "Set g:prj_nick to use InsertBillingElem()"
        return
    endif

   " set lazyredraw
    call SaveWinView()
    normal gg
    let l:last_elem = search('^' . g:prj_nick . 'f')
    if l:last_elem != 0
            " Move to found matching line and copy it
        exec 'normal ' . l:last_elem . 'G'
        let l:saved_x = getreg("x")
        normal "xyy
        let l:saved_b = getreg("b")
        let l:num = matchstr(@x, '\d\d\+')
        let l:num += 1
        let @b = CalcTimestamp(0)
            " Fabricate the new line.
        let @b = printf("%sf-0'%03d- %s", g:prj_nick, l:num, @b)
       " echo @b
        let @x = '- ' . repeat('-', 68)
       " echo @x
        normal kk
        put x
        put b
        call setreg('x', l:saved_x)
        call setreg('b', l:saved_b)
        normal o
        normal zzk2f-l
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

    normal {jV}/.kd
        " Restore saved search pattern.
    let @/ = l:savedSearch
endfunc

" --------------------------------------------------------------------
" Take a string like ｢foo=$bar/noy｣ and have it evaluate so that the
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

    " Especially don't want ｢q｣ to quit Vim when I'm reading a file
    " that has ｢set ft=man｣. See
    " ‥<vim.app/share/vim/vim80/ftplugin/man.vim>.
let no_man_maps = 1

nnoremap __ :e ~/⋯*<cr>
nnoremap _. :e ./⋯*<cr>
nnoremap _t :e ./…*<cr>
nnoremap _l :e ./⋯*<cr>

" --------------------------------------------------------------------
nmap gb :call _OpenFileInBrowser()<cr>
func! _OpenFileInBrowser ()
    let l:FoD = _GetFileOrDirUnderCursor(0)
        " FIXME Hardcoded for kpop.
    let l:fChromeExe = '/opt/google/chrome/chrome'
    let l:cmd = "system('" . l:fChromeExe . " " . l:FoD . " 2>/dev/null &')"
    exec ':call ' . l:cmd
endfunc

" --------------------------------------------------------------------
" If ｢:set textwidth｣ is not equal to 70, set it to 70, else set it to
" 70 (minus 4) plus however far is the first character on the line
" where the cursor is.

nmap gp :call _ReTextWidth()<cr>
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

" I start by extracting all ｢ʈ｣ or ｢‼〈⋯〉｣ lines from a source file.
" and construct a temporary file in which I write something like:
"
"    /opt/prj/l/vim/_l_vim.memo
"       6   keys : char
"      95   ⟦pv⟧
"     217   plugin install vim8
"     237   ´install ´plugin ´extplugin
"       ⋯   ⋯

    " Why did this use to have <C-U> (page up)?
"nmap <f8> :<C-U>call _ProgFunc()<cr>

nmap <c-f8> :call _ProgFunc(
  \ 'if $line ~~ /^ [$<indentl-level> = \s*] ' .
  \ '$<entry> = [[sub\|method\|class\|grammar\|multi] ｢ ｣ .* ] / {'
  \ )<cr>

nmap <f8>   :call _ProgFunc(
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
    normal "xyy
    let l:num = matchstr(@x, '\d\+')
    normal gg"xyy
    let l:file = matchstr(@x, '[^\n]\+')
    call setreg('x', l:saved_x)
    bd
    exec "edit " . l:file
    exec "normal " . l:num . "Gzt"
    call setreg('', l:saved_)
endfunc

" --------------------------------------------------------------------
" In normal mode, surround visually selected text by typing ｢S｣
" followed by indicated character. Insert boilerplate, place cursor
" for insertion. ☰2023-03-21.Tue FIXME The <F2> stuff? Not sure what
" it's about and how it's supposed to work. Also unsure about what the
" second let`s are about, ⦃surround_9128⦄.

    " a : (fd) Application or <program> name
let surround_97     = "◆<\r>"
noremap  <F2>◆        i◆<><esc>i
inoremap <F2>◆         ◆<><esc>i

    " c : (c1) Choice
let surround_99     = "❲\r❳"
let surround_9128   = "❲\r❳"
noremap  <F2>❲        i❲∣❳<esc>i
noremap  <F2><space>❲ i❲  ∣  ❳<esc>4hi
inoremap <F2>❲         ❲∣❳<esc>i
inoremap <F2><space>❲  ❲  ∣  ❳<esc>4hi

    " d : Sample code ⌊%h2<s>⌉
let surround_100    = "⌊\r⌉"
noremap  <F2>⌊        i⌊⌉<esc>i
inoremap <F2>⌊         ⌊⌉<esc>i

"let surround_100 = "❬❭\r"
"inoremap <F2>❬   ❬❭<esc>i

    " e, ⦃ : (e1) Example value
let surround_101    = "⦃\r⦄"
let surround_69     = "⦃ \r ⦄"
let surround_10627  = "⦃\r⦄"
let surround_10628  = "⦃ \r ⦄"
noremap  <F2>⦃        i⦃⦄<esc>i
noremap  <F2><space>⦃ i⦃  ⦄<esc>hi
inoremap <F2>⦃         ⦃⦄<esc>i
inoremap <F2><space>⦃  ⦃  ⦄<esc>hi

    " f : (fd) File or directory
let surround_102    = "…<\r>"
let surround_8229   = "…<\r>"
noremap  <F2>…        i…<><esc>i
inoremap <F2>…         …<><esc>i

    " o :  ᚜ban-cu1᚛ My operator notation.
    "      ᚜lp/bazfoo/s᚛ My password notation.
let surround_111    = "᚜\r᚛"
noremap  <F2>᚜        i᚜᚛<esc>i
inoremap <F2>᚜         ᚜᚛<esc>i

    " q : (q1) Quote, generic
let surround_113    = "｢\r｣"
let surround_81     = "｢ \r ｣"
let surround_65378  = "｢\r｣"
let surround_65379  = "｢ \r ｣"
noremap  <F2>｢        i｢｣<esc>i
noremap  <F2><space>｢ i｢  ｣<esc>hi
inoremap <F2>｢         ｢｣<esc>i
inoremap <F2><space>｢  ｢  ｣<esc>hi

    " r : (r1) Reftag
let surround_114    = "⟦\r⟧"
let surround_82     = "⟦ \r ⟧"
let surround_10214  = "⟦\r⟧"
let surround_10215  = "⟦ \r ⟧"
noremap  <F2>⟦        i⟦⟧<esc>i
noremap  <F2><space>⟦ i⟦  ⟧<esc>hi
inoremap <F2>⟦         ⟦⟧<esc>i
inoremap <F2><space>⟦  ⟦  ⟧<esc>hi

    " s :
let surround_115    = "«\r»"
noremap  <F2>«        i«»<esc>i
inoremap <F2>«         «»<esc>i

    " t : ⟨Str⟩ A type
let surround_116    = "⟨\r⟩"
noremap  <F2>⟨        i⟨⟩<esc>i
inoremap <F2>⟨         ⟨⟩<esc>i

    " u : (ur) URL
let surround_117    = "ū<\r>"
noremap  <F2>ū        iū<><esc>i
inoremap <F2>ū         ū<><esc>i

    " z : Light quoting (used to be: Comment in code)
let surround_122    = "‹\r›"
noremap  <F2>‹        i‹›<esc>i
inoremap <F2>‹         ‹›<esc>i

    " ☰2021-12-06 Disactivated, as it interferes with the ｢surround｣
    " plugin's tag surrounding, ⦃abc⦄ becoming ｢<foo>abc</foo>｣. To
    " have ⦃abc⦄ become ｢<abc>｣, use ｢>｣ as the surrounding char.
"    " < : <>
"let surround_60     = "<\r>"
"let surround_62     = "< \r >"
"noremap  <F2><        i<><esc>i
"noremap  <F2><space>< i<  ><esc>hi
"inoremap <F2><         <><esc>i
"inoremap <F2><space><  <  ><esc>hi

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
nmap ,yp :let @" = expand("%:p")<cr>

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
            exec "normal Go‥<\$PRJ_DIR/" . l:dSnip . "/" . l:fTs . ">\r\<esc>"
            exec "saveas " . l:fSpec
        catch
            echo "Caught" v:exception
        endtry
    endif
endfunc

" --------------------------------------------------------------------
nmap :: :w<cr>
nmap :' :w<bar>bd<cr>
nmap :/ :bd<cr>

nmap g9 :setl noma!<cr>

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
    normal mb
    execute 'let char = "\u'.a:cp.'"'
    execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
    normal `b
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
nmap ,cx <Plug>XmlStyleOneLine

" --------------------------------------------------------------------
" Toggle ｢/*⋯*/｣ style one line comments.
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
nmap ,cc <Plug>CComment

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
    normal ll
endfunc

" --------------------------------------------------------------------
" Line breaks in some other places may cause spurious moving right
" of cursor (?!) (☰2023-06-18.Sun Not sure what that even means)

nnoremap <silent><Plug>XresPfx :call
  \ PfxLine('!')<cr>:call repeat#set("\<Plug>XresPfx")<cr>
nmap ,c! <Plug>XresPfx

nnoremap <silent><Plug>TextPfx :call
  \ PfxLine('-')<cr>:call repeat#set("\<Plug>TextPfx")<cr>
nmap ,c- <Plug>TextPfx

nnoremap <silent><Plug>PerlPfx :call
  \ PfxLine('#')<cr>:call repeat#set("\<Plug>PerlPfx")<cr>
nmap ,c# <Plug>PerlPfx

nnoremap <silent><Plug>VimPfx :call
  \ PfxLine('"')<cr>:call repeat#set("\<Plug>VimPfx")<cr>
nmap ,c" <Plug>VimPfx

nnoremap <silent><Plug>TexPfx :call
  \ PfxLine('%')<cr>:call repeat#set("\<Plug>TexPfx")<cr>
nmap ,c% <Plug>TexPfx

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
nmap <f6> :Bs<cr>
nmap <f5> :Bs2<cr>

" --------------------------------------------------------------------
" To make sure ftdetect are reread.
"
    " Clear autocommands.
"autocmd!
filetype on
"filetype off
filetype plugin on

" --------------------------------------------------------------------
func! LooksLikePerl6 ()
    if getline(1) =~# 'v6'
        set filetype=perl6
    endif
endfunc

au! bufRead *.t call LooksLikePerl6()
"au! BufNewFile,BufRead *.p6 setf perl6

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

    " The default is '│' (U-2502), which urxvt appears not to accept
    " in its "cutchars", so changing it here allows capturing text
    " with the mouse without grabbing the vertical window separator
    " character.
set fillchars+=vert:\|

set hidden
set history=1000
set hlsearch
set incsearch
set laststatus=2
set list listchars=tab:•․
set modeline
set modelines=3
set mouse=a
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

nmap ,<f3> :setl nolist<cr>
nmap ,<f4> :setl list listchars=tab:\ \ <cr>
nmap ,<f5> :setl list listchars=tab:→․,trail:·<cr>

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

    " Toggle between ｢paste｣ and ｢nopaste｣.
nmap <silent> <f3> :call _TogglePaste()<cr>
func! _TogglePaste ()
    if &paste == 0
        set paste
    else
        set nopaste
    endif
    call BuildUpStatusLine()
endfunc

nmap <silent> <f4> :call _ToggleScrollOffset()<cr>
func! _ToggleScrollOffset ()
    if &scrolloff == 0
        set scrolloff=100
    elseif &scrolloff == 100
        set scrolloff=0
    endif
    call BuildUpStatusLine()
    normal jk
endfunc

    " Move between buffers.
nmap H <Nop>
nmap L <Nop>
nmap HH :bp<cr>
nnoremap Hh H
nmap LL :bn<cr>
nnoremap Ll L

    " To have an equivalent to the original ｢J｣ mapping.
nnoremap J. J

    " To trap the ISO_Left_Tab xterm (I guess) mapping.
" nmap <esc>[Z <s-tab>

    " Force UTF-8 encoding.
    " 2021-06-25 Don't waste 'gt' for a too infrequent operation.
"nmap gt8 :set fenc=utf-8<cr>

    " Keep highlighting when shifting text in or out.
vnoremap < <gv
vnoremap > >gv

" --------------------------------------------------------------------
    " Allow toggling search highlight, but turn it back on when a
    " search is done.
nmap <silent> <c-n> :set hls!<cr>
"inoremap <silent> <c-n> <esc>:set hls!<cr>a<c-n>
"vnoremap <silent> <c-n> <esc>:set hls!<cr>gv<c-n>
nnoremap <silent> n :set hls<cr>n
nnoremap <silent> N :set hls<cr>N
nnoremap / :set hls<cr>/
nnoremap ? :set hls<cr>?
nnoremap <silent> * :set hls<cr>*
nnoremap <silent> g* :set hls<cr>g*

nmap <c-h> zh
nmap <c-l> zl

    " Prompt for clearing lines of trailing blanks.
func! _ClearTrailingBlanks ()
    try
            " Spell out: space, tab, U-00A0.
        %s/[ \t ]\+$//c
    catch
        echo "No trailing blanks found."
    endtry
    nohl
endfunc
nmap <silent> gs :call _ClearTrailingBlanks()<cr>

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
nmap ,gm :call _LoadFileOrDir(1, 0)<cr>
nmap ,gM :call _LoadFileOrDir(0, 0)<cr>
nmap ,gu :call _LoadFileOrDir(1, 1)<cr>
nmap ,gU :call _LoadFileOrDir(0, 1)<cr>

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
        exec "normal :new\<cr>"
        exec "normal \<c-w>p\<c-w>c"
        normal "bP
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
nmap <silent> gh :call _AllCodeSnips()<cr>

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
        normal n
            " Insert a timestamp, a couple of newlines, come back and
            " insert the project ID prefix, and go to insert mode.
        call _InsertTimestamp(0, 'i')
       " call _InsertTimestamp('n', 0, 0)
        exec "normal! a\<cr>\<cr>"
        exec "normal kkA .´\<esc>zz"
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
nmap ,aa :call _AppendLogEntry()<cr>
nmap ,ar :call _AppendLogEntry()<cr>
nmap ,as :call _AppendLogEntry()<cr>´
nmap ,ad :call _AppendLogEntry()<cr>-
nmap ,an :call _AppendLogEntry()<cr>.

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
nmap ,tl :call _AcuTags("l")<cr>
nmap ,tf :call _AcuTags("f")<cr>

" --------------------------------------------------------------------
" Display ｢let｣s sorted in a new file.

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
        my $x = "asdf";
        for my $key (@sorted_keys) {
           # VIM::DoCommand(":let \@a = '$x'");
            $key =~ s/'/''/g;   # ' For syntax highlighting.
            VIM::DoCommand(":let \@a = '" . $key . "'");
            VIM::DoCommand(":put a");
        }
       # VIM::DoCommand(":let \@a = l:a_saved");
EoP
   " echo "Press a key to continue..."
    normal gg
        " Get rid of spurious first line, which is blank.
    normal dd
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
        my $x = "asdf";
        for my $map (@sorted_maps) {
           # VIM::DoCommand(":let \@a = '$x'");
            $map =~ s/'/''/g;   # ' For syntax highlighting.
            VIM::DoCommand(":let \@a = '" . $map . "'");
            VIM::DoCommand(":put a");
        }
       # VIM::DoCommand(":let \@a = l:a_saved");
EoP
   " echo "Press a key to continue..."
    normal gg
        " Get rid of spurious first line, which is blank.
    normal dd
        " We don't care about the fact that this is a non-saved
        " file.
    set nomodified
endfunc

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

func! Hi_off ()
    hi clear User1
    hi clear User2
    hi clear User3
    hi clear User4
    hi clear User5
    hi clear User6
    hi clear User7
    hi clear User8
    hi clear User9
    syntax off
endfunc

func! Hi_onn ()
    syntax enable
    hi statusline   cterm=reverse guifg=green  guibg=white
    hi statuslineNC cterm=reverse guifg=gray   guibg=white
    hi User1        cterm=reverse guifg=yellow guibg=black
    hi User2        cterm=reverse guifg=red    guibg=black
    hi User3        cterm=reverse guifg=green  guibg=white
    hi User4        cterm=reverse guifg=white  guibg=black
endfunc

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

nmap <silent> <f7> :call _ToggleSyntaxHi()<cr>
func! _ToggleSyntaxHi ()
    if exists("g:syntax_on")
        call Hi_off()
    else
        call Hi_onn()
    endif
endfunc

    " Initialize.
call Hi_onn()

"set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
"set guicursor=n-v-c-sm:ver25,i-ci-ve:ver25,r-cr-o:hor20
"hhset guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
"hi Cursor guifg=black guibg=green gui=reverse
"set guicursor=a:block-blinkon100-Cursor/Cursor

