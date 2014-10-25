package XML::CGI;

use strict;
use CGI;
use vars qw($VERSION @ISA $self $parser);
use XML::Parser;

@ISA = qw(CGI);
$VERSION = '0.02';

sub toXML {
        my ($self,$root) = @_;
        my $xml = join "\n", (map { "<$_>" . $self->param($_) . "</$_>" } $self->param), "";
	return $root 
           ? "<$root>\n$xml</$root>\n"
	   : $xml;
}

sub toCGI {
    my ($self, $xml) = @_;
    my $root;
    my $parser = new XML::Parser(Handlers => {Char => $self->handle_char});
    $parser->parse($xml);
}

sub handle_char {
        my $self = shift;
        return sub {
	    my ($parser,$cdata) = @_;
	    return if $parser->depth == 1;
	    my $element = $parser->current_element;
	    $self->delete($element);
	    unshift @{$self->param_fetch(-name=>$element)},$cdata;
        }
}

1;
__END__


=head1 NAME

XML::CGI - Perl extension for converting CGI.pm variables to/from XML

=head1 SYNOPSIS

  use XML::CGI;
  $q = new XML::CGI;

  # convert CGI.pm variables to XML
  $xml = $q->toXML;
  $xml = $q->toXML($root);
  
  # convert XML to CGI.pm variables
  $q->toCGI($xml);

=head1 DESCRIPTION

The XML::CGI module converts CGI.pm variables
to XML and vice versa.

B<XML::CGI> is a subclass of B<CGI.pm>, so it reads the CGI 
variables just as CGI.pm would.

=head1 METHODS

=item $q = new XML::CGI

=over 4

creates a new instance of XML::CGI. You also have access
to all of the methods in CGI.pm.

=back

=item $q->toXML([$root])

=over 4

where B<$root> is an optional parameter that specifies
the root element. By default, B<toXML> will not return a root
element.

=back

=item $q->toCGI($xml)

=over 4

where B<$xml> is the XML you would like to convert
to CGI.pm parameters. Values in the XML will overwrite any
existing values if they exist.

=back

=head1 NOTE

B<XML::CGI> does not currently handle multiple selections
passed from HTML forms. This will be added in a future release.

=head1 AUTHOR

Jonathan Eisenzopf <eisen@pobox.com>

=head1 CONTRIBUTORS

David Black <dblack@candle.superlink.net>

=head1 SEE ALSO

perl(1), XML::Parser(3).

=cut
