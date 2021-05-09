#!/usr/bin/env perl6

sub MAIN ($rd-file, $wr-file) {
    my $line_num = 0;
    my @found;
    $rd-file.IO.lines.map: {
        my $line = $_;
        ++$line_num;
        if $line ~~ /^ .*? 'ʈ' [$<indentl-level> = \d+]? \s+ $<entry> = [.*] / {
            @found.push([$line_num, (' ' x ($<indentl-level> // 0) * 4) ~ $<entry>]);
        }
    }
    my $precis = ($line_num.log / 10.log).truncate + 1;
    my $toc-lines = "";
    for @found -> $d {
        my ($line_num, $line) = @$d;
        $toc-lines ~= sprintf "%{$precis}d   %s\n", $line_num, $line;
    }
    spurt $wr-file, "$rd-file\n$toc-lines";
}

