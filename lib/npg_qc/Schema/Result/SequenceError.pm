
package npg_qc::Schema::Result::SequenceError;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

##no critic(RequirePodAtEnd RequirePodLinksIncludeText ProhibitMagicNumbers ProhibitEmptyQuotes)

=head1 NAME

npg_qc::Schema::Result::SequenceError

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 ADDITIONAL CLASSES USED

=over 4

=item * L<namespace::autoclean>

=back

=cut

use namespace::autoclean;

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::InflateColumn::Serializer>

=back

=cut

__PACKAGE__->load_components('InflateColumn::DateTime', 'InflateColumn::Serializer');

=head1 TABLE: C<sequence_error>

=cut

__PACKAGE__->table('sequence_error');

=head1 ACCESSORS

=head2 id_sequence_error

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 id_run

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 position

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 path

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 forward_read_filename

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 reverse_read_filename

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 forward_aligned_read_count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 forward_errors

  data_type: 'text'
  is_nullable: 1

=head2 forward_count

  data_type: 'text'
  is_nullable: 1

=head2 forward_n_count

  data_type: 'text'
  is_nullable: 1

=head2 reverse_aligned_read_count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 reverse_errors

  data_type: 'text'
  is_nullable: 1

=head2 reverse_count

  data_type: 'text'
  is_nullable: 1

=head2 reverse_n_count

  data_type: 'text'
  is_nullable: 1

=head2 forward_quality_bins

  data_type: 'text'
  is_nullable: 1

=head2 reverse_quality_bins

  data_type: 'text'
  is_nullable: 1

=head2 forward_common_cigars

  data_type: 'text'
  is_nullable: 1

=head2 reverse_common_cigars

  data_type: 'text'
  is_nullable: 1

=head2 forward_cigar_char_count_by_cycle

  data_type: 'text'
  is_nullable: 1

=head2 reverse_cigar_char_count_by_cycle

  data_type: 'text'
  is_nullable: 1

=head2 quality_bin_values

  data_type: 'text'
  is_nullable: 1

=head2 sample_size

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 reference

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 pass

  data_type: 'tinyint'
  is_nullable: 1

=head2 comments

  data_type: 'text'
  is_nullable: 1

=head2 info

  data_type: 'text'
  is_nullable: 1

=head2 tag_index

  data_type: 'bigint'
  default_value: -1
  is_nullable: 0

=head2 sequence_type

  data_type: 'varchar'
  default_value: 'default'
  is_nullable: 0
  size: 25

=cut

__PACKAGE__->add_columns(
  'id_sequence_error',
  {
    data_type => 'bigint',
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  'id_run',
  { data_type => 'bigint', extra => { unsigned => 1 }, is_nullable => 0 },
  'position',
  { data_type => 'tinyint', extra => { unsigned => 1 }, is_nullable => 0 },
  'path',
  { data_type => 'varchar', is_nullable => 1, size => 256 },
  'forward_read_filename',
  { data_type => 'varchar', is_nullable => 1, size => 256 },
  'reverse_read_filename',
  { data_type => 'varchar', is_nullable => 1, size => 256 },
  'forward_aligned_read_count',
  { data_type => 'integer', extra => { unsigned => 1 }, is_nullable => 1 },
  'forward_errors',
  { data_type => 'text', is_nullable => 1 },
  'forward_count',
  { data_type => 'text', is_nullable => 1 },
  'forward_n_count',
  { data_type => 'text', is_nullable => 1 },
  'reverse_aligned_read_count',
  { data_type => 'integer', extra => { unsigned => 1 }, is_nullable => 1 },
  'reverse_errors',
  { data_type => 'text', is_nullable => 1 },
  'reverse_count',
  { data_type => 'text', is_nullable => 1 },
  'reverse_n_count',
  { data_type => 'text', is_nullable => 1 },
  'forward_quality_bins',
  { data_type => 'text', is_nullable => 1 },
  'reverse_quality_bins',
  { data_type => 'text', is_nullable => 1 },
  'forward_common_cigars',
  { data_type => 'text', is_nullable => 1 },
  'reverse_common_cigars',
  { data_type => 'text', is_nullable => 1 },
  'forward_cigar_char_count_by_cycle',
  { data_type => 'text', is_nullable => 1 },
  'reverse_cigar_char_count_by_cycle',
  { data_type => 'text', is_nullable => 1 },
  'quality_bin_values',
  { data_type => 'text', is_nullable => 1 },
  'sample_size',
  { data_type => 'integer', extra => { unsigned => 1 }, is_nullable => 1 },
  'reference',
  { data_type => 'varchar', is_nullable => 1, size => 256 },
  'pass',
  { data_type => 'tinyint', is_nullable => 1 },
  'comments',
  { data_type => 'text', is_nullable => 1 },
  'info',
  { data_type => 'text', is_nullable => 1 },
  'tag_index',
  { data_type => 'bigint', default_value => -1, is_nullable => 0 },
  'sequence_type',
  {
    data_type => 'varchar',
    default_value => 'default',
    is_nullable => 0,
    size => 25,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_sequence_error>

=back

=cut

__PACKAGE__->set_primary_key('id_sequence_error');

=head1 UNIQUE CONSTRAINTS

=head2 C<unq_rlts_sequence_error>

=over 4

=item * L</id_run>

=item * L</position>

=item * L</tag_index>

=item * L</sequence_type>

=back

=cut

__PACKAGE__->add_unique_constraint(
  'unq_rlts_sequence_error',
  ['id_run', 'position', 'tag_index', 'sequence_type'],
);

=head1 L<Moose> ROLES APPLIED

=over 4

=item * L<npg_qc::Schema::Flators>

=item * L<npg_qc::autoqc::role::result>

=item * L<npg_qc::autoqc::role::sequence_error>

=back

=cut


with 'npg_qc::Schema::Flators', 'npg_qc::autoqc::role::result', 'npg_qc::autoqc::role::sequence_error';


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-06-30 15:33:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4gy3WeYAuoDSI1pty9YQhg

__PACKAGE__->set_flators4non_scalar(qw( forward_common_cigars quality_bin_values reverse_common_cigars info ));
__PACKAGE__->set_inflator4scalar('tag_index');
__PACKAGE__->set_inflator4scalar('sequence_type', 'is_string');
__PACKAGE__->set_flators_wcompression4non_scalar( qw(forward_cigar_char_count_by_cycle forward_count forward_errors forward_n_count forward_quality_bins reverse_cigar_char_count_by_cycle reverse_count reverse_errors reverse_n_count reverse_quality_bins) );


our $VERSION = '0';

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

Result class definition in DBIx binding for npg-qc database.

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 SUBROUTINES/METHODS

=head1 DEPENDENCIES

=over

=item strict

=item warnings

=item Moose

=item namespace::autoclean

=item MooseX::NonMoose

=item MooseX::MarkAsMethods

=item DBIx::Class::Core

=item DBIx::Class::InflateColumn::DateTime

=item DBIx::Class::InflateColumn::Serializer

=back

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

Marina Gourtovaia E<lt>mg8@sanger.ac.ukE<gt>

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

