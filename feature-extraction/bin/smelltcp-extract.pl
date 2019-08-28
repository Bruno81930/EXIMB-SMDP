#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
use Cwd 'getcwd';
use lib '../lib';
use Time::Progress;
use Try::Tiny;

require Util::ConfigReader;
require Extractor::BugsDotJarExtractor;
require Extractor::Defects4JExtractor;

my $CWD = getcwd();
my $EXTRACT_DIR = $CWD =~ s/(.*)\/bin/$1/rg;
my $OUTPUT_DIR = "$EXTRACT_DIR/out/defects4j";
mkdir $OUTPUT_DIR unless -d $OUTPUT_DIR;
my $CONFIG_DIR = "$EXTRACT_DIR/config";

my $configs = Util::ConfigReader->new(configdir => $CONFIG_DIR);
my @defects4jProjects = @{$configs->getDefects4jProjects()};

my $d4jextractor = Extractor::Defects4JExtractor->new(outpath => $OUTPUT_DIR);

print "Extracting defects4j projects.\n".'='x45 unless $#defects4jProjects == -1; 
foreach my $projectName (@defects4jProjects) {
    my $numberOfBugs = $d4jextractor->getNumberOfBugs($projectName);
    my $counter;
    my $progressBar = new Time::Progress;
    $progressBar->attr(min => 1, max => $numberOfBugs);
    $counter = 1;

    print $progressBar->report("\nExtracting $projectName. (${counter}/$#defects4jProjects)\n");

    for my $bugVersion (1 .. $numberOfBugs) {
        $counter++;
        print $progressBar->report("%45b %p\r", $counter);
        try {
            $d4jextractor->getDefectiveClass($projectName, $bugVersion);
        } catch {
            logError($projectName, $bugVersion, "getDefectiveClass", $_);        };
        try {
            $d4jextractor->extractSmells($projectName, $bugVersion);
        } catch {
            logError($projectName, $bugVersion, "extractSmells", $_);
        };
        $d4jextractor->cleanFiles();
    }
}

my @bugsDotJarProjects = @{$configs->getBugsDotJarProjects()};

my $bugsdotjarextractor = Extractor::BugsDotJarExtractor->new(outpath => $OUTPUT_DIR);

print "Extracting bugsdotjar projects.\n".'='x45 unless $#bugsDotJarProjects == 0;
my $projectCounter = 0;
foreach my $projectName (@bugsDotJarProjects) {
    my $numberOfBugs = $bugsdotjarextractor->getNumberOfBugs($projectName);
    my $counter;
    my $progressBar = new Time::Progress;
    $progressBar->attr(min => 1, max => $numberOfBugs);
    $counter = 1;
    $projectCounter++;
    print $progressBar->report("\nExtracting $projectName. (${projectCounter}/$#bugsDotJarProjects)\n");

    for my $bugVersion (0 .. $numberOfBugs-1) {
        $counter++;
        print $progressBar->report("%45b %p\r", $counter);
        try {
            $bugsdotjarextractor->getDefectiveClass($projectName, $bugVersion);
        } catch {
            logError($projectName, $bugVersion, "getDefectiveClass", $_);        };
        try {
            $bugsdotjarextractor->extractSmells($projectName, $bugVersion);
        } catch {
            logError($projectName, $bugVersion, "extractSmells", $_);
        };
    }
}

sub logError {
    my ($projectName, $bugVersion, $methodName, $error) = @_;
    open my $fh, ">>", "/tmp/log" or die "Error: was not able to open log";
    print $fh "\n".'='x100;
    print $fh "Project: $projectName \n";
    print $fh "Version: $bugVersion \n";
    print $fh "Method: $methodName \n";
    print $fh "Error: $error";
    close $fh;
   
}
