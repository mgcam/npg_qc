use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;
use File::Temp qw/ tempdir /;
use Archive::Extract;
use Perl6::Slurp;

use npg_tracking::glossary::composition::component::illumina;
use npg_tracking::glossary::composition::factory;
use t::autoqc_util qw/ write_samtools_script /;

my $tempdir = tempdir( CLEANUP => 1);
my $archive = '17448_1_9';
my $ae = Archive::Extract->new(archive => "t/data/autoqc/bam_flagstats/${archive}.tar.gz");
$ae->extract(to => $tempdir) or die $ae->error;
$archive = join q[/], $tempdir, $archive;

my $samtools_path  = join q[/], $tempdir, 'samtools1';
local $ENV{'PATH'} = join q[:], $tempdir, $ENV{'PATH'};
# Create mock samtools1 that will output the header
my $header_file = join q[/],$archive,'cram.header';
write_samtools_script($samtools_path, $header_file);

my $file_path_root = join q[/], $archive, '17448_1#9';

use_ok ('npg_qc::autoqc::results::sequence_summary');

subtest 'object with an one-component composition' => sub {
  plan tests => 18;

  throws_ok { npg_qc::autoqc::results::sequence_summary->new(
              file_path_root  => '/some/path/xyts',
              sequence_format => 'bam')
  } qr/Can only build old style results/, 'composition required';

  my $c = npg_tracking::glossary::composition::component::illumina->new(
    id_run => 17448, position => 1, tag_index => 9);
  my $f = npg_tracking::glossary::composition::factory->new();
  $f->add_component($c);
  my $r = npg_qc::autoqc::results::sequence_summary->new(
    composition => $f->create_composition(),
    filename_root   => '17448_1#9',
    sequence_format => 'cram'
  );
  isa_ok ($r, 'npg_qc::autoqc::results::sequence_summary');
  throws_ok { $r->execute() } qr/file_path_root attribute is required/,
    'file_path_root attribute is required';

  $f = npg_tracking::glossary::composition::factory->new();
  $f->add_component($c);
  $r = npg_qc::autoqc::results::sequence_summary->new(
    composition => $f->create_composition(),
    file_path_root  => $file_path_root,
    sequence_format => 'cram',
    filename_root   => '17448_1#9'
  );
  is ($r->num_components, 1, 'one component');
  is ($r->composition_digest(),
    'bfc10d33f4518996db01d1b70ebc17d986684d2e04e20ab072b8b9e51ae73dfa', 'digest');
  is ($r->composition_subset, undef, 'subset undefined');
  lives_ok { $r->execute() } 'execute() method runs successfully';
  is ($r->filename_root, '17448_1#9', 'filename root');
  is ($r->to_string(),
    'npg_qc::autoqc::results::sequence_summary {"components":[{"id_run":17448,"position":1,"tag_index":9}]}',
    'string representation');
  my @header = slurp $header_file;
  my $filter = q[@SQ];
  is ($r->header, join(q[], grep { $_ !~ /\A$filter/ } @header), 'header generated and filtered correctly');

  my $json = $r->freeze();

  my @attrs = qw(sequence_file file_path_root samtools);
  for my $attr ( @attrs ) {
    unlike ($json, qr/$attr/, "serialization des not contain $attr attribute"); 
  }
  lives_ok { $r = npg_qc::autoqc::results::sequence_summary->thaw($json) }
    'object instantiated from JSON string';
  for my $attr ( @attrs ) {
    my $predicate = "_has_$attr";
    lives_and { is $r->$predicate, '' } "$attr is not set";
  }
  lives_ok { $r->freeze() } 'can serialize';
};

subtest 'deserialization: version mismatch supressed' => sub {
   plan tests => 4;
 
  my $json_string = slurp $tempdir .
    '/17448_1_9/qc/all_json/17448_1#9_phix.sequence_summary.json';
  like ($json_string, qr/npg_qc::autoqc::results::sequence_summary-0.0/,
    'expected version');
  like ($json_string, qr/npg_tracking::glossary::composition-3.1.1/,
    'expected version');
  like ($json_string, qr/npg_tracking::glossary::composition::component::illumina-0/,
    'expected version');
  lives_ok { npg_qc::autoqc::results::sequence_summary->thaw($json_string) }
    'version mismatch does not cause an error';
};

1;
