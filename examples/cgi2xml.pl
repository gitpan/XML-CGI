#!/usr/bin/perl -w
use strict;
use XML::CGI;
my $q = new XML::CGI;

# save CGI variables to XML file
my $xml = $q->toXML("cgi");
print $xml;
