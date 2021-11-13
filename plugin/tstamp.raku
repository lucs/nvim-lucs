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

# --------------------------------------------------------------------
=finish

# --------------------------------------------------------------------
sub MAIN ($date-str, $format-id = 0) {
    my $tc = TimeComponents.new($date-str);
    print $tc.format-it($format-id);
}

    # Trim away parts of the string that are unnecessary or
    # which may confuse the parser; join elements back into
    # one space separated string
my $try = join ' ', (split /\s/, $string)[1, 2, 5];
my $date = ParseDate $try;

if (! $date) {
  print "Parsing failed.\n";
}
else {
  $date = UnixDate($date, "%Y-%m-%d");
  print "$date\n";
}

# --------------------------------------------------------------------
class TimeComponents {

    has $!str;

    has $!YYYY;

        # Month as a letter, from 'a' to 'l'.
    has $!M;

        # Month number, '0' padded, from '01' to '12.
    has $!MM;

        # Month abreviation, as a three letter string, like 'Jan'.
    has $!MMM;

        # Day number, '0' padded, from '01' to '31.
    has $!DD;

        # Day abreviation, as a three letter string, like 'Sun'.
    has $!DDD;

        # 0-padded hours, minutes, and seconds
    has $!hh;
    has $!mm;
    has $!ss;

# --------------------------------------------------------------------
    sub new ($date-str) {
        $args{str} = $date-str;
            
        return $date-str if $date-str ne "NOW";

        $epoch_moment //= time;
            require Date::Manip;
            my $date = Date::Manip::Date->new($date-str);
            my $epoch_moment = $date->printf('%s');
            %args = make_args($epoch_moment);
        }
        return \%args;
    }

        my ($_yr, $_mo, $_da, $_daw, $_hr, $_mi, $_se)
          = (localtime $epoch_moment)[5, 4, 3, 6, 2, 1, 0];
        my %args;
        $args{YYYY} = $_yr + 1900;
        $args{M} = ('a' .. 'l')[$_mo];
        $args{MM} = sprintf '%02d', $_mo + 1;
        $args{MMM} =
          qw<Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec>[$_mo];
        $args{DDD} = qw<Sun Mon Tue Wed Thu Fri Sat>[$_daw];
        $args{DD} = sprintf '%02d', $_da;
        $args{hh} = sprintf '%02d', $_hr;
        $args{mm} = sprintf '%02d', $_mi;
        $args{ss} = sprintf '%02d', $_se;
        return %args;
    }

# --------------------------------------------------------------------
sub format-it (DateTime $dt, $format-id) {
        # ⦃.2014f.Jun13.Fri.09:14.44⦄
    $format-id == 0 && return sprintf "⌘%s%s.%s%s.%s.%s:%s.%s",
        $!YYYY, $!M,
        $!MMM, $!DD,
        $!DDD,
        $!hh, $!mm, $!ss,
    ;
        # ⦃2014-06-28⦄
    $format-id == 1 && return sprintf "%s-%s-%s",
      $!YYYY, $!MM, $!DD;

        # Used by my .vimrc SaveasTimestamped() function.
        # ⦃2016-01-17.17-18-34⦄
    $format-id == 2 && return sprintf "%s-%s-%s.%s-%s-%s",
        $!YYYY, $!MM, $!DD,
        $!hh, $!mm, $!ss,
    ;
    return 'unknown';
}

