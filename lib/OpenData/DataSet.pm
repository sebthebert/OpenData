=head1 NAME

OpenData::DataSet

=cut

package OpenData::DataSet;

use JSON;
use Moose;

=head1 ATTRIBUTES

=cut

has 'datasource' => (
    is => 'rw',
    isa => 'OpenData::DataSource',
    required => 1,
    );
    
has 'path' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    );
    
has 'fields' => (
    is => 'rw',
    isa => 'ArrayRef[OpenData::DataSerie]',
    required => 1,
    );

=head1 METHODS

=head2 Extract()

=cut

sub Extract
{
    my $self = shift;
    
    my %line = ();
    my $last  = 0;
    foreach my $f (@{$self->{fields}})
    {
    	my ($c_begin, $c_end) = split '-', $f->{col_range};
    	my ($r_begin, $r_end) = split '-', $f->{row_range};
    	$last = $c_end - $c_begin;
    	foreach my $r ($r_begin..$r_end)
    	{
    	   my @cols = ();
            foreach my $c ($c_begin..$c_end)
            {
                my $data = $self->{datasource}->Cell({ sheet => 1, col => $c, row => $r });
                $data = &{$f->{modifier}}($data) if (defined $f->{modifier});
                push @cols, $data;
            }
            $line{$f->{name}} = \@cols;
            printf "BEFORE %s\n", join(',', @cols);  
    	}    	
    }
    my @rows = ();
    foreach my $i (0..$last-1)
    {
    	printf "$i\n";
        my %row = ();
        foreach my $k (keys %line)
        {
        	$row{$k} = $line{$k}->[$i];
        	printf "$k : $line{$k}->[$i]\n";
        }
        push @rows, \%row; 
    }
    my $json = new JSON;
    $json = $json->pretty();
    my $json_str = $json->encode(\@rows);

    printf "%s\n", $json_str;
}

=head2 Save()

=cut

sub Save
{
	my $self = shift;

	my $json = new JSON;
    $json = $json->pretty();
    my $json_str = $json->encode($self);

	printf "%s\n", $json_str;		
}

no Moose;
__PACKAGE__->meta->make_immutable;
  
1;

=head1 AUTHOR

Sebastien Thebert <stt@opendata.pm>

=cut
