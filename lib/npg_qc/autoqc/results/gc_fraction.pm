package npg_qc::autoqc::results::gc_fraction;

use Moose;
use namespace::autoclean;
extends qw(npg_qc::autoqc::results::result);
with qw(npg_qc::autoqc::role::gc_fraction);

our $VERSION = '0';

has 'ref_count_path'   => ( isa      => 'Maybe[Str]',
                            required =>  0,
                            is       => 'rw',
		          );

has 'forward_read_filename'     => ( isa      => 'Maybe[Str]',
                                     required => 0,
                                     is       => 'rw',
		                   );


has 'reverse_read_filename'     => ( isa      => 'Maybe[Str]',
                                     required => 0,
                                     is       => 'rw',
		                   );


has 'forward_read_gc_percent'   => ( isa      => 'Maybe[Num]',
                                     required => 0,
                                     is       => 'rw',
		                   );


has 'reverse_read_gc_percent'   => ( isa      => 'Maybe[Num]',
                                     required => 0,
                                     is       => 'rw',
		                   );


has 'ref_gc_percent'           => ( isa      => 'Maybe[Num]',
                                     required => 0,
                                     is       => 'rw',
		                   );


has 'threshold_difference'      => ( isa      => 'Maybe[Int]',
                                     required => 0,
                                     is       => 'rw',
		                   );

__PACKAGE__->meta->make_immutable;

1;

__END__


=head1 NAME

    npg_qc::autoqc::results::gc_fraction

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 SUBROUTINES/METHODS

=head2 forward_read_filename

=head2 reverse_read_filename

=head2 ref_gc_fraction

=head2 forward_read_gc_fraction

=head2 reverse_read_gc_fraction

=head2 ref_count_path

=head2 threshold_difference

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item Moose

=item namespace::autoclean

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Marina Gourtovaia E<lt>mg8@sanger.ac.ukE<gt><gt>

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
