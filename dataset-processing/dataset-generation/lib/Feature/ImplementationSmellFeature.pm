#!/usr/bin/perl

use strict;
use warnings;
use v5.10;

package Feature::ImplementationSmellFeature;
use parent 'Feature::AbstractFeature';

sub new {
    my ($class) = @_;
    my $self = { };
    bless $self, $class;
}

sub getHeader {
    my ($self) = @_;
    return "Implementation Smell";
}

sub getFile {
    my ($self) = @_;
    return "implementation";
}

sub getColumn {
    my ($self) = @_;
    return 1;
}
1;
