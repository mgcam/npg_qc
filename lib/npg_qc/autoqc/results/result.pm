package npg_qc::autoqc::results::result;

use Moose;
use namespace::autoclean;
use MooseX::AttributeHelpers;
use Carp;

use npg_tracking::util::types;

extends qw( npg_qc::autoqc::results::base );

with qw( npg_tracking::glossary::run
         npg_tracking::glossary::lane
         npg_tracking::glossary::tag );

our $VERSION = '0';
## no critic (Documentation::RequirePodAtEnd)

=head1 NAME

npg_qc::autoqc::results::result

=head1 SYNOPSIS

 use npg_qc::autoqc::results::result;

 my $r = npg_qc::autoqc::results::result
  ->new(id_run => 1934, position => 5);
 $r->pass(1); #set the pass value
 $r->equals_byvalue({id_run => 1934, position => 4,}); #returns false
 $r->equals_byvalue({id_run => 1934, position => 5,}); #returns true
 my $r = npg_qc::autoqc::results::result->load(q[my.json]);
 my $json_string = $r->freeze();

 # Or, via composition

 use npg_tracking::glossary::composition;
 use npg_tracking::glossary::composition::component::illumina;
 use npg_qc::autoqc::results::result;

 my $c1 = npg_tracking::glossary::composition::component::illumina->new(
      id_run => 1, position => 2, tag_index => 3,
    );

 my $composition = npg_tracking::glossary::composition->new(components => [$c1]);
 # (or create_composition, after add_component, via npg_tracking::glossary::composition::factory)
 
 my $r = npg_qc::autoqc::results::result->new(
    composition => $composition
 );

=head1 DESCRIPTION

A base class to wrap the result of autoqc.

=head1 SUBROUTINES/METHODS

=cut

=head2 BUILD

Default object constructor extension that is called after the object is created,
but before it is returned to the caller. Throws an error if an empty composition
has been built by the parent.

=cut
sub BUILD {
  my $self = shift;
  if ($self->composition()->num_components() == 0) {
    confess 'Empty composition is not allowed';
  }
  return;
}

=head2 id_run

An optional run id

=cut
has '+id_run'   => (required => 0,);

=head2 position

An optional lane number. An integer from 1 to 8 inclusive.

=cut
has '+position' => (required => 0,);

=head2 tag_index

An optional tag index

=cut

=head2 pass

Pass or fail or undefined if cannot evaluate

=cut
has 'pass'         => (isa      => 'Maybe[Bool]',
                       is       => 'rw',
                       required => 0,
                      );

=head2 path

An optional path to the input file(s) directory.

=cut
has 'path'        => (isa      => 'Str',
                      is       => 'rw',
                      required => 0,
                     );

=head2 info

To store version number and other information

=cut

has 'info'     => (
      metaclass => 'Collection::Hash',
      is        => 'ro',
      isa       => 'HashRef[Str]',
      default   => sub { {} },
      provides  => {
          exists    => 'exists_in_info',
          keys      => 'ids_in_info',
          get       => 'get_info',
          set       => 'set_info',
      },
);

=head2 comments

A string containing comments, if any.

=cut
has 'comments'     => (isa => 'Maybe[Str]',
                       is => 'rw',
                       required => 0,
                      );

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=over

=item Moose

=item MooseX::AttributeHelpers

=item Carp

=item namespace::autoclean

=item npg_tracking::util::types

=item npg_tracking::glossary::run

=item npg_tracking::glossary::lane

=item npg_tracking::glossary::tag

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
