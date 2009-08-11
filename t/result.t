use Test::More;

use lib qw(t/lib);

use TestLib;

my $t = new TestLib;

my $schema = $t->get_schema;
my $rs = $schema->resultset("Complex");

$rs->graph;

ok($rs->first->all_succesors, 'result has Graph methods');


done_testing;