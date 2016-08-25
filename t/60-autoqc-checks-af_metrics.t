use strict;
use warnings;
use Test::More tests => 19;
use Test::Exception;

use_ok ('npg_qc::autoqc::checks::alignment_filter_metrics');

{
  my $af = npg_qc::autoqc::checks::alignment_filter_metrics->new(
    id_run => 2, qc_in => q[t], position => 1);
  isa_ok ($af, 'npg_qc::autoqc::checks::alignment_filter_metrics');
  lives_ok { $af->result; } 'No error creating result object';
}

{
  my @checks = ();
  push @checks, npg_qc::autoqc::checks::alignment_filter_metrics->new(
    id_run => 7880, qc_in => q[t/data/autoqc/af_metrics], position => 1, tag_index => 0);
  push @checks, npg_qc::autoqc::checks::alignment_filter_metrics->new(
    rpt_list => '7880:1:0', qc_in => q[t/data/autoqc/af_metrics]);
  
  foreach my $af (@checks) {
    lives_ok { $af->execute } 'check execution lives';
    is($af->result->info->{Aligner}, 'AlignmentFilter', 'program name');
    ok(!exists $af->result->all_metrics->{programName} ,'program name deleted from all_metrics');
    is($af->result->info->{Aligner_version}, '1.01', 'program version');
    ok(!exists $af->result->all_metrics->{programVersion} ,'program version deleted from all_metrics');
    is($af->result->all_metrics->{totalReads} ,161979, 'total read field stored correctly');
    
    foreach my $ref ( @{$af->result->all_metrics->{refList}} ) {
      is(scalar @{$ref}, 1, 'one record per reference is saved');
    }
  }
}

1;
