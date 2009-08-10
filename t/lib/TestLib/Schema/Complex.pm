package 
  TestLib::Schema::Complex;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Graph Core));
__PACKAGE__->table("complex");
__PACKAGE__->add_columns(
  "title",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "id",
  {
    data_type => "integer",
    is_nullable => 0
  });

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many("parents" => 'TestLib::Schema::ComplexMap' => "child");

#__PACKAGE__->many_to_many(many_parents => "parents" => "parent");

__PACKAGE__->connect_graph(predecessor => "parents");

1;