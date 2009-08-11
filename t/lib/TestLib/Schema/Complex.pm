package    # hide
  TestLib::Schema::Complex;

use base 'DBIx::Class';

__PACKAGE__->load_components qw(Graph Core);
__PACKAGE__->table qw(complex);
__PACKAGE__->add_columns(
    title => { data_type => "character varying", },
    id_foo    => { data_type => "integer", }
);

__PACKAGE__->set_primary_key qw(id_foo);

__PACKAGE__->has_many( parents => 'TestLib::Schema::ComplexMap' => "child" );

__PACKAGE__->connect_graph( predecessor => { parents => 'parent' } );

1;
