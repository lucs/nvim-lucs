#!/usr/bin/env perl

=head1 NAME

    tstamp.pl - Print timestamps formatted the way I like them.

=head1 SYNOPSIS

        If ｢date｣ is "NOW", uses current moment, else tries to
        interpret it as a date. Possible ｢format id｣ values result in
        different timestamp formatting:
            0 : .2015a.Jan27.Tue.14:52.22
            1 : 2015-01-27   
            2 : 2016-01-17.15-57-03
    tstamp.pl ｢date｣ ｢format id｣

=head1 DESCRIPTION

=cut

# --------------------------------------------------------------------
use strict;
use warnings;
use Date::Manip;

# --------------------------------------------------------------------

=for keeping_around

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

=cut

# --------------------------------------------------------------------
package TimeComponents;
use Moo;

has str  => (is => 'ro');
has YYYY => (is => 'ro');
    # Month as a letter, from 'a' to 'l'.
has M    => (is => 'ro');
    # Month number, '0' padded, from '01' to '12.
has MM   => (is => 'ro');
    # Month abreviation, as a three letter string, like 'Jan'.
has MMM  => (is => 'ro');
    # Day number, '0' padded, from '01' to '31.
has DD   => (is => 'ro');
    # Day abreviation, as a three letter string, like 'Sun'.
has DDD  => (is => 'ro');
    # 0-padded hours, minutes, and seconds
has hh   => (is => 'ro');
has mm   => (is => 'ro');
has ss   => (is => 'ro');

# --------------------------------------------------------------------
sub BUILDARGS {
    my ($class, $date_str) = @_;
    my %args;
    $args{str} = $date_str;
    if ($date_str eq "NOW") {
        %args = make_args();
    }
    else {
        require Date::Manip;
        my $date = Date::Manip::Date->new($date_str);
        my $epoch_moment = $date->printf('%s');
        %args = make_args($epoch_moment);
    }
    return \%args;
}

# --------------------------------------------------------------------
sub make_args {
    my ($epoch_moment) = @_;
    $epoch_moment //= time;
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
sub format_it {
    my ($self, $format_id) = @_;
        # ⦃.2014f.Jun13.Fri.09:14.44⦄
    $format_id == 0 && return sprintf "⌘%s%s.%s%s.%s.%s:%s.%s",
        $self->YYYY, $self->M,
        $self->MMM, $self->DD,
        $self->DDD,
        $self->hh, $self->mm, $self->ss,
    ;
        # ⦃2014-06-28⦄
    $format_id == 1 && return sprintf "%s-%s-%s",
      $self->YYYY, $self->MM, $self->DD;

        # Used by my .vimrc SaveasTimestamped() function.
        # ⦃2016-01-17.17-18-34⦄
    $format_id == 2 && return sprintf "%s-%s-%s.%s-%s-%s",
        $self->YYYY, $self->MM, $self->DD,
        $self->hh, $self->mm, $self->ss,
    ;
    return 'unknown';
}

# --------------------------------------------------------------------
sub {
    my ($date_str, $format_id) = @_;
    my $tc = TimeComponents->new($date_str);
    $format_id //= 0;
    $format_id = 0 if $format_id eq q<>;
    print $tc->format_it($format_id);
}->(@ARGV);

