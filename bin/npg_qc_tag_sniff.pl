#!/usr/bin/env perl
#########
# Author:        nf2
# Created:       18 Nov 2011
#

#########################
# This script checks a bam file's tag sequences
# It should find the observed tags, and map them to tagsets and the expected tags
#########################

use strict;
use warnings;
use Carp;
use Getopt::Long;

our $VERSION = '59.8';

## no critic (NamingConventions::Capitalization)

### revisit these no critics later (kl2 8/11/16)

## no critic (Subroutines::ProhibitExcessComplexity)
## no critic (BuiltinFunctions::ProhibitStringySplit)
## no critic (CodeLayout::ProhibitParensWithBuiltins)
## no critic (ControlStructures::ProhibitCStyleForLoops)
## no critic (ValuesAndExpressions::ProhibitInterpolationOfLiterals)
## no critic (ValuesAndExpressions::ProhibitNoisyQuotes)
## no critic (ControlStructures::ProhibitPostfixControls)
## no critic (ValuesAndExpressions::ProhibitEmptyQuotes)
#######

## no critic (RegularExpressions::ProhibitUnusedCapture RegularExpressions::RequireLineBoundaryMatching RegularExpressions::ProhibitEnumeratedClasses RegularExpressions::RequireDotMatchAnything RegularExpressions::RequireExtendedFormatting)

## no critic (InputOutput::RequireBracedFileHandleWithPrint InputOutput::RequireCheckedSyscalls)

## no critic (BuiltinFunctions::ProhibitReverseSortBlock)

## no critic (Subroutines::RequireArgUnpacking)

sub usage {

  print STDERR "\n";
  print STDERR "samtools view bam_file | npg_qc_tag_sniff.pl [opts]\n";
  print STDERR "\n";
  print STDERR "        --sample_size <int>\n";
  print STDERR "          maximum number of tags to check, default 10000. Use -1 if you want to read the whole file\n";
  print STDERR "\n";
  print STDERR "        --relative_max_drop <int>\n";
  print STDERR "          stop reporting when the drop in tag count relative to the previous tag exceeds this factor, default 10\n";
  print STDERR "\n";
  print STDERR "        --absolute_max_drop <int>\n";
  print STDERR "          stop reporting when the drop in tag count relative to the most common tag exceeds this factor, default 10\n";
  print STDERR "\n";
  print STDERR "        --degenerate_toleration\n";
  print STDERR "          don't stop reporting if a tag is all N, default false\n";
  print STDERR "\n";
  print STDERR "        --tag_length <int>,<int>,.. \n";
  print STDERR "          split tag sequence into parts with the specified langths and look for matches to each part separately, default do not split tag\n";
  print STDERR "          parts are removed in turn, if a value is -ve the next part is taken from the end otherwise it is taken from the beginning\n";
  print STDERR "\n";
  print STDERR "        --clip\n";
  print STDERR "          clip expected_sequence to the length of the tag sequence when looking for matches, default no clipping\n";
  print STDERR "\n";
  print STDERR "        --groups <int>,<int>,..\n";
  print STDERR "          restrict matches to a comma separated set of tag groups, default look for matches in all tag groups\n";
  print STDERR "\n";
  print STDERR "        --help             print this message and quit\n";
  print STDERR "\n";
  print STDERR "\n";
  return;
}

main();
0;

sub selectModeTags {
    my $relativeMaxDrop  = shift;
    my $absoluteMaxDrop = shift;
    my $degeneratingToleration = shift;
    my %tagsFound = @_;
    my $previousCount = 0;
    my $maxCount;
    my @topTags = ();

    foreach my $tag (sort {$tagsFound{$b} <=> $tagsFound{$a};} (keys %tagsFound)) {
      if (!(defined $maxCount)) {
        $maxCount = $tagsFound{$tag};
      }
      if ( (($relativeMaxDrop * $tagsFound{$tag}) < $previousCount) ||
           (($absoluteMaxDrop * $tagsFound{$tag}) < $maxCount)
         ) {
          last;
      }
      $previousCount = $tagsFound{$tag};
      push @topTags,$tag;
      # always report degenerate tags
      if (!$degeneratingToleration && ($tag =~ /^[N:]+$/)) {
          last;
      }
    }
    return @topTags;
}

