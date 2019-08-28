#!/usr/bin/perl

package Util::ConfigReader;

use strict;
use warnings;
use v5.10;

sub new {
    my ($class, %args) = @_;
    $args{features} = _readFeaturesFile($args{configdir});
    return bless \%args, $class;
}

sub _readFeaturesFile {
    my ($configDir) = @_;
    my $featureConfigPath = "$configDir/features.config";
    open my $fh, "<", $featureConfigPath or die "Error: the config directory is wrong or there is not features.config file $featureConfigPath";
    chomp(my @features = <$fh>);    
    @features = grep /\S/, @features;
    close $fh; 
    die "Error: features.config file does not follow the convention" unless $#features == 12;
    
    return \@features;
}

sub getFeatures {
    my ($self) = @_;
    my @features = ();
    @features = grep !/.*\#.*/, @{$self->{features}};
    return \@features;
}
1;
