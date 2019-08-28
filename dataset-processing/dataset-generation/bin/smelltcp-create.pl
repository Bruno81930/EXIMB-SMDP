#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
use Cwd 'getcwd';
use lib '../lib';
use Time::Progress;
use Try::Tiny;

require Util::ConfigReader;
require Feature::DITFeature;
require Feature::DesignSmellFeature;
require Feature::FANINFeature;
require Feature::FANOUTFeature;
require Feature::ImplementationSmellFeature;
require Feature::LCOMFeature;
require Feature::LOCFeature;
require Feature::NCFeature;
require Feature::NOMFeature;
require Feature::NOPFFeature;
require Feature::NOPMFeature;
require Feature::WMCFeature;
require Feature::NOFFeature;
require Feature::Builder;


my $CWD = getcwd();
my $BUILD_DIR = $CWD =~ s/(.*)\/bin/$1/rg;
my $EXTRACT_DIR = "$BUILD_DIR/../extractor";
my $TRAINING_DIR = "$BUILD_DIR/out/training";
mkdir $TRAINING_DIR unless -d $TRAINING_DIR;
my $TESTING_DIR = "$BUILD_DIR/out/testing";
mkdir $TESTING_DIR unless -d $TESTING_DIR;

my $CONFIG_DIR = "$BUILD_DIR/config";

my $configs = Util::ConfigReader->new(configdir => $CONFIG_DIR);
my @featureNames = @{$configs->getFeatures()};

my %featureCreator;
$featureCreator{'Design Smells'} = Feature::DesignSmellFeature->new();
$featureCreator{'Implementation Smells'} = Feature::ImplementationSmellFeature->new();
$featureCreator{'Lines of Code'} = Feature::LOCFeature->new();
$featureCreator{'Number of Fields'} = Feature::NOFFeature->new();
$featureCreator{'Number of Public Fields'} = Feature::NOPFFeature->new();
$featureCreator{'Number of Methods'} = Feature::NOMFeature->new();
$featureCreator{'Number of Public Methods'} = Feature::NOPMFeature->new();
$featureCreator{'Weighted Methods per Class'} = Feature::WMCFeature->new();
$featureCreator{'Number of Children'} = Feature::NCFeature->new();
$featureCreator{'Depth of Inheritance Tree'} = Feature::DITFeature->new();
$featureCreator{'Lack of Cohesion in Methods'} = Feature::LCOMFeature->new();
$featureCreator{'Fan-in'} = Feature::FANINFeature->new();
$featureCreator{'Fan-out'} = Feature::FANOUTFeature->new();
 
my $INPATH = "$EXTRACT_DIR/out";
my $DATASETPATH = "$BUILD_DIR/out/raw";
my $featureBuilder = Feature::Builder->new(inpath => $INPATH, datasetpath => $DATASETPATH);
foreach (@featureNames) {
    $featureBuilder->addFeature($featureCreator{$_});
}

$featureBuilder->getDataset();
