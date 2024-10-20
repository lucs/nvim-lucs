#!/usr/bin/env raku

# This program is maintained in …<~lucs/src/markers.raku>.

# --------------------------------------------------------------------
#`(

This program prints to STDOUT data that need to be placed in the
correct file.

The makefile will place the program's output in …<~/gen> and prompt
the user to perform an action to make the new values used.

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
    : a b: Wysiwyg

    a0 ∅  Empty set
    ab •  Bullet
    ac ⌃  Ctrl-char           | ⌃a" : Ctrl-A, double-quote
    ad ·  Middle dot
    ae €  Euro
    ag °  Degré               | 12°C
    ai ∞  Infinity
    a! ¡  ¡Exclamation!
    ak ✓  Check mark
    am ¯  Macron
    an ␤  Newline             | "Hello world.␤"
    ar ⏎  Return
    as §  Section sign        | ▸ rak §word
    aT ™  Trademark
    av ␣  Espace              | Par␣exemple
    bb ¦  Broken bar
    bs    Non-breaking space
    bt ¨  Tréma
        
    # --------------------------------------------------------------------
    : x: Semantic

    x0 ṅ  A number            | ṅj
    xa ◆  Application name    | ◆<svn>
    xA ◈  Application name    | ◈<Xorg-sh> (actually …</usr/bin/Xorg>)
    xc ´  Acutag              | ´markers
    xe ✎  Edit                | ✎…<.zshrc>
    xl ◇  Library nickname    | ◇mcrypt
    xo ∖  Continuation line   | This line continues on the ∖
    xs θ  Santé               | θ Dr.Rhéaume
    xT ☰  Date, time mark     | ☰2021-11-20 
    xt ʈ  ToC entry           | ʈ Summary
    xU ů  User                | ůlucs
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
    lgh θ  theta            | Préfixe pour tags, ⦃θvch⦄, ⦃θsan⦄. (?)
    lgH Θ  Theta
    lgk κ  kappa            | LaTeX pkg. prefix, ⦃κlayouts⦄
    lgK Κ  Kappa            | LaTeX pkg. manual prefix, ⦃Κlayman⦄
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
    lgt τ  tau
    lgT Τ  Tau

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

    sc0 ∣  Choices             | ❲a∣b∣c❳
    sc1 ❲
    sc2 ❳
    sd1 ⌊   Conseq. of example  | "Observe that ⦃21⦄*2 is ⌊42⌉."
    sd2 ⌉
    se1 ⦃   Example value       | Insert image, ⦃<img src=⋯>⦄
    se2 ⦄
    sg1 ⟪   GUI invoc.          | ⟪I⇣tools:Bezier Tool (⇧F6)⇣mode:⦃…regular…⦄⟫
    sg2 ⟫
    sk1 ｢   Literal Raku quote  | ｢⋯｣
    sk2 ｣
    so1 ᚜   Opérateurs          | ᚜ban-col᚛ is ‹!:›.
    so2 ᚛
    sr0 ρ   Reftag              | ⟦ρs05 L-42⟧, ⟦ρ⋯ p.23`36⟧
    sr1 ⟦
    sr2 ⟧
    ss1 «   French guillemets   | « La mémoire »
    ss2 »
    st1 ⟨   Types               | factor(⟨Int⟩)
    st2 ⟩
    sz1 ‹   All-purpose quote   | my $x = 42;  ‹Might want this value.›
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

    # A line of raw Kombo data looks like ⦃p1 ▸ Shell command | ▸ ls⦄.

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

    # A Section of raw data has a name and an array of Kombo. Here is
    # an example of a typical one:
    #
    #   : Choix
    #   c0 ∣ Choice | ❲a∣b∣c❳
    #   c1 ❲
    #   c2 ❳

    has $.name;
    has Kombo @.kombos;
}

# --------------------------------------------------------------------
# Parse the raw data into an array of Section.

my $g_sections = sub {

    my Section @sections;

    my %seen-kombo-keys;

    my $curr-section;

    for $raw-data.comb(/ \N+ /) -> $line is copy {

            # Trim line and skip comments and empty lines.
        $line .= trim;
        next if $line ~~ /^ \s* ['#' | $] /;

        if $line ~~ /^ ':' \s+ (.*) / {
            @sections.push: $curr-section if $curr-section;
            $curr-section = Section.new: name => ~$0;
        }
        else {
            my ($keys, $phem, $desc, $xmpl) = ($line ~~ /^
                    (\S+)
                    <[\ \t]>+   # Unbreakable space won't match here.
                   # (\S+)
                    (<[ \x00A0 \S]>)
                    \s*
                    (<-[|]>*)
                    \|? \s* (.*)
            /)».Str;
            die "Keys '$keys' already defined" if $keys ~~ %seen-kombo-keys;
           # note "<$keys>";
            $curr-section.kombos.push: Kombo.new: :$keys, :$phem, :$desc, :$xmpl;
        }
    }
    @sections.push: $curr-section if $curr-section;

    return @sections;
}();

# --------------------------------------------------------------------
multi sub MAIN {
    say q:to/EoH/
        Invoke with one of these arguments:
            Arg     May want to redirect output here
            ---     --------------------------------
            xco     …<⟨User home dir.⟩/.XCompose>.
            vim     …<⟨User home dir.⟩/⋯
                     .local/share/nvim/site/pack/lucs/opt/nvim-lucs/plugin/markers.vim>.
            memo    markers.memo
            text    (Format the output with ◆<abiword>)
        EoH
    ;
           # tex     For LaTeX, needs work.
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

    for $g_sections.list -> $section {
        $xco ~= "# {$section.name}\n";
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

    for $g_sections.list -> $section {
        $vim ~= qq|" {$section.name}\n|;
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
    for $g_sections.list -> $section {
        $memo ~= '- ' ~ '-' x 68;
        $memo ~= "\n{$section.name}\n\n";

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
    my $text = q:to/EoT/
        File∕
            Page Setup …∕
                Paper Size: Letter ⟨(etc.)⟩

            Margin∕
                Units: inch
                Top/Bottom: 0.35
                Right/Left: 0.5
                Header/Footer: 0.0

        Select all:

            Font: DejaVu Sans Mono, 8pt

            Set these tab values with Format∕Paragraphs∕Tabs:

                Set        Column desc.
                ---        ------------
                0.50 right 0d
                1.00 right 0x
                1.50 right Keys
                1.75 right Prints
                2.00 left  Titre de section
                2.25 left  Desc.
                3.75 left  Exemple

          ┘  ┘  ┘ ┘ └    └             └ 
       ‹→  → →  →  →a, b, e: Wysiwyg›
       ‹183→b7→ad→·→→Middle dot→ asdf›
       ⋯
          ┘    ┘    ┘   ┘   └   └                 └ 
       ‹    →    →    → → → a, b, e: Wysiwyg›
       ‹183 → b7 → ad → ◆ →   → Middle mooow dot → asdf›

    EoT
    ;

    for $g_sections.list -> $section {
        $text ~= "\t\t\t\t\t{$section.name}\n";
        for $section.kombos -> $kombo {
            $text ~= sprintf qq|\t%s\t%x\t%s\t%s\t\t%s\t%s\n|,
           # $text ~= sprintf qq|\t%5s\t%4x\t%s\t%s\t\t%s\t%s\n|,
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
=finish

    Maybe some day I'll produce a LaTeX listing.
multi sub MAIN ('tex') {
    my $tex = Q:f:to/EoT/
        \documentclass{markers}

        &f( '% ' ~ '-' x 68 )
        \begin{document}

        EoT
    ;

    for $g_sections.list -> $section {
        $tex ~= "% {$section.name}\n";
        $tex ~= '\begin{tabular}{ | r | c | r | r | r | r | }' ~ "\n";
        for $section.kombos -> $kombo {
            $tex ~= sprintf qq|%5s & %4x & %s & %s & %s & %s\\\\\n|,
                $kombo.phem.ord,
                $kombo.phem.ord,
                $kombo.keys,
                $kombo.phem,
                $kombo.desc,
                $kombo.xmpl,
            ;
        }
        $tex ~= '\end{tabular}' ~ "\n\n";
    }


    $tex ~= '\end{document}' ~ "\n\n";

    print $tex;
}

