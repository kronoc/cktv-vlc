#!/usr/bin/env perl

=head1 NAME

playlist2xml

=head1 DESCRIPTION

Turns an m3u playlist into an icecast style XML feed. With thanks to mkpodcasts by David Cantrell (https://github.com/DrHyde).

=head1 ARGUMENTS

The first three arguments are mandatory.

=head2 --source

The m3u file to use.

=head2 --target

The xml file to create.

=head2 --sortby (optional)

Playlist file entries will be sorted by this field. Valid values are 'natural' and 'name'.

=head1 AUTHOR, LICENCE, ETC

Written by Conor Keegan (and based on mkpodcasts by David Cantrell).

You may use, modify and distribute this software in accordance with the
terms laid out in the GNU General Public Licence version 2.

=cut

use strict;
use warnings;

use Template;
use Data::Dumper;
use MIME::Types;
use File::Slurp;
use Getopt::Long;
use HTTP::Date;
use Pod::Usage;

my $sortby = 'natural';
my($source, $target, $help);

GetOptions(
    'source=s'  => \$source,
    'target=s'  => \$target,
    'sortby=s'  => \$sortby,
    'help|?'    => \$help,
);
pod2usage(0) if($help);

my %sorters = (
    natural => sub { $_ },
    name  => sub { $_[0] cmp $_[1] },
);
pod2usage({ -message => "source must be a directory", -exitval => 1 }) unless(-f $source);
pod2usage({ -message => "sortby must be one of [".join(', ', sort keys %sorters)."]", -exitval => 1 })
    unless(my $sortsub = $sorters{$sortby});

#open source file

opendir(SOURCE, $source) || die("Can't read $source\n");
my @files = grep { -f "$source/$_" && $_ =~ /\.(mp3|m4a|mp4|m4v)$/ } readdir(SOURCE);
closedir(SOURCE);
foreach my $file (@files) {
    unlink("$target/$file");
    link("$source/$file", "$target/$file");
}
my $title = "Podcast of ".(grep { $_ } split('/', $source))[-1];
my $count = time();

Template->new()->process(
# print Dumper(
    \(''.read_file(\*DATA)),
    {
        title       => $title,
        homepage    => $httpdir,
        description => "The media files from $source",
        pubdate     => time2str(),
        items       => [ map {
            $count++;
            my ($size, $mtime) = (stat($_))[7, 9];
            (my $filename = $_) =~ s/.*\///;
            (my $url = $_) =~ s/^$target/$httpdir/;
            {
                title       => $filename,
                description => $_,
                pubdate     => time2str($sortby eq 'mtime' ? $mtime : $count),
                size        => $size,
                url         => $url,
                mime        => MIME::Types->new()->mimeTypeOf($_),
            }
        } sort { $sortsub->($a, $b) } map { "$target/$_" } @files ]
    },
    "$target/feed.xml"
);

__DATA__
<?xml version="1.0" encoding="utf-8"?>
<directory>
    [% FOREACH item IN items %]
	 <entry>
                <server_name>[% item.title %]</server_name>
                <server_type>[% item.type %]</server_type>
                <bitrate>[% item.bitrate %]</bitrate>
                <samplerate>0</samplerate>
                <channels>0</channels>
                <listen_url>[% item.url %]</listen_url>
                <current_song>Live Stream from [% item.title %]</current_song>
                <genre>Various</genre>
        </entry>
    [% END %]
</directory>
