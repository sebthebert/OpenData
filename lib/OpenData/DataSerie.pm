=head1 NAME

OpenData::DataSerie

=cut

package OpenData::DataSerie;

use Moose;

=head1 ATTRIBUTES

=cut

has 'name' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    );

has 'type' => (
    is => 'rw',
    isa => 'Str',
    );
    
has 'modifier' => (
    is => 'rw',
    isa => 'CodeRef',
    );
    
has 'col_range' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    );

has 'row_range' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    );
    
no Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHOR

Sebastien Thebert <stt@opendata.pm>

=cut
