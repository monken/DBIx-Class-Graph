package 
  TestLib::Schema::ComplexMap;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("complex_map");
__PACKAGE__->add_columns(
    'id' => {data_type => 'integer', auto_increment => 1},
  "child",
  {
    data_type => "integer",
    is_nullable => 0,
  },
  "parent",
  {
    data_type => "integer",
    is_nullable => 0
  });

__PACKAGE__->belongs_to("child" => "TestLib::Schema::Complex");
__PACKAGE__->belongs_to("parent" => "TestLib::Schema::Complex");
__PACKAGE__->add_unique_constraint([ qw/child parent/ ]);
__PACKAGE__->set_primary_key('id');
#__PACKAGE__->connect_graph(predecessor => "parent", successor => "child");

1;