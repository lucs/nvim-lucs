#!/usr/bin/env perl

=head1 NAME

    gotohowto.pl -

=head1 SYNOPSIS

    gotohowto.pl ｢file｣

=head1 DESCRIPTION

=cut

# --------------------------------------------------------------------
use strict;
use warnings;
use utf8;
use open qw<:std :utf8>;
use feature 'say';
use Path::Tiny;
use File::Temp;
use POSIX;

# --------------------------------------------------------------------
sub {
    my ($rd_file, $wr_file) = @ARGV;
    usage_die("Please specify the filename to read from.") unless defined $rd_file;
    usage_die("Please specify the filename to write to.") unless defined $wr_file;
    my $text = path($rd_file)->slurp_utf8;
    my $line_num = 0;
    my @found;
    while ($text =~ /^ (.*) /xmg) {
        ++$line_num;
        my $line = $1;
        if ($line =~ /^ .*? ‼〈 /xm) {  #〉
            if ($line !~ /^ .*? ‼〈 \s* (.*?) \s*〉 /xm) {
                push @found, ['ko', $line_num, $line];
            }
            else {
                push @found, ['ok', $line_num, $1];
            }
        }
    }
    my $precis = int (log($line_num) / log(10)) + 1;
    my $howto_lines = q<>;
    for my $d (@found) {
        my ($status, $line_num, $line) = @$d;
        $howto_lines .= sprintf "%${precis}d   %s\n", $line_num, $line;
    }
    path($wr_file)->spew("$rd_file\n" . $howto_lines);
}->();

# --------------------------------------------------------------------
sub usage_die {
    my ($msg) = @_;
    say "$msg\n" if $msg;
    print STDERR << 'EoT';
Usage:
    table_funcs.pl ｢read_from_file｣ ｢write_to_file｣
EoT
    die "\n";
}

