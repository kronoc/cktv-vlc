#!/usr/bin/perl

use strict;
use warnings;



my ($m3u, $xml, $genre, $type) = @ARGV;
# Check that a filename was provided as a command-line argument
if (@ARGV<1) {
  die "Usage: $0 <m3u_file> <xml_file> [<genre> <type>]\n";
}

$m3u = $m3u || "";
$xml = $xml || "output.xml";
$genre = $genre || "iptv"; 
$type = $type || "tv";

# Open the M3U file for reading
open(my $m3u_fh, "<", $m3u) or die "Could not open M3U file: $!\n";

# Open an XML file for writing
open(my $xml_fh, ">", $xml) or die "Could not open XML file: $!\n";

# Write the XML header
print $xml_fh "<directory>\n";

# Parse the M3U file line by line
while (my $line1 = <$m3u_fh>) {
  chomp $line1;
  # Skip lines that don't start with "#EXTINF"
  next unless $line1 =~ /^#EXTINF/;

  # Extract the channel name and URL from the line
  my ($name) = $line1 =~ /^#EXTINF:-1 logo=".*" tvg-id=".*",(.*)$/;
  
  
  my $line2 = <$m3u_fh>;
  chomp $line2;
  my $url = "$line2";
 
  #  print $name;
  #print $url;
  # Write an XML entry for the channel
  print $xml_fh "  <entry>\n";
  print $xml_fh "    <server_name>$name</server_name>\n";
  print $xml_fh "    <server_type>video/mpeg</server_type>\n";
  print $xml_fh "    <bitrate>128</bitrate>\n";
  print $xml_fh "    <samplerate>0</samplerate>\n";
  print $xml_fh "    <channels>1</channels>\n";
  print $xml_fh "    <listen_url>$url</listen_url>\n";
  print $xml_fh "    <current_song>Live $type from $name</current_song>\n";
  print $xml_fh "    <genre>$genre</genre>\n";
  print $xml_fh "  </entry>\n";
}

# Write the XML footer
print $xml_fh "</directory>\n";

# Close the files
close($m3u_fh);
close($xml_fh);

