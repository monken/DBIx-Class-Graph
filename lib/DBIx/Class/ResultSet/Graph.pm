package DBIx::Class::ResultSet::Graph;

use Moose;

use DBIx::Class::Graph::Wrapper;
extends 'DBIx::Class::ResultSet';


has graph => ( is => 'rw', isa => 'DBIx::Class::Graph::Wrapper', lazy_build => 1 );
has _group_rel => ( is => 'rw' );

*get_graph = \&graph; # backwards compat

sub _build_graph {
    my $self = shift;
    my $source = $self->result_class;
    my $rel    = $source->_group_rel;
    my @obj    = $self->search(undef, { prefetch => $source->_group_rel })->all;
    $self->set_cache( \@obj );
    my $g = new DBIx::Class::Graph::Wrapper( refvertexed => 1 );
    $g->_rs($self);

    $g->add_vertex($_) for (@obj);

    foreach my $row (@obj) {
        my ( $from, $to ) = ();
        if ( $row->has_column( $source->_group_column ) ) {
            next
              unless ( my $pre = $row->get_column( $source->_group_column ) );
            ( $from, $to ) =
              ( $g->get_vertex( $row->id ), $g->get_vertex($pre) );
            next unless $from && $to;

            ( $from, $to ) = ( $to, $from )
              if $source->_connect_by eq "predecessor";
            $g->add_edge( $from, $to );
        }
        else {
            foreach my $pre ( $row->$rel->all ) {
                ( $from, $to ) = (
                    $g->get_vertex( $row->id ),
                    $g->get_vertex( $pre->get_column( $source->_graph_foreign_column ) )
                );
                next unless $from && $to;
                ( $from, $to ) = ( $to, $from )
                  if $source->_connect_by eq "predecessor";
                $g->add_edge( $from, $to );

            }
        }

    }
    return $g;
}
1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

DBIx::Class::ResultSet::Graph

=head1 DESCRIPTION

See L<DBIx::Class::Graph>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Moritz Onken

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
