package 
  TestLib::Schema::SimpleSucc;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Graph Core));
__PACKAGE__->table(qw(simple_succ));
__PACKAGE__->add_columns(
    title   => { data_type => "character varying", },
    childid => {
        data_type   => "integer",
        is_nullable => 1,
    },
    id => { data_type => "integer", }
);

__PACKAGE__->set_primary_key(qw(id));

__PACKAGE__->connect_graph( successor => "childid" );

1;
