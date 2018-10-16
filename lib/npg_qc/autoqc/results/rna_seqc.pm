package npg_qc::autoqc::results::rna_seqc;

use Moose;
use namespace::autoclean;
use Readonly;

extends qw(npg_qc::autoqc::results::result);
with qw(npg_qc::autoqc::role::rna_seqc);

our $VERSION = '0';

Readonly::Array my @ATTRIBUTES => qw/ rrna
                                      rrna_rate
                                      exonic_rate
                                      expression_profiling_efficiency
                                      genes_detected
                                      end_1_sense
                                      end_1_antisense
                                      end_2_sense
                                      end_2_antisense
                                      end_1_pct_sense
                                      end_2_pct_sense
                                      mean_per_base_cov
                                      mean_cv
                                      end_5_norm
                                      end_3_norm
                                      globin_pct_tpm
                                      mt_pct_tpm
                                    /;

has [ @ATTRIBUTES ] => (
    is         => 'rw',
    isa        => 'Num',
    required   => 0,);

has 'other_metrics'  => (isa        => 'HashRef[Str]',
                         is         => 'rw',
                         default => sub { {} },
                         required   => 0,);

has 'rna_seqc_report_path' => (is       => 'rw',
                               isa      => 'Str',
                               required => 0,);

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

npg_qc::autoqc::results::rna_seqc

=head1 SYNOPSIS

=head1 DESCRIPTION

A class for wrapping some of the metrics generated by RNA-SeQC.

=head1 SUBROUTINES/METHODS

=head2 rrna

rRNA reads are non-duplicate and duplicate reads aligning to rRNA
regions as defined in the transcript model definition.

=cut

=head2 rrna_rate

Rate of rRNA per total reads.

=cut

=head2 exonic_rate

Fraction mapping within exons.

=cut

=head2 expression_profiling_efficiency

Ratio of exon reads to total reads.

=cut

=head2 genes_detected

Number of Genes with at least 5 reads.

=cut

=head2 end_1_sense

Number of End 1 reads that were sequenced in the sense direction.

=cut

=head2 end_1_antisense

Number of End 1 reads that were sequenced in the antisense direction.

=cut

=head2 end_2_sense

Number of End 1 reads that were sequenced in the sense direction.

=cut

=head2 end_2_antisense

Number of End 2 reads that were sequenced in the antisense direction.

=cut

=head2 end_1_pct_sense

Percentage of intragenic End 1 reads that were sequenced in the sense
direction.

=cut

=head2 end_2_pct_sense

Percentage of intragenic End 2 reads that were sequenced in the sense
direction.

=cut

=head2 mean_per_base_cov

Mean Per Base Coverage of the middle 1000 expressed transcripts
determined to have the highest expression levels.

=cut

=head2 mean_cv

Mean Coverage of the middle 1000 expressed transcripts determined to
have the highest expression levels.

=cut

=head2 end_5_norm

Norm denotes that the end coverage is divided by the mean coverage
for that transcript.

=cut

=head2 end_3_norm

Norm denotes that the end coverage is divided by the mean coverage
for that transcript.

=cut

=head2 end_5_norm

All remaining RNA-SeQC metrics as a key-values pairs

=cut

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item Moose

=item MooseX::StrictConstructor

=item namespace::autoclean

=item npg_qc::autoqc::results::result

=item Readonly

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Ruben E Bautista-Garcia<lt>rb11@sanger.ac.uk<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2018 Genome Research Limited

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
