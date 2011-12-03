package 
  TestLib::Schema::Simple;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Graph Core));
__PACKAGE__->table(qw(simple));
__PACKAGE__->add_columns(
    title   => { data_type => "character varying", },
    vaterid => {
        data_type   => "integer",
        is_nullable => 1
    },
    id => { data_type => "integer", }
);

__PACKAGE__->set_primary_key(qw(id));

__PACKAGE__->connect_graph( predecessor => "vaterid" );

1;
