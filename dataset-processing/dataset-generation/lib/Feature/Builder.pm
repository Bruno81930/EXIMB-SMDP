#!/usr/bin/perl

use strict;
use warnings;
use v5.10;

package Feature::Builder;

sub new {
	my ($class, %args) = @_;
    my @features;
    $args{features} = \@features;
	return bless \%args, $class;
}

sub addFeature {
    my ($self, $featureRef) = @_;
    push @{$self->{features}}, $featureRef;
    return \@{$self->{features}};
}

sub getHeader {
    my ($self) = @_;
    my @features = @{$self->{features}};
    my $header = "";
    foreach (@features) {
        my $feature = $_->getHeader();
        $header .= "${feature},";
    }
    return $header =~ /(.*),$/;
}

sub getDatasetInput {
    my ($self, $path) = @_;
    my $classMetricsReference = $self->_getClassMetricsHash($path);
    return $self->_storeInputDatasetToFile($classMetricsReference);
}

sub _getClassMetricsHash {
    my ($self, $path) = @_;
    my $classesReference = $self->_initializeClassesHash($path);
    return $self->_collectMetrics($classesReference, $path);
}

sub _initializeClassesHash {
    my ($self, $path) = @_;
    my @features = @{$self->{features}};
    my %classes;
    foreach my $feature (@features) {
        my $filePath = $path . '/' . $feature->getFile();
        open my $fh, "<", $filePath or die "Error: was not able to open $filePath";
        while( my $line = <$fh>) {
            my $class = $self->_getClass($line);
            $classes{$class} .= "";
        }
        close $fh;
    }
    return \%classes
}

sub _collectMetrics {
    my ($self, $classesReference, $path) = @_;
    my @features = @{$self->{features}};
    my %classes = %{$classesReference};
    
    foreach my $feature (@features) {
        my $filePath = $path . '/' . $feature->getFile();
        open my $fh, "<", $filePath or die "Error: was not able to open $filePath";
        while( my $line = <$fh>) {
            
            my $class = $self->_getClass($line);
            my $metric = $self->_getMetric($line, $feature->getColumn());
            $classes{$class} .= "$metric\$";
        }
        %classes = map {$_ => "$classes{$_},"} keys %classes;
        close $fh;
    }

    return \%classes;
}

sub _getClass {
    my ($self, $line) = @_;
    my $class = $line =~ s/^(.*?),(.*?,.*?),.*$/$2/rg;
    $class = $class =~ s/,/./rg;
    return $class;
}

sub _getMetric {
    my ($self, $line, $featurePosition) = @_;
    my $metrics = $line =~ s/^(.*?,.*?,.*?),(.*)$/$2/rg;
    my @metrics = split(',', $metrics);
    my $metric = $metrics[$featurePosition] =~ s/\R//rg;
    return $metric;
}

sub _storeInputDatasetToFile {
    my ($self, $classMetricsReference) = @_;
    my $filePath = $self->_getFilePath($self->{datasetpath}, "datasetinput.csv"); 
    mkdir $self->{datasetpath} unless -d $self->{datasetpath};  
    return $self->_storeInstances($filePath, $classMetricsReference);
}

sub _getFilePath {
    my ($self, $directory, $fileSuffix) = @_;
    my $fileName = $self->_getHeaderSeparatedBy("_");
    $fileName .= $fileSuffix;
    $fileName = $fileName =~ s/(.*)/\L$1/gr;
    $fileName =~ tr/ //ds;
    my $filePath = $directory."/".$fileName;
    return $filePath;
}

sub _storeInstances {
    my ($self, $filePath, $classMetricsReference) = @_;
    my $fileExists = 0;
    $fileExists = 1 if -e $filePath;
    open my $fh, ">>", $filePath or die "Error: was not able to open $filePath";
    #$self->_storeHeader($fh) if not $fileExists;
    my $classesReference = $self->_storeMetrics($fh, $classMetricsReference);
    close $fh;
    return $classesReference;
}

sub _storeHeader {
    my ($self, $fh) = @_;
    my $header = $self->_getHeaderSeparatedBy(',');
    $header = $self->_removeEndOfLineComma($header);
    print $fh $header."\n";
}   

