#!/usr/bin/perl

use strict;
use warnings;
use File::Spec;
use Getopt::Long;
use Pod::Usage;
use File::Basename;

our $VERSION = "0.0.1";
our $SCRIPT  = basename($0);

$| = 1;

GetOptions (
    'h|help'     => \my $help,
    'v|version'  => \my $version,
    'f|file=s'   => \my $file,
) or pod2usage(2);

$version and do { print "$SCRIPT: $VERSION\n"; exit 0 };
pod2usage(1) if $help;
die "list file not found." if !defined $file;

my @data = file_read($file);

foreach my $line (@data) {

    chomp $line;
    my ($startip, $endip) = split " ", $line;
    my @sip_oct = split '\.', $startip;
    my @eip_oct = split '\.', $endip;

    next if print_iprage($sip_oct[0], $eip_oct[0], "");
    next if print_iprage($sip_oct[1], $eip_oct[1], $sip_oct[0] . ".");
    next if print_iprage($sip_oct[2], $eip_oct[2], $sip_oct[0] . "." . $sip_oct[1] . ".");
    next if print_iprage($sip_oct[3], $eip_oct[3], $sip_oct[0] . "." . $sip_oct[1] . "." . $sip_oct[2] . ".");
}


sub print_iprage {

    my ($start, $end, $same_segment) = @_;

    return 0 if ($start eq $end);
 
    if ($start eq "0" && $end eq "255") {
        print $same_segment . "*,";
        return 1;
    }

    foreach my $n ($start .. $end) {
        print $same_segment . $n . ".*,";
    }
    return 1;
}

sub file_read {

    my $read_file = shift;

    open(HFILE, "< $read_file") or die "can not open file: $read_file";
    my @contents = <HFILE>;
    close HFILE;

    return @contents;
}

__END__

=head1 NAME

create_jpnic_ip_list.pl - create ip list from JPNIC

=head1 SYNOPSIS

 create_jpnic_ip_list.pl -f listfile

    ex) ./create_jpnic_ip_list.pl -f jpnic_ip.list

 Options:
    -file -f                        set list file
    -help -h                        brief help message
    -version -v                     brief version

=head1 AUTHOR

MATSUMOTO Ryosuke

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
