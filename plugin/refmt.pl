#!/usr/bin/env perl

=head1 NAME

    refmt.pl - Reformat stuff.

=head1 SYNOPSIS

    refmt.pl $how $file

=head1 DESCRIPTION

=cut

# --------------------------------------------------------------------
use strict;
use warnings;
use File::Slurper;

# --------------------------------------------------------------------

=pod

Transforms header blocks.

Example:

    "void Foo(const char * x, bool y);"

       void
    Foo (
            const
        char * x,
        bool   y
    );

Example:

    "  void Foo(const char * x, bool y)\n{"

       void
    Foo (
            const
        char * x,
        bool   y
    ) {

Even if there are no arguments or a single argument, they are spread
out:

    "  void Foo(char y)\n{"
    "  void Foo()\n{"

    ...
    Foo (
        char y
    ) {

    Foo (
    ) {

=cut

# --------------------------------------------------------------------
#    "void Foo(...);"
#    "void Foo(...){"

sub fmt_hdr {
    my ($indent, $text) = @_;
    my $has_trailing_nl = $text =~ /\n\z/;
    $text =~ s/[\n\t]/ /g;
    $text =~ s/ *(\*+) */ $1 /g;
    $text =~ s/^\s+//;
    $text =~ s/\s+\z//;
    $text =~ s/\s+/ /g;
    my ($type, $name, $decl, $endd) = $text =~ /
        (.*?) [ ]
        (\S+) [ ]* \(
        ([^)]*) \) [ ]*
        ([;{])
    /x;

   # print
   #     "text <<$text>>\n" .
   #     "type <<$type>>\n" .
   #     "name <<$name>>\n" .
   #     "decl <<$decl>>\n" .
   #     "endd <<$endd>>\n" .
   # q<>;

    return "NO_MATCH\n" unless $endd;

    return
        (q[ ] x ($indent + 4)) . "$type\n" .
        (q[ ] x $indent) . "$name (\n" .
        align_decl($indent + 4, $decl) .
        (q[ ] x $indent) . ")" .
        ($endd eq ";" ? ";" : " {") .
        "\n"
    ;
}

# --------------------------------------------------------------------

=pod

Given for example:

    undo *Undos,
    unsigned *    Nombre    =23,
    const coup   **  Pointeur,
    coup *NouvelleValeur = 42

returns:

    undo *     Undos,
    unsigned * Nombre = 23,
        const
    coup **    Pointeur,
    coup *     NouvelleValeur = 42

=cut

sub align_decl {
    my ($indent, $text) = @_;
    $text =~ s/[\n\t]/ /g;
    $text =~ s/ *(\*+) */ $1 /g;
    $text =~ s/\s*,\s*/,/g;
    $text =~ s/  +/ /g;
    $text =~ s/\A\s*//;
    $text =~ s/\s*\z//;
    $text =~ s/(\S) +/$1 /g;
   # print STDERR "<<<$text>>>\n";

    my $longest_pre = 0;
    my @orig_lines = split /,/, $text;
    my @want_lines;
    for my $line (@orig_lines) {
        my $decl = $line;
        if ($line =~ /^const (.*)/) {
            $decl = $1;
            push @want_lines, 'const';
        }
        my $last_token_pos;
        $decl =~ /(.*) (\S+ = \S+)$/ || $decl =~ /(.*) (\S+)$/;
        my ($pre, $post) = ($1, $2);
        my $pre_len = length $pre;
        $longest_pre = $pre_len if $pre_len > $longest_pre;
        push @want_lines, [$pre, $post];
    }

    my $new_text = q<>;
    for my $line (@want_lines) {
        if ($line eq 'const') {
            $new_text .= q[ ] x ($indent + 4) . "const\n";
        }
        else {
            my ($pre, $post) = @$line;
            $new_text .=
                (q[ ] x $indent) .
                $pre .
                q[ ] x ($longest_pre - length($pre) + 1) .
                "$post,\n"
            ;
        }
    }
        # Spurious trailing comma.
    $new_text =~ s/,\n$/\n/;
    return $new_text;
}

# --------------------------------------------------------------------
# Main.
# To just test, invoke like  "refmt.pl dont_care t"

sub {
    my ($file, $how) = @_;
    if ($how eq "t") {
        _test();
        exit;
    }

    my $text = File::Slurper::read_text($file);
    $text =~ /^(\s+)/;
    my $indent = length $1;
    if ($how eq 'decl') {
        $text = align_decl($indent, $text);
    }
    elsif ($how eq 'hdr') {
        $text = fmt_hdr(0, $text);
    }
    File::Slurper::write_text($file, $text);
}->(@ARGV);

# --------------------------------------------------------------------
sub _test {
    require Test::More;
    _test_decl();
    _test_hdr();
}

sub _test_hdr {
    my $data = << 'EoTC';
« h0 ¶ int*h0(); ¶
    int *
h0 (
);
»
EoTC
    while ($data =~ / « (.*?) » /xsg) {
        my ($id, $req, $exp) = split /¶/, $1;
        $exp =~ s/\A\n//;
        my $got = fmt_hdr(0, $req);
        Test::More::is($got, $exp, $id);
        
    }
}

sub _test_decl {
    my $data = << 'EoTC';
« d0 ¶  ¶
»
« d1 ¶ bool x ¶
    bool x
»
« d2 ¶ bool x , int**y = 42¶
    bool   x,
    int ** y = 42
»
« d3 ¶ bool x 
  , const florb z,int y = 42
¶
    bool  x,
        const
    florb z,
    int   y = 42
»
EoTC
    while ($data =~ / « (.*?) » /xsg) {
        my ($id, $req, $exp) = split /¶/, $1;
        $exp =~ s/\A\n//;
        my $got = align_decl(4, $req);
        Test::More::is($got, $exp, $id);
        
    }
}

