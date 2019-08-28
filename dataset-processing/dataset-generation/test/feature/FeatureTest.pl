#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
use lib '../../lib';
use Test::Simple tests => 41;
use Test::More;
use Test::Exception;

require_ok('Feature::AbstractFeature');
require_ok('Feature::DesignSmellFeature');
require_ok('Feature::ImplementationSmellFeature');
require_ok('Feature::NOFFeature');
require_ok('Feature::NOPFFeature');
require_ok('Feature::NOMFeature');
require_ok('Feature::NOPMFeature');
require_ok('Feature::LOCFeature');
require_ok('Feature::WMCFeature');
require_ok('Feature::NCFeature');
require_ok('Feature::DITFeature');
require_ok('Feature::LCOMFeature');
require_ok('Feature::FANINFeature');
require_ok('Feature::FANOUTFeature');


use Feature::AbstractFeature;
use Feature::DesignSmellFeature;
use Feature::ImplementationSmellFeature;
use Feature::NOFFeature;
use Feature::NOPFFeature;
use Feature::NOMFeature;
use Feature::NOPMFeature;
use Feature::LOCFeature;
use Feature::WMCFeature;
use Feature::NCFeature;
use Feature::DITFeature;
use Feature::LCOMFeature;
use Feature::FANINFeature;
use Feature::FANOUTFeature;

dies_ok(sub {Feature::AbstractFeature->new()}, 'Testing if it fails when Feature::AbstractFeature is instantiated. It should fail.' );

my $designSmellFeature = Feature::DesignSmellFeature->new();
ok(ref($designSmellFeature) eq 'Feature::DesignSmellFeature', 'Testing Feature::DesignSmellFeature instantiation');

ok($designSmellFeature->getHeader() eq "Design Smell", 'Testing getHeader method for Feature::DesignSmellFeature');
ok($designSmellFeature->getFile() eq "design", 'Testing getFile method for Feature::DesignSmellFeature');

my $implementationSmellFeature = Feature::ImplementationSmellFeature->new();
ok(ref($implementationSmellFeature) eq 'Feature::ImplementationSmellFeature', 'Testing Feature::ImplementationSmellFeature instantiation');

ok($implementationSmellFeature->getHeader() eq "Implementation Smell", 'Testing getHeader method for Feature::ImplementationSmellFeature');

ok($implementationSmellFeature->getFile() eq "implementation", 'Testing getFile method for Feature::ImplementationSmellFeature');

my $nofFeature = Feature::NOFFeature->new();
ok(ref($nofFeature) eq 'Feature::NOFFeature', 'Testing Feature::NOFFeature instantiation');

ok($nofFeature->getHeader() eq "NOF", 'Testing getHeader method for Feature::NOFeature');

ok($nofFeature->getFile() eq "metrics", 'Testing getFile method for Feature::NOFFeature');
my $nopfFeature = Feature::NOPFFeature->new();
ok(ref($nopfFeature) eq 'Feature::NOPFFeature', 'Testing Feature::NOPFFeature instantiation');

ok($nopfFeature->getHeader() eq "NOPF", 'Testing getHeader method for Feature::NOPFFeature');

ok($nopfFeature->getFile() eq "metrics", 'Testing getFile method for Feature::NOPFFeature');

my $nomFeature = Feature::NOMFeature->new();
ok(ref($nomFeature) eq 'Feature::NOMFeature', 'Testing Feature::NOMFeature instantiation');

ok($nomFeature->getHeader() eq "NOM", 'Testing getHeader method for Feature::NOMFeature');

ok($nomFeature->getFile() eq "metrics", 'Testing getFile method for Feature::NOMFeature');

my $nopmFeature = Feature::NOPMFeature->new();
ok(ref($nopmFeature) eq 'Feature::NOPMFeature', 'Testing Feature::NOPMFeature instantiation');

ok($nopmFeature->getHeader() eq "NOPM", 'Testing getHeader method for Feature::NOPMFeature');

ok($nopmFeature->getFile() eq "metrics", 'Testing getFile method for Feature::NOPMFeature');

my $locFeature = Feature::LOCFeature->new();
ok(ref($locFeature) eq 'Feature::LOCFeature', 'Testing Feature::LOCFeature instantiation');

ok($locFeature->getHeader() eq "LOC", 'Testing getHeader method for Feature::LOCFeature');

ok($locFeature->getFile() eq "metrics", 'Testing getFile method for Feature::LOCFeature');

my $wmcFeature = Feature::WMCFeature->new();
ok(ref($wmcFeature) eq 'Feature::WMCFeature', 'Testing Feature::WMCFeature instantiation');

ok($wmcFeature->getHeader() eq "WMC", 'Testing getHeader method for Feature::WMCFeature');

ok($wmcFeature->getFile() eq "metrics", 'Testing getFile method for Feature::WMCFeature');

my $ncFeature = Feature::NCFeature->new();
ok(ref($ncFeature) eq 'Feature::NCFeature', 'Testing Feature::NCFeature instantiation');

ok($ncFeature->getHeader() eq "NC", 'Testing getHeader method for Feature::NCFeature');

ok($ncFeature->getFile() eq "metrics", 'Testing getFile method for Feature::NCFeature');

my $ditFeature = Feature::DITFeature->new();
ok(ref($ditFeature) eq 'Feature::DITFeature', 'Testing Feature::DITFeature instantiation');

ok($ditFeature->getHeader() eq "DIT", 'Testing getHeader method for Feature::DITFeature');

ok($ditFeature->getFile() eq "metrics", 'Testing getFile method for Feature::DITFeature');

my $lcomFeature = Feature::LCOMFeature->new();
ok(ref($lcomFeature) eq 'Feature::LCOMFeature', 'Testing Feature::LCOMFeature instantiation');

ok($lcomFeature->getHeader() eq "LCOM", 'Testing getHeader method for Feature::LCOMFeature');

ok($lcomFeature->getFile() eq "metrics", 'Testing getFile method for Feature::LCOMFeature');

my $faninFeature = Feature::FANINFeature->new();
ok(ref($faninFeature) eq 'Feature::FANINFeature', 'Testing Feature::FANINFeature instantiation');

ok($faninFeature->getHeader() eq "FANIN", 'Testing getHeader method for Feature::FANINFeature');

ok($faninFeature->getFile() eq "metrics", 'Testing getFile method for Feature::FANINFeature');

my $fanoutFeature = Feature::FANOUTFeature->new();
ok(ref($fanoutFeature) eq 'Feature::FANOUTFeature', 'Testing Feature::FANOUTFeature instantiation');

ok($fanoutFeature->getHeader() eq "FANOUT", 'Testing getHeader method for Feature::FANOUTFeature');

ok($fanoutFeature->getFile() eq "metrics", 'Testing getFile method for Feature::FANOUTFeature');
