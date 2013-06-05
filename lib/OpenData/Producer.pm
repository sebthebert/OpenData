=head1 NAME

OpenData::Producer

=cut

package OpenData::Producer;

use FindBin;
use Moose;

use lib "$FindBin::Bin/../lib/";

=head1 ATTRIBUTES

=cut

has 'name' => (
	is => 'rw',
	isa => 'Str',
	);

has 'source' => (
	is => 'rw',
	isa => '[OpenData::DataSource]',
	);

no Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHOR

Sebastien Thebert <stt@opendata.pm>

=cut