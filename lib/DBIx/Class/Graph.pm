package DBIx::Class::Graph;

use strict;
use warnings;

our $VERSION = '0.05';

use base qw/DBIx::Class/;

__PACKAGE__->mk_classdata("_connect_by");
__PACKAGE__->mk_classdata("_group_rel");
__PACKAGE__->mk_classdata("_graph_foreign_column");
__PACKAGE__->mk_classdata("_group_column");

sub connect_graph {
    my $self = shift;
    my $rel  = shift;
    my $col  = shift;
    if(ref $col eq "HASH") {
        $self->_graph_foreign_column(values %$col);
        ($col) = keys %$col;
    }
    $self->_group_rel($col);
    my ( $primary_col, $too_much ) = $self->primary_columns
      or
      $self->throw_exception( __PACKAGE__ . ' requires a primary key column' );
    $self->throw_exception( __PACKAGE__
          . ' does not support result classes with more than one primary key' )
      if ($too_much);
    $self->throw_exception( q(Syntax for connect_graph is __PACKAGE__->connect_graph( predecessor/successor => 'column/relationship' )))
      unless ( grep { $_ eq $rel } qw(predecessor successor) );
    $self->_connect_by($rel);
    $self->_group_column($col);

    if ( $self->has_column($col) ) {
        $self->belongs_to(
            "_graph_relationship" => $self =>
              { "foreign." . $primary_col => "self." . $col },
            { join_type                   => 'left' }
        );
        $self->_group_rel("_graph_relationship");
    }

    $self->resultset_class('DBIx::Class::ResultSet::Graph')
      unless $self->resultset_class->isa('DBIx::Class::ResultSet::Graph');

}


1;

__END__

=head1 NAME

DBIx::Class::Graph - Represent a graph in a relational database using DBIC

=head1 SYNOPSIS

  package MySchema::Graph;
  
  use base 'DBIx::Class';
  
  __PACKAGE__->load_components("Graph", "Core");
  __PACKAGE__->table("tree");
  __PACKAGE__->add_columns("id", "name", "parent_id");

  __PACKAGE__->connect_graph(predecessor => "parent_id");



  my $g = $rs->graph;
  my @children = $g->successors($rs->get_vertex($id));
  
  # do other cool stuff like calculating distances etc.

=head1 DESCRIPTION

This module allows to create and interact with a directed graph. It will take care of storing the information in a relational database.
It uses L<Graph> for calculations.
This module extends the DBIx::Class::ResultSet. Some methods are added to the resultset, some to the row objects.

=head1 METHODS

=head2 connect_graph(@opt)

The first argument is the relation to the next vertex. Possible values: "predecessor" and "successor"

The name of the relation to the next vertex is defined by the second argument.

=head1 RESULTSET METHODS

=head2 get_vertex($id)

finds a vertex by searching the underlying resultset for C<$id> in the primary key column (only single primary keys are supported). It's not as smart as the original L<DBIx::Class::ResultSet/find> because it looks on the primary key(s) for C<$id> only.

=head1 FAQ

=head2 How do I sort the nodes?

Simply sort the resultset

  $rs->search(undef, {order_by => "title ASC"})->get_graph;

=head1 CAVEATS

=head2 Integrity

It might be possible that some database actions are not recognized by the graph object and thus do not represent the correct status of the graph. To make sure you are working with the correct graph object reload it after editing the graph.
If you see such a behaviour please report it to me.

=head2 Multigraph

you should ommit creating multigraphs. Most graph algorithms expect a simple graph and may break if they get a multigraph.

=head2 Speed

you should consider caching the output of your scripts since retrieving and creating a Graph is not very fast.

=head1 TODO

=over

=item Add support for relationships as connector

This would allow graphs which have multiple parents and multiple children

=head1 SEE ALSO

L<DBIx::Class::Tree>, L<DBIx::Class::NestedSet>

=head1 BUGS

See L</"CAVEATS">

=head1 AUTHOR

Moritz Onken, E<lt>onken@houseofdesign.deE<gt>

I am also avaiable on the DBIx::Class mailinglist

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Moritz Onken

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
