#!/usr/bin/env raku

=begin pod

=head1 NAME

    tstamp.raku - Print timestamps formatted the way I like them.

=head1 SYNOPSIS
☰2023-05-16.Tue
☰2023-05-16.Tue.17-27-43
☰unknown timestamp format id
☰2023-05-16T17:28:03-04:00

        Possible ｢format id｣ values result in
        different timestamp formatting:
            7 : 2015-01-27.Tue
            8 : 2015-01-27.Tue.14:52:22
            9 : 2023-05-16T17:32:48-04:00
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

        # ⦃2014-06-28.Tue⦄
    $format-id == 7 && return sprintf '%s-%02d-%02d.%s',
        $dt.year,
        $dt.month,
        $dt.day,
        DDD($dt),
    ;

        # Used by my .vimrc SaveasTimestamped() function.
        # ⦃2016-01-17.Tue.17:18:34⦄
    $format-id == 8 && return sprintf "%s-%02d-%02d.%s.%02d:%02d:%02d",
        $dt.year, $dt.month, $dt.day, DDD($dt),
        $dt.hour, $dt.minute, $dt.whole-second,
    ;

        # ⦃2023-03-08T08:36:37-05:00⦄
    $format-id == 9 && return $dt.truncated-to('second');

   #     # ⦃2014f.Jun13.Fri.09:14.44⦄
   # $format-id == 0 && return sprintf '%s%s.' ~ '%s%02d.' ~ '%s.%02d:' ~ '%02d.%02d',
   #     $dt.year, M($dt),
   #     MMM($dt), $dt.day,
   #     DDD($dt), $dt.hour,
   #     $dt.minute, $dt.whole-second,
   # ;

    return 'unknown timestamp format id';
}