sub _storeMetrics {
    my ($self, $fh, $classMetricsReference) = @_;
    my %classMetrics = %{$classMetricsReference};
    my @keys = keys %classMetrics;
    foreach (@keys) {
       my $metrics = $self->_removeEndOfLineComma($classMetrics{$_});
       print $fh "${metrics}\n";
    }
    return \@keys;
}

sub _getHeaderSeparatedBy {
    my ($self, $separator) = @_;
    my $header;
    foreach (@{$self->{features}}) {
        $header .= $_->getHeader();
        $header .= $separator;
    }
    return $header;
}

sub _removeEndOfLineComma {
    my ($self, $line) = @_;
    return $line = $line =~ s/(.*),$/$1/gr
}

sub getDatasetOutput {
    my ($self, $classesReference, $path) = @_;
    my $defectiveClassesReference = $self->_getDefectiveClasses("$path/defective.classes");
    my $outputReference = $self->_getOutputArray($classesReference, $defectiveClassesReference);

    $self->_storeOutputDatasetToFile($outputReference);
}

sub _storeOutputDatasetToFile {
    my ($self, $outputReference) = @_;
    my @output = @{$outputReference};

    my $filePath = $self->_getFilePath($self->{datasetpath}, "datasetoutput.csv");
    mkdir $self->{datasetpath} unless -d $self->{datasetpath};
    open my $fh, ">>", $filePath or die "Error: was not able to open $filePath";
    print $fh "$_\n" for @output;

    close $fh;
}

sub _getDefectiveClasses {
    my ($self, $defectivePath) = @_;
    open my $fh, "<", $defectivePath or die "Error: was not able to open $defectivePath";
    my @defectiveClasses = <$fh>; 
    close $fh;
    return \@defectiveClasses;
}

sub _getOutputArray {
    my ($self, $classesReference, $defectiveClassesReference) = @_;
    my @classes = @{$classesReference};
    my @output;
    foreach (@classes) {
        my $isDefective = $self->_isClassDefective($_, $defectiveClassesReference);
        push @output, $isDefective;
    }
    return \@output;
}

sub _isClassDefective {
    my ($self, $class, $defectiveClassesReference) = @_;
    my @defectiveClasses = @{$defectiveClassesReference};
    my $isDefective = 0;
    foreach my $defectiveClass (@defectiveClasses) {
    if ($class eq $defectiveClass) {
        $isDefective = 1;
        }
    }
    return $isDefective;
}

sub _getInputFiles {
    my ($self) = @_;
    my @files;
    opendir (my $dh, $self->{inpath}) or die "Error: was not able to open $self->{inpath}";
    while (my $file = readdir($dh)) {
        push @files, $file;
    }
    closedir($dh);
    @files = grep !/\./, @files;
    @files = grep !/\.\./, @files;
    return \@files;
}

sub getDataset {
    my ($self) = @_;
    my @files = @{$self->_getInputFiles()};
    my $count = 0;
    my $total = $#files;
    my $percentage = -1;
    foreach my $file (@files) {
        $count++;
        my $path = "$self->{inpath}/$file";
        #my @classes = @{$self->getDatasetInput($path)};
        #$self->getDatasetOutput(\@classes, $path);
        $self->getDatasetInputOutput($path);
        if ($percentage < int($count/$total*100)) {
            $percentage = int($count/$total*100);
            local $| = 1;
            print "Progress: $percentage%\r";
        }
        
    }
}

sub getDatasetInputOutput {
    my ($self, $path) = @_;
    my %classMetrics = %{$self->_getClassMetricsHash($path)};
    my $defectiveClassesReference = $self->_getDefectiveClasses("$path/defective.classes");

    my @vars = keys %classMetrics;
    foreach my $class (keys %classMetrics) {
        my $isDefective = $self->_isClassDefective($class, $defectiveClassesReference);
        $classMetrics{$class} .= "$isDefective,"; 
    }

    my $filePath = $self->_getFilePath($self->{datasetpath}, "dataset.csv"); 
    mkdir $self->{datasetpath} unless -d $self->{datasetpath};  
    $self->_storeInstances($filePath, \%classMetrics);
}
1;
