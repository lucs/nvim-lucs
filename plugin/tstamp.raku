#!/usr/bin/env raku

=begin pod

=head1 NAME

    tstamp.raku - Print timestamps formatted the way I like them.

=head1 SYNOPSIS

        Possible ｢format id｣ values result in
        different timestamp formatting:
            0 : 2015-01-27   
            1 : 2015-01-27.14-52-22
            2 : 2015a.Jan27.Tue.14:52.22
    tstamp.raku ｢format id｣

=end pod

# --------------------------------------------------------------------
sub MAIN ($format-id = 0) {
    print format-it(DateTime.now, $format-id);
}

sub MMM (DateTime $dt) {
    <Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>[$dt.month - 1];
}

sub DDD (DateTime $dt) {
    <Sun Mon Tue Wed Thu Fri Sat>[$dt.day-of-week % 7];
}

sub M (DateTime $dt) {
    ('a' .. 'l')[$dt.month - 1];
}

# --------------------------------------------------------------------
sub format-it (DateTime $dt, $format-id) {

        # ⦃2014-06-28⦄
    $format-id == 0 && return sprintf '%s-%02d-%02d',
        $dt.year,
        $dt.month,
        $dt.day,
    ;

        # Used by my .vimrc SaveasTimestamped() function.
        # ⦃2016-01-17.17-18-34⦄
    $format-id == 1 && return sprintf "%s-%02d-%02d.%02d-%02d-%02d",
        $dt.year, $dt.month, $dt.day,
        $dt.hour, $dt.minute, $dt.whole-second,
    ;

        # ⦃2014f.Jun13.Fri.09:14.44⦄
    $format-id == 2 && return sprintf '%s%s.' ~ '%s%02d.' ~ '%s.%02d:' ~ '%02d.%02d',
        $dt.year, M($dt),
        MMM($dt), $dt.day,
        DDD($dt), $dt.hour,
        $dt.minute, $dt.whole-second,
    ;

    return 'unknown timestamp format id';
}

