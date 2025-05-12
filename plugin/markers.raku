#!/usr/bin/env raku

# --------------------------------------------------------------------
#`(

This program is maintained at
…</home/lucs/prj/t/nvim/plugin.vim-lucs/vim-lucs.git/plugin/markers.raku>.

It prints to STDOUT data that need to be placed in the correct file.

Naming:

    kombo   : key combination, ⦃ac⦄, ⦃lga⦄, ⦃c0⦄.

Unused:

    Ɖ   Do something        | Ɖ Tag "crontab ..." messages.
    Ɵ   Observe something   | Ɵ The messages are tagged.
    ⁋   Section mark (reversed pilcrow)
    ★   Star, dark
    ☆   Star, light
    ⁇   Troubleshooting     | ⁇<Why does flump fail?>

)

# --------------------------------------------------------------------
sub f { $^a }

my $raw-data = q:to/EoD/;
    # --------------------------------------------------------------------
    : a b c: Wysiwyg

    a0 ∅  Empty set
    ab •  Bullet
    ac ✓  Check mark
    ad ·  Middle dot
    ae €  Euro
    ag °  Degré               | 12°C
    ai ∞  Infinity
    ak ¦  Broken bar
    a! ¡  ¡Exclamation!
    an    Non-breaking space
    as §  Section sign        | ▸ rak §word
    at ™  Trademark

    ba ´  Acute accent        | ´markers
    bt ¨  Tréma
    bm ¯  Macron
    bc ⌃  Ctrl-char           | ⌃a" : Ctrl-A, double-quote

    cc ␍  Carr. Return symb.
    ce ⎆  Enter symb.
    ch ␉  Horiz. Tab. symb.
    cl ␊  Line Feed symb.
    cn ␤  Newline symb.       | "Hello world.␤"
    cr ⏎  Return symb.
    cs ␛  Escape symb.
    cv ␋  Vert. Tab. symb.

    # --------------------------------------------------------------------
    : x: Semantic

    x0 ṅ  A number            | ṅj
    xa ◆  Application name    | ◆<svn>
    xA ◈  Application name    | ◈<⦃Xorg-sh⦄> (actually …<⌊/usr/bin/Xorg⌉>)
    xd ☰  Date, time mark     | ☰2021-11-20
    xe ✎  Edit                | ✎…<.zshrc>
    xl ◇  Library nickname    | ◇mcrypt
    xo ∖  Continuation line   | This line continues on the ∖
    xs θ  Santé               | θ Dr.Rhéaume
    xt ʈ  ToC entry           | ʈ Summary
    xu ů  User                | ůlucs
    xv ␣  Espace visible      | Par␣exemple
    xw ⧺  Who's who           | lucs⧺
    xx ⌘  Compose key         | ⌘xx

    # --------------------------------------------------------------------
    : e t: Ellipses, tabs

        # ☰2023-08-11.Fri My current font unfortunately displays the
        # text one (et) in the middle of the line instead of at the
        # bottom.
    el ⋯  Ellipsis, logical   | ‹e42ac0d⋯›
    et …  Ellipsis, text      | Hmm…
    tt →  Visible tab
    t0 ┴  Center
    t1 └  Left
    t2 ┘  Right

    # --------------------------------------------------------------------
    : w: Prefixes to wrapped stuff

    wf …  File or dir         | …<⋯/foo> …<⋯/bar/>
    wj ∿  /opt/prj/⋯          | ∿<t/raku>
    wm ɱ  ∿<⋯/⋯.memo>         | ɱ<t/raku> : …<⋯/t/raku.memo>
    wn Ɲ  /opt/gdoc file      | Ɲ<make.md>
    wp Ƭ  ∿</a/admin/tools/⋯> | Ƭ<newprj>
    wu ū  URL                 | ū<http://example.com/foo>

    # --------------------------------------------------------------------
    : l: Lettres grecques

    lga α  alpha
    lgb β  beta
    lgc γ  gamma
    lgd δ  delta
    lgD Δ  delta
    lge ε  epsillon
    lgh θ  theta    | Préfixe pour tags, ⦃θvch⦄, ⦃θsan⦄. (?)
    lgH Θ  Theta
    lgk κ  kappa    | LaTeX pkg. prefix, ⦃κlayouts⦄
    lgK Κ  Kappa    | LaTeX pkg. manual prefix, ⦃Κlayman⦄
    lgl λ  lamda
    lgm μ  mu
    lgo ω  omega
    lgO Ω  Omega
    lgpi  π  pi
    lgPi  Π  Pi
    lgpsi ψ psi
    lgPsi Ψ Psi
    lgr ρ  rho
    lgS Σ  Sigma
    lgt τ  tau      | Entry inscription moment, ⦃τ2024-07-22⦄.
    lgT Τ  Tau      | Entry redaction   moment, ⦃Τ2024-09-03⦄.

    # --------------------------------------------------------------------
    : o: Opérateurs

    o1  ∀
    o2  ∃
    o3  ∄
    o4  ∈
    o5  ∉
    o6  ∋
    o7  ∌
    o8  ∧
    o9  ∨
    oa  ∩
    ob  ∪
    oc  ¬
    od  ≠
    oe  ≡
    of  ⊲
    og  ⊳
    oh  ≺
    oi  ≻
    oj  ⋖
    ok  ⋗

    # --------------------------------------------------------------------
    : g: GUI

    gm  ∕  Menu separator      | ◆gnum∕Insert∕Name—Ctrl-F3
    gs  —  Shortcut separator  | ◆gnum∕Insert∕Name—Ctrl-F3
    gb  ▭  Button
    gd  ⇣  Select from Dropdown | ⇣Country∕⦃Canada⦄
    gc1 ☒  Checkbox: checked
    gc0 ☐  Checkbox: unchecked
    gr1 ◉  Radio button: selected
    gr0 ○  Radio button: unselected

    # --------------------------------------------------------------------
    : G: Git

    Gb  β  Git branch        | git checkout βranch
    Gr  ŕ  Git remote name   | git remote add ŕemname ⋯
    Gs  ś  Git SHA1          | git ⋯ śha1 ⋯
    Gt  ť  Git treeish       | git ls-tree ťreeish
    Gc  ●  Git commit        | Used in my documentation.

    # --------------------------------------------------------------------
    : m: Musique

    m0  ♮  Bécarre
    mb  ♭  Bémol
    mc  ♪  Croche
    md  ♯  Dièse
    mn  ♩  Noire

    # --------------------------------------------------------------------
    : r: Raku

    r2 ƻ To         | sub abrevƻword ⋯
    ra Λ And        | sub is-bigΛred ⋯
    rd ď Dir.       | my ďTmp
    rf ƒ File       | my ƒTmp
    rh ͱ Hash map   | my %search-forͱchoice
    ri ᵢ Index      | for ^@thing -> ᵢthing
    rr ʀ Regex      | my regex ʀComment ⋯
    rt ť Text       | my ťChoices;

    # --------------------------------------------------------------------
    : p P: Prompts, returns

    p1 ▸  Shell command       | ▸ ls
    p2 ◂  Shell return        | ◁ 2 + 2 is 4␤
    p3 ▷  Lang./REPL command  | ▷ say "2 + 2 is ", 2 + 2;
    p4 ◁  Lang./REPL return   | ◂ file1 file2
    p5 ►  Arbitrary command   | ► VIM::Msg('Allo')
    p6 ◄  Arbitrary return    | ◄ Allo
    p7 ▹  Whatever
    p8 ◃
    p9 ▶
    pa ◀
    po ∷  Vim ‹ex› command    | ∷%s/baz/

    P1 ▴
    P2 ▾
    P3 △
    P4 ▽
    P7 ▵
    P8 ▿
    P9 ▲
    Pa ▼

    # --------------------------------------------------------------------
    : s: Surrounders

    sc0 ∣  Choices              | ❲a∣b∣c❳
    sc1 ❲
    sc2 ❳
    sd1 ⌊   Conseq. of example  | "Observe that ⦃21⦄*2 is ⌊42⌉."
    sd2 ⌉
    se1 ⦃   Example value       | Insert image, ⦃<img src=⋯>⦄
    se2 ⦄
    sg1 ⟪   GUI invoc.          | ⟪I⇣tools:Bezier ⋯ ⇣mode:⦃…regular…⦄⟫
    sg2 ⟫
    sk1 ｢   Literal Raku quote  | ｢⋯｣
    sk2 ｣
    so1 ᚜   Opérateurs, clés    | ᚜ban-col᚛:‹!:›. Ctrl, Shift:
    so2 ᚛                       | ᚜c-x᚛, ᚜s-x᚛. ᚜esc᚛, ᚜tab᚛, ᚜ret᚛, ᚜ent᚛
    sr0 ρ   Reftag              | ⟦ρs05 L-42⟧, ⟦ρ⋯ p.23`36⟧
    sr1 ⟦
    sr2 ⟧
    ss1 «   French guillemets   | « La mémoire »
    ss2 »
    st1 ⟨   A kind of thing     | factor(⟨Int⟩)
    st2 ⟩
    sw1 ❬   For keyed wrappers  | Open the data file …❬~/.zshrc❭.
    sw2 ❭
    sz1 ‹   All-purpose quote   | The code is ‹my $x = 42›.
    sz2 ›

    # --------------------------------------------------------------------
    : ': Small caps

    'a ᴀ
    'b ʙ
    'c ᴄ
    'd ᴅ
    'e ᴇ
    'f ꜰ
    'g ɢ
    'h ʜ
    'i ɪ
    'j ᴊ
    'k ᴋ
    'l ʟ
    'm ᴍ
    'n ɴ
    'o ᴏ
    'p ᴘ
   # 'q  No small cap for this letter.
    'r ʀ
    's ꜱ
    't ᴛ
    'u ᴜ
    'v ᴠ
    'w ᴡ
   # 'x  No small cap for this letter.
    'y ʏ
    'z ᴢ
EoD

# --------------------------------------------------------------------
my $xcompose-syms = q:to/EoS/;
    ´ acute
    ' apostrophe
    ^ asciicircum
    ~ asciiTilde
    * asterisk
    | bar
    ¸ cedilla
    : colon
    , comma
    ¨ diaeresis
    = equal
    ! exclam
    ` grave
    > greater
    < less
    - minus
    ( parenleft
    ) parenright
    . period
    + plus
    ? question
    " quotedbl
    / slash
    _ underscore
    EoS

