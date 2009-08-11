use Test::More;

use lib qw(t/lib);

use TestLib;

my $t = new TestLib;

my $schema = $t->get_schema;
my $rs = $schema->resultset("Complex");

my $g = $rs->graph;

my $vertex = $rs->new_result({title => 'foo'});

$g->add_vertex($vertex);
$g->add_edge($vertex, $g->get_vertex(1));

$g = $schema->resultset("Complex")->graph;

is($g->vertices, 7);

$g->add_edge($rs->new_result({title => 'foo'}), $rs->new_result({title => 'bar'}));

is($g->vertices, 9);

$g = $schema->resultset("Complex")->graph;

is($g->vertices, 9);

ok($g->delete_vertex($g->get_vertex(1)));

is($g->vertices, 8);

is($g->edges, 4);

$g = $schema->resultset("Complex")->graph;

is($g->vertices, 8);

is($g->edges, 4);

done_testing;