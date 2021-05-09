#!/usr/bin/env perl

=head1 NAME

    acutags.pl - Manage acutags within a file.

=head1 SYNOPSIS

        Just list the tags and the number of times they are used.
    acutags.pl -l $file

        Fix up the tags.
    acutags.pl -f $file

=head1 DESCRIPTION

I like to tag parts of my various notes files with what I call
"acutags".

Only works on UTF-8 files.

&#180; | \264 | =B4 | \ \ | (´) | Acute accent

A safe way to use it:

    Make sure the ´ wrapper lines are present in the file.

    Run with the -l option, and check the output carefully for tags
    using non-\w characters.

    Fix the file with the -f option.

When confident that the tags are okay, run from Vim on the current
file.

A typical file:

    Bla bla

    ´
    -´bar   Currently unused tag, but kept listed (for this description).
    ´foo    A long, multiline
    ´"          description.
    ´typ    A typical acutag.
    ´

    Lorem ipsum ´foo dolor sit ´typ amet.

Within the text, it's a good idea to have acutags appear on a line
with context, so that grepping for them gives a clue as to what it's
covering around there.

=cut

# --------------------------------------------------------------------
use strict;
use warnings;
use utf8;
use open qw<:std :utf8>;
use feature 'say';
use Getopt::Long;
use Path::Tiny;
use POSIX;

sub {
    my %opts;
    GetOptions(\%opts,
            # Just list the acutags found in the file.
        'l',
            # Fix the file.
        'f',
            # Run some tests.
        't',
    ) or usage_die();
    if ($opts{t}) {
        run_tests();
        return;
    }
    my ($filename) = @ARGV;
    usage_die("Please specify the filename.") unless defined $filename;
    if ($opts{l}) {
        list_acutags($filename);
    }
    elsif ($opts{f}) {
        fix_acutags($filename);
    }
    else {
        usage_die();
    }
}->();

sub usage_die {
    my ($msg) = @_;
    say "$msg\n" if $msg;
    print STDERR << 'EoT';
Usage:
    acutags.pl [-l | -f] $filename
    acutags.pl -t

Options:
    -l  List the tags and their usage count.
    -f  Fix up the tags section.
    -t  Run some tests.
EoT
    die "\n";
}

# --------------------------------------------------------------------
# List all the acutags found in a given file.

sub list_acutags {
    my ($filename) = @_;
    my $text = path($filename)->slurp_utf8;
    return _list_acutags($text);
}

sub _list_acutags {
    my ($text) = @_;
    my (undef, $acutags, undef) = parse($text);
    for my $acutag (sort keys %$acutags) {
        my $used = $acutags->{$acutag}{used};
        my $desc = $acutags->{$acutag}{desc};
        my @desc = split "\x03", $desc;
        if (@desc == 0) {
            printf "%3d ´%s\n", $used, $acutag;
        }
        else {
            printf "%3d ´%s - %s\n", $used, $acutag, $desc[0] // q<>;
            for my $ndx (1 .. $#desc) {
                printf "%3d ´\" - %s\n", $used, $desc[$ndx];
            }
        }
    }
}

# --------------------------------------------------------------------
sub fix_acutags {
    my ($filename) = @_;
    my $text = path($filename)->slurp_utf8;
    my $new_text = _fix_acutags($text);

        # Replace the original file contents.
    path($filename)->spew_utf8($new_text);
}

sub _fix_acutags {
    my ($text) = @_;
    my ($bef_tags, $acutags, $aft_tags) = parse($text);
        # Get longest length.
    my $max_acutag_len = 0;
    for my $acutag (keys %$acutags) {
        $_ > $max_acutag_len and $max_acutag_len = $_ for length $acutag;
    }

    # Rebuild the acutags text.

        # Add 2 for ｢-｣ and ｢´｣.
    my $acutag_col_wid = POSIX::ceil(($max_acutag_len + 2) / 4) * 4;
    my $acutags_text = q<>;
    for my $k (sort keys %$acutags) {
        my $unused = $acutags->{$k}{used} == 0 ? "-" : q<>;
        my $tag_text .= "$unused´$k";
        my $desc = $acutags->{$k}{desc};
        if (length($desc) > 0) {
            my @desc = split "\x03", $desc;
            $tag_text .= q[ ] x ($acutag_col_wid - length($tag_text));
            $tag_text .= $desc[0];
            for my $ndx (1 .. $#desc) {
                my $pfx = qq<\n$unused´">;
                    # Add 5 because newline shouldn't count in length
                    # of prefix.
                $tag_text .= $pfx . q[ ] x ($acutag_col_wid - length($pfx) + 5);
                $tag_text .= $desc[$ndx];
            }
        }
        $acutags_text .= "$tag_text\n";
    }
    return "$bef_tags´\n$acutags_text´\n$aft_tags";
}

# --------------------------------------------------------------------
sub parse {
    my ($text) = @_;
        # The literal '´' matches in UTF-8 files only (we opened the
        # files that way).
    my ($bef_tags, $tags_text, $aft_tags) =
      $text =~ / (.*?) ^ ´ \n (.*?) ^ ´ \n (.*) /xms;
    usage_die("No wrapper ´ lines found (is the file UTF-8?).")
      unless defined $tags_text;

    my %hdr_tags;
    my $last_tag = q<>;
    while ($tags_text =~ / ^ \-? ´ ([´"\w]+) (.*?) \n /xgm) {
        my ($tag, $desc) = ($1, $2);
        $desc //= q<>;
        $desc =~ s/\s+//;
        if ($tag eq q<">) {
            $hdr_tags{$last_tag} .= "\x03$desc";
        }
        else {
            $last_tag = $tag;
            $hdr_tags{$tag} = $desc;
        }
    }

    my %bod_tags;
    ++$bod_tags{$_} for $bef_tags =~ /´([´\w]+)/g;
    ++$bod_tags{$_} for $aft_tags =~ /´([´\w]+)/g;

    my %acutags;
    for my $hk (keys %hdr_tags) {
        $acutags{$hk}{desc} = $hdr_tags{$hk};
        $acutags{$hk}{used} = $bod_tags{$hk} // 0;
    }
    for my $bk (keys %bod_tags) {
        if (! exists $acutags{$bk}) {
            $acutags{$bk}{used} = $bod_tags{$bk};
            $acutags{$bk}{desc} = q<>;
        }
    }
    return $bef_tags, \%acutags, $aft_tags;
}

# --------------------------------------------------------------------
sub run_tests {
    my $test_this = sub {
        my ($do_it, $test_data) = @_;
        return unless $do_it;
        say "-" x 70;
        say $test_data;
        say "-" x 70;
        _list_acutags($test_data);
        say "-" x 70;
        say _fix_acutags($test_data);
        say "-" x 70;
    };
    $test_this->(1, << '    EoD' =~ s/^ {8}//gmr);
        sadf
           sdf

        ´
        ´foo      foooooo

        ´bar BAR
        ´"       (bar continuation)
        ´baz        bazbaz

        ´

        The ´foo is on. ´´meep too
    EoD
    $test_this->(0, << '    EoD' =~ s/^ {8}//gmr);
        ´
        ´bar BAR
        ´"       (bar continuation)
        ´baz This is Baz
        ´" (baz continuation1 )
        ´"       (baz continuation2 )

        ´
    EoD
}

