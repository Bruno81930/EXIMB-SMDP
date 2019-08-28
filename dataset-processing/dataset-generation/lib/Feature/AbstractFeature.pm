#!/usr/bin/perl

use strict;
use warnings;
use v5.10;

package Feature::AbstractFeature;

sub new {
    die "Error: Feature::Builder is an abstract class";
}

sub getHeader {
    die "Error: abstract method getHeader needs to be overridden";
}

sub getFile {
    die "Error: abstract method getFile needs to be overriden";
}

sub getColumn {
    die "Error: abstract method getColumn to be overriden";
}
1;
