package 
  TestLib::Schema::SimpleSucc;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("PK::Auto", "Graph", "Core");
__PACKAGE__->table("simple_succ");
__PACKAGE__->add_columns(
  "title",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "childid",
  {
    data_type => "integer",
    is_nullable => 1
  },
  "id",
  {
    data_type => "integer",
    is_nullable => 0
  });

__PACKAGE__->set_primary_key("id");

__PACKAGE__->connect_graph(successor => "childid");

1;