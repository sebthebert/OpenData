=head1 NAME

OpenData::DataSource

=cut

package OpenData::DataSource;

use FindBin;
use JSON;
use LWP::Simple;
use Moose;
use Spreadsheet::Read;

use lib "$FindBin::Bin/../lib/";

my $DIR_DATA = "$FindBin::Bin/../data/";

=head1 ATTRIBUTES

=cut

has 'name' => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	);

has 'description' => (
	is => 'rw',
	isa => 'Str',
	);

has 'site' => (
    is => 'rw',
    isa => 'OpenData::Site',
    );
    
has 'producer' => (
	is => 'rw',
	isa => 'OpenData::Producer',
	);

has 'date_publication' => (
	is => 'rw',
	isa => 'Str',
	);

has 'file' => (
    is => 'rw',
    isa => 'Str',
    );
    
has 'url' => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	);

=head1 METHODS

=head2 Data

=cut

sub Data
{
	my $self = shift;

	printf "Read file: %s\n", $self->{file};
 	my $data = ReadData($self->{file});	

	$self->{data} = $data;
}

=head2 Cell(\%coord)

=cut

sub Cell
{
	my ($self, $coord) = @_;

	$self->Data()	if (!defined $self->{data});
	my $cell = cr2cell($coord->{col}, $coord->{row});

	return ($self->{data}->[$coord->{sheet}]{$cell});	
}

=head2 Row()

=cut

sub Row
{
	my ($self, $coord) = @_;

    $self->Data()   if (!defined $self->{data});
	my @items = Spreadsheet::Read::cellrow($self->{data}->[$coord->{sheet}], $coord->{row});

	return (@items);
}

=head2 Download

Downloads data from DataSource url

=cut

sub Download
{
	my $self = shift;
	my $file = $self->{url};
	$file =~ s/^.+\/(.+?)$/$1/;

    printf "Download %s\n", $self->{url};
    $self->{file} = "$DIR_DATA$file";
	getstore($self->{url}, $self->{file})	if (! -r $self->{file});	
}

=head2 Save

=cut

sub Save
{
    my $self = shift;
    
    my $json = new JSON;
    $json = $json->pretty();
    #my $json_str = $json->encode($self);

    #printf "%s\n", $json_str;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHOR

Sebastien Thebert <stt@opendata.pm>

=cut