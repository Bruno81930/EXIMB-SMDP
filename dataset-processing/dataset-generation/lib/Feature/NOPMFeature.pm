#!/usr/bin/perl

use strict;
use warnings;
use v5.10;

package Feature::NOPMFeature;
use parent 'Feature::AbstractFeature';

sub new {
    my ($class) = @_;
    my $self = { };
    bless $self, $class;
}

sub getHeader {
    my ($self) = @_;
    return "NOPM";
}

sub getFile {
    my ($self) = @_;
    return "metrics";
}

sub getColumn {
    my ($self) = @_;
    return 3;
}

1;
