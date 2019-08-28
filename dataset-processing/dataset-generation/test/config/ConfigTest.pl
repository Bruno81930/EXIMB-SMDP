#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
use lib '../../lib';
use Test::Simple tests => 1;
use Test::More;
use Test::Exception;

require_ok('Util::ConfigReader');

require Util::ConfigReader;

my $config = Util::ConfigReader->new(configdir => '../../config');

my @features =  @{$config->getFeatures()};
say @features;