sub showTags{

## no critic (ValuesAndExpressions::ProhibitNoisyQuotes ValuesAndExpressions::ProhibitInterpolationOfLiterals ValuesAndExpressions::ProhibitMagicNumbers)

    my $ra_topTags = shift;
    my $sampleSize = shift;
    my $clip = shift;
    my $groups = shift;
    my %tagsFound = @_;
    my $unassigned = $sampleSize;

    my $class = 'npg_warehouse::Schema';
    my $loaded = eval "require $class"; ## no critic (BuiltinFunctions::ProhibitStringyEval)
    if (!$loaded) {
      croak q[Can't load module npg_warehouse::Schema];
    }

    my $tag_group_internal_id = ($groups ? [split(",",$groups)] : undef);

    my $s = npg_warehouse::Schema->connect();

    my %matches = ();
    my @groups = ();
    my %names = ();
    foreach my $tag (@{$ra_topTags}) {
        my @subtags = split(":", $tag);
        for (my $i=0; $i<=$#subtags; $i++) {
            my $subtag = $subtags[$i];
            my $expected_sequence = $subtag;
            if ($clip) {
                $expected_sequence = {like => "$subtag%"};
            }
            my $rs;
            if (defined($tag_group_internal_id)) {
                $rs = $s->resultset('Tag')->search({is_current=>1, expected_sequence=>$expected_sequence, tag_group_internal_id=>$tag_group_internal_id});
            } else {
                $rs = $s->resultset('Tag')->search({is_current=>1, expected_sequence=>$expected_sequence});
            }
            while(my $row = $rs->next) {
              my $name = $row->tag_group_name;
              my $id = $row->tag_group_internal_id;
              my $map_id = $row->map_id;
              if (!defined $name || !defined $id || !defined $map_id) {
                next;
              }
              $groups[$i]->{$id}++;
              $names{$id} = $name;
              $matches{$subtag}->{$id} = $map_id;
            }
        }
        $unassigned -= $tagsFound{$tag};
    }
    foreach my $tag (@{$ra_topTags}) {
        printf "%s = %5.2f\t\t", $tag, (100 * $tagsFound{$tag}/$sampleSize);
        my @subtags = split(":", $tag);
        for (my $i=0; $i<=$#subtags; $i++) {
            my $subtag = $subtags[$i];
            foreach my $id (sort {$a<=>$b} keys %{$groups[$i]}) {
                if ( exists($matches{$subtag}->{$id}) ){
                    printf "%2d(%3d) ", $id, $matches{$subtag}->{$id};
                } else {
                    printf q[        ];
                }
            }
            print "\t:\t" if $i < $#subtags;
        }
        print "\n";
    }
    printf "%s = %.2f%s\n", "REMAINDER", (100 * $unassigned/$sampleSize), "%";

    if ( @groups ){
        printf "%-8s\t%-50s\t%s\n", "group id", "group name", "#matches";
        foreach my $id (sort {$a<=>$b} keys %names) {
            printf "%-8d\t%-50s", $id, $names{$id};
            foreach (@groups) {
                printf "\t%-8d", (exists($_->{$id}) ? $_->{$id} : 0);
            }
            printf "\n";
        }
    }

    return;
}

sub main{
    my $opts = initialise();

    my $sampleSize = $opts->{sample_size};
    my $relativeMaxDrop = $opts->{relative_max_drop};
    my $absoluteMaxDrop = $opts->{absolute_max_drop};
    my $degeneratingToleration = $opts->{degenerate_toleration};
    my $tagLength = $opts->{tag_length};
    my $revcomp = $opts->{revcomp};
    my $clip = $opts->{clip};
    my $groups = $opts->{groups};

    my @tagLengths = $tagLength ? split(",",$tagLength) : ();
    my @revcomps = $revcomp ? split(",",$revcomp) : ();

    if  (@tagLengths && @revcomps && ($#tagLengths != $#revcomps)) {
        print {*STDERR} "\nif you specify a list for both tag_length and revcomp they must be the same length\n" or croak 'print failed';
        usage;
        exit 1;
    }

    my $tagsFound = 0;
    my %tagsFound;

    while (<>) {
        if (/((BC:)|(RT:))Z:([A-Z]*)/) {
            my $tag = $4;
##### TESTING ####
            if (@tagLengths) {
                my @subtags = ();
                for(my $i=0; $i<=$#tagLengths; $i++) {
                    my $subtag;
                    if ($tagLengths[$i] < 0) {
                        $subtag = substr $tag, $tagLengths[$i];
                        $tag = substr $tag, 0, $tagLengths[$i];
                    } elsif ($tagLengths[$i]) {
                        $subtag = substr $tag, 0, $tagLengths[$i];
                        $tag = substr $tag, $tagLengths[$i];
                    }
                    if ($revcomps[$i]) {
                        $subtag =~ tr/ACGTN/TGCAN/;
                        $subtag = reverse($subtag);
                    }
                    push(@subtags, $subtag);
                }
                $tag = join(":",@subtags);
            }
#### TESTING ####
            $tagsFound++;
            $tagsFound{$tag}++;
        }
        if ($tagsFound == $sampleSize) {
           last;
        }
    }

    if ($sampleSize != $tagsFound) {
        $sampleSize = $tagsFound;
    }

    my @modeTags = selectModeTags($relativeMaxDrop, $absoluteMaxDrop, $degeneratingToleration, %tagsFound);
    showTags(\@modeTags, $sampleSize, $clip, $groups, %tagsFound);
    return;
}

sub initialise {

## no critic (InputOutput::ProhibitInteractiveTest InputOutput::RequireCheckedSyscalls ValuesAndExpressions::RequireNumberSeparators)

    my %options = (sample_size => 10000, relative_max_drop => 10, absolute_max_drop => 10, degenerate_toleration => 0, tag_length => "", revcomp => "", clip => 0, groups => "");

    my $rc = GetOptions(\%options,
                        'help',
                        'sample_size=i',
                        'relative_max_drop=i',
                        'absolute_max_drop=i',
                        'degenerate_toleration',
                        'tag_length=s',
                        'revcomp=s',
                        'clip',
                        'groups=s',
                        );
    if ( ! $rc) {
        print {*STDERR} "\nerror in command line parameters\n" or croak 'print failed';
        usage;
        exit 1;
    }

    if (-t STDIN) {
        print {*STDERR} "\nyou must supply a sam file on stdin\n" or croak 'print failed';
        usage;
        exit 1;
    }

    if (exists $options{'help'}) {
        usage;
        exit;
    }

    return \%options;

}

__END__

=head1 NAME

tag_sniff.pl

=head1 USAGE
  
  samtools view 5008_1#2.bam | npg_qc_tag_sniff.pl [opts]

=head1 CONFIGURATION

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 REQUIRED ARGUMENTS

=head1 OPTIONS

=head1 EXIT STATUS

=head1 DEPENDENCIES

=over

=item strict

=item warnings

=item Carp

=item Getopt::Long

=item npg_warehouse::Schema

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Nadeem Faruque<lt>nf2@sanger.ac.ukE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2011 GRL, by Nadeem Faruque

This file is part of NPG.

NPG is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut

