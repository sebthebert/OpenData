#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use Test::More;

use lib "$FindBin::Bin/../lib/";

use OpenData::DataSerie;
use OpenData::DataSet;
use OpenData::DataSource;

my $NOM = 'ACTIVITƒ DES OPƒRATEURS DE COMMUNICATIONS ƒLECTRONIQUES : SƒRIES CHRONOLOGIQUES TRIMESTRIELLES';
my $URL = 'http://www.data.gouv.fr/var/download/b119bfbe02f0010659a6804ae74af9bc.xlsx';

my $d_src = OpenData::DataSource->new(
	name => $NOM,
	url => $URL
	);

$d_src->Download();

#$d_src->Save();

my $d_serie1 = OpenData::DataSerie->new(
    { 
    	name => 'trimestre', 
        col_range => '4-56', 
        row_range => '2-2' });
        
my $d_serie2 = OpenData::DataSerie->new(
    { 
        name => 'nb_abonnements_lignes_fixes', 
        col_range => '4-56', 
        row_range => '9-9', 
        modifier => sub { my $d = shift; return ($d * 1_000_000); } });

my $d_serie3 = OpenData::DataSerie->new(
    { 
        name => 'nb_abonnements_lignes_mobiles', 
        col_range => '4-56', 
        row_range => '56-56', 
        modifier => sub { my $d = shift; return ($d * 1_000_000); } });
        
my $d_serie4 = OpenData::DataSerie->new(
    { 
        name => 'nb_abonnements_internet_haut_debit', 
        col_range => '4-56', 
        row_range => '44-44', 
        modifier => sub { my $d = shift; return ($d * 1_000_000); } });
        
my $d_set = OpenData::DataSet->new(
    datasource => $d_src,
    path => '/FR/telephonie/mobile/nb_clients',
    fields => [$d_serie1, $d_serie2, $d_serie3, $d_serie4]
    );

$d_set->Extract();

#$d_set->Save();
    
1;

=head1 AUTHOR

Sebastien Thebert <stt@opendata.pm>

=cut
