#!/usr/bin/perl

use strict;
use warnings;
use v5.10;

package Feature::NOFFeature;
use parent 'Feature::AbstractFeature';

sub new {
    my ($class) = @_;
    my $self = { };
    bless $self, $class;
}

sub getHeader {
    my ($self) = @_;
    return "NOF";
}

sub getFile {
    my ($self) = @_;
    return "metrics";
}

sub getColumn {
    my ($self) = @_;
    return 0;
}
1;
