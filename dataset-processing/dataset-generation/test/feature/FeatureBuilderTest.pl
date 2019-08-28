#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
use lib '../../lib';
use Test::Simple tests => 6;
use Test::More;
use Test::Exception;

require_ok('Feature::Builder');

use Feature::Builder;
use Feature::DesignSmellFeature;
use Feature::DITFeature;
use Feature::NCFeature;
use Feature::WMCFeature;
use Feature::ImplementationSmellFeature;

my $featureBuilder = Feature::Builder->new();
my $designSmellFeature = Feature::DesignSmellFeature->new();
my $ditFeature = Feature::DITFeature->new();
my $ncFeature = Feature::NCFeature->new();
my $wmcFeature = Feature::WMCFeature->new();

ok(ref(@{$featureBuilder->addFeature($designSmellFeature)}[0]) eq 'Feature::DesignSmellFeature', "Test addFeatureMethod");

$featureBuilder->addFeature($ditFeature);
$featureBuilder->addFeature($ncFeature);
$featureBuilder->addFeature($wmcFeature);

my $smellPath = "/tmp/smell/Lang/1";
ok($featureBuilder->smellpath($smellPath) eq $smellPath, 'Testing smellPath accessors');
my $inpath = "/tmp/";
ok($featureBuilder->defectivepath($defectivePath) eq $defectivePath, 'Testing defectivePath accessors');
my $inputdatasetpath = "/tmp/datasetInput";
ok($featureBuilder->inputdatasetpath($inputdatasetpath) eq $inputdatasetpath, 'Testing inputdatsetpath accessors');
my $outputdatasetpath = "/tmp/datasetOutput";
ok($featureBuilder->outputdatasetpath($outputdatasetpath) eq $outputdatasetpath, 'Testing outputdatasetpath accessors');


$featureBuilder->getDatasetInput();
$featureBuilder->getTrainingDataset();

my $featureBuilder2 = Feature::Builder->new();
my $implementationSmellFeature = Feature::ImplementationSmellFeature->new();

#$featureBuilder2->addFeature($ditFeature);
$featureBuilder2->addFeature($designSmellFeature);
$featureBuilder2->addFeature($implementationSmellFeature);
#$featureBuilder2->addFeature($ncFeature);
#$featureBuilder2->addFeature($wmcFeature);

ok($featureBuilder2->smellpath($smellPath) eq $smellPath, 'Testing smellPath accessors');
ok($featureBuilder2->outputdatasetpath($outputdatasetpath) eq $outputdatasetpath, 'Testing outputdatasetpath accessors');
ok($featureBuilder2->inputdatasetpath($inputdatasetpath) eq $inputdatasetpath, 'Testing inputdatsetpath accessors');
ok($featureBuilder2->defectivepath($defectivePath) eq $defectivePath, 'Testing defectivePath accessors');

$featureBuilder2->getTrainingDataset();