my %xcompose-syms;
for $xcompose-syms.comb(/ \N+ /) -> $line {
    $line ~~ /^ (.) \s+ (.*) /;
    %xcompose-syms{~$0} = ~$1;
}

# --------------------------------------------------------------------
class Kombo {

        # ⦃p1⦄ Keys.
    has $.keys;

        # ⦃▸⦄ Grapheme.
    has $.phem;

        # ⦃Shell command⦄ Description.
    has $.desc;

        # ⦃▸ ls⦄ Usage example.
    has $.xmpl;
}

# --------------------------------------------------------------------
class Section {

    # A Section of raw data has a title and an array of Kombo. Here is
    # an example of a typical one:
    #
    #   : Choix
    #   c0 ∣ Choice | ❲a∣b∣c❳
    #   c1 ❲
    #   c2 ❳

    has $.title;
    has Kombo @.kombos;
}

# --------------------------------------------------------------------
# Parse the raw data into an array of Section.

my @g_sections = do {

    my Section @sections;

    my %seen-kombo-keys;

    my $curr-section;

    for $raw-data.comb(/ \N+ /) -> $line is copy {

            # Trim line and skip comments.
        $line .= trim;
        next if $line.substr(0, 1) eq '#';

            # ‹: ⟨Section title⟩›
            # ⦃: a b: Wysiwyg⦄
        if $line ~~ /^ ':' \s+ (.*) / {
            @sections.push: $curr-section if $curr-section;
            $curr-section = Section.new: title => ~$0;
        }
        else {
                # A line of Kombo data looks like:
                #   ‹⟨keys⟩ ⟨phem⟩ ⟨desc⟩        | ⟨xmpl⟩›
                #   ⦃p1     ▸      Shell command | ▸ ls⦄
            my ($keys, $phem, $desc, $xmpl) = ($line ~~ /^
                    (\S+)
                    ' '+
                    (<-[\ ]>)
                    \s*
                    (<-[|]>*)
                    \|? \s* (.*)
            /)».Str;
            $desc .= trim;
            $xmpl .= trim;
            die "Keys '$keys' already defined" if $keys ~~ %seen-kombo-keys;
            $curr-section.kombos.push: Kombo.new: :$keys, :$phem, :$desc, :$xmpl;
        }
    }
    @sections.push: $curr-section if $curr-section;

    @sections;
};

