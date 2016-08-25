package npg_qc::autoqc::role::ref_match;

use Moose::Role;
use Readonly;

our $VERSION = '0';

Readonly::Scalar my $PERCENT => 100;

sub percent_count {
    my ($self) = @_;

    my %counts = %{ $self->aligned_read_count() || {} };

    my $sample_size = $self->sample_read_count() || 0;
    return if $sample_size == 0;

    my %percentage;
    foreach my $organism ( keys %counts ) {
        my $value = $PERCENT * ( $counts{$organism} / $sample_size );

        $percentage{$organism} = sprintf '%.1f', $value;
    }

    return \%percentage;
}

sub ranked_organisms {
    my ($self) = @_;

    my %rating = %{ $self->percent_count() || {} };

    my @ranked_organisms =
        reverse sort { $rating{$a} <=> $rating{$b} } keys %rating;

    return \@ranked_organisms;
}


no Moose;

1;

__END__


=head1 NAME

    npg_qc::autoqc::role::ref_match

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 percent_count

Calculate a rating value for each organism. Right now that value is the
percentage of sampled reads aligning to the organism's reference genome.

=head2 ranked_organisms

Sort the organisms represented in the reference sequence by descending order
of their normalised contamination values. Return this list as an array
reference.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item Moose::Role

=item Readonly

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

John O'Brien E<lt>jo3@sanger.ac.ukE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2016 GRL

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
