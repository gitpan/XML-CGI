#!/usr/bin/perl -w
use strict;
use XML::CGI;
my $q = new XML::CGI;

# load CGI variables from XML file
open (XML,"cgi.xml");
my $xml = join("",<XML>);
$q->toCGI($xml);

# print CGI variables
foreach my $item ($q->param) {
    print "$item = ", $q->param($item), "\n";
}