# --------------------------------------------------------------------
multi sub MAIN {
    say Q:to/EoH/
        Typical usage by lucs⧺:
            $prog xco  > ~lucs/.XCompose
            $prog vim  > ~lucs/prj/t/nvim/plugin.vim-lucs/vim-lucs.git/plugin/markers.vim
            $prog memo > /shome/lucs/gdoc/markers.memo
            $prog text > /shome/lucs/gdoc/markers.text
            $prog list > /shome/lucs/gdoc/markers.list
        EoH
    ;
   # abiword <($prog text) # Then save as …❬/shome/lucs/gdoc/markers.abw❭.
   # $prog tex : For LaTeX, needs work.
}

# --------------------------------------------------------------------
multi sub MAIN ('xco') {
    my $xco = Q:f:to/EoT/
            # Import the default Compose file for the locale.
        include "%L"

        &f( '# ' ~ '-' x 68 )
        # Generated by …<&f( $?FILE )>

        EoT
    ;

    for @g_sections -> $section {
        $xco ~= "# {$section.title}\n";
        for $section.kombos -> $kombo {
            $xco ~= sprintf qq|<Multi_key> %s : "%s"\n|,
                $kombo.keys.comb.map({
                    "<{%xcompose-syms{$_} // $_}>"
                }).join(' '),
                $kombo.phem,
            ;
        }
        $xco ~= "\n";
    }

    print $xco;
}

