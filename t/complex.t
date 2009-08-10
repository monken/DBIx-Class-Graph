use Test::More;

use Graph::Convert;

use lib qw(t/lib);

use TestLib;

my $t = new TestLib;

my $schema = $t->get_schema;

my $g = $schema->resultset("Complex")->get_graph();

#$g isa Graph

is(scalar $g->vertices, 6, 'got 6 vertices');
is(scalar $g->edges, 6, 'got 6 edges');

is($g->all_predecessors($g->get_vertex(3)), 1, 'node 3 has one parent');
is($g->all_successors($g->get_vertex(1)), 5, 'node 1 has 5 successors');
is($g->successors($g->get_vertex(1)), 3, 'node 1 has 3 direct childs');
is($g->successors($g->get_vertex(3)), 2, 'node 3 has 2 direct childs');
is($g->successors($g->get_vertex(2)), 1, 'node 2 has 1 direct child');
is($g->predecessors($g->get_vertex(5)), 2, 'node 5 has 2 parents child');

done_testing;