package 
  TestLib::Schema::Simple;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Graph", "Core");
__PACKAGE__->table("simple");
__PACKAGE__->add_columns(
  "title",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "vaterid",
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

__PACKAGE__->connect_graph(predecessor => "vaterid");

1;