# --------------------------------------------------------------------
multi sub MAIN ('vim') {
    my $vim = Q:f:to/EoT/
        &f( '" ' ~ '-' x 68 )
        " Unicode markers, same mappings as ~lucs/.XCompose.
        " Generated by …<&f( $?FILE )>

        EoT
    ;

    for @g_sections -> $section {
        $vim ~= qq|" {$section.title}\n|;
        for $section.kombos -> $kombo {

                # Two character kombos can use digraph, but
                # longer ones are mapped with a <C-f>prefix.
            if ($kombo.keys.chars == 2) {
                $vim ~= sprintf qq|digraph %3s %5d " %s\n|,
                    $kombo.keys,
                    $kombo.phem.ord,
                    $kombo.phem,
                ;
            }
            else {
                $vim ~= sprintf "imap <C-f>%s %s\n",
                    $kombo.keys,
                    $kombo.phem,
            }
        }
        $vim ~= "\n";
    }

    print $vim;
}

# --------------------------------------------------------------------
multi sub MAIN ('memo') {
    my $memo;
    $memo ~= '- ' ~ '-' x 68 ~ "\n";
    $memo ~= "- Generated by {$?FILE}\n\n";
    for @g_sections -> $section {
        $memo ~= '- ' ~ '-' x 68;
        $memo ~= "\n{$section.title}\n\n";

            # Obtain longest kombo keys and desc.
        my $longest-keys = 0;
        my $longest-desc = 0;
        for $section.kombos -> $kombo {
            my $len-keys = $kombo.keys.chars;
            $len-keys > $longest-keys and $longest-keys = $len-keys;
            my $len-desc = $kombo.desc.trim.chars;
            $len-desc > $longest-desc and $longest-desc = $len-desc;
        }

        for $section.kombos -> $kombo {
            $memo ~= sprintf qq| %-{$longest-keys}s %s  %-{$longest-desc}s : %s\n|,
                $kombo.keys,
                $kombo.phem,
                $kombo.desc.trim,
                $kombo.xmpl,
            ;
        }
        $memo ~= "\n";
    }

    print $memo;
}

# --------------------------------------------------------------------
multi sub MAIN ('text') {
    my $text;
    for @g_sections -> $section {
            # Obtain the max widths of the elements.
        my $max_len-keys = 0;
        my $max_len-desc = 0;
        my $max_len-xmpl = 0;
        for $section.kombos -> $kombo {
            $max_len-keys = $_ if $max_len-keys < $_ given $kombo.keys.chars;
            $max_len-desc = $_ if $max_len-desc < $_ given $kombo.desc.chars;
            $max_len-xmpl = $_ if $max_len-xmpl < $_ given $kombo.xmpl.chars;
        }

        $text ~= "            {$section.title}\n";

        for $section.kombos -> $kombo {
            $text ~= sprintf
                "%5s %5x   %{$max_len-keys}s   " ~
                 "%s   %-{$max_len-desc}s : %-{$max_len-xmpl}s\n",
                $kombo.phem.ord,
                $kombo.phem.ord,
                $kombo.keys,
                $kombo.phem,
                $kombo.desc,
                $kombo.xmpl,
            ;
        }
        $text ~= "\n";
    }

    print $text;
}

# --------------------------------------------------------------------
#`{
    Prints in Unicode order a list of all the kombo`s, each one like:

        ⟨unic⟩ ⟨keys⟩ ⟨phem⟩ ⟨desc⟩            ⟨xmpl⟩
        ⦃2630   xT     ☰      Date, time mark : ☰2021-11-20

}

multi sub MAIN ('list') {
    my @kombos;
    my $maxW-keys = 0;
    my $maxW-desc = 0;
    for @g_sections -> $section {
            # Obtain the max widths of the keys and descriptions.
        for $section.kombos -> $k {
            $maxW-keys = $_ if $maxW-keys < $_ given $k.keys.chars;
            $maxW-desc = $_ if $maxW-desc < $_ given $k.desc.chars;
            @kombos.push: $k;
        }
    }

    my $list = '';
    for @kombos.sort({$^a.phem.ord <=> $^b.phem.ord}) -> $kombo {
        $list ~= sprintf
            "%5x %{$maxW-keys}s %s %-{$maxW-desc}s : %-s\n",
            $kombo.phem.ord,
            $kombo.keys,
            $kombo.phem,
            $kombo.desc,
            $kombo.xmpl,
        ;
    }
    say "Each line: ⟨unic⟩ ⟨keys⟩ ⟨phem⟩ ⟨desc⟩ : ⟨xmpl⟩\n";
    print "$list\n";
}

