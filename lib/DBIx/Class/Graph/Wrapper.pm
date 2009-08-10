package DBIx::Class::Graph::Wrapper;

use strict;
use warnings;
use Class::C3;

use base qw/Graph/;
use List::MoreUtils qw(uniq);

# $self is an arrayref!

sub _rs {
    my $self = shift;
    if (@_) {
        $self->[6] = $_[0];
    }
    return $self->[6];
}

sub _add_edge {
    my $g = shift;
    my ( $from, $to ) = @_;

    my @e = $g->next::method( $from, $to );
    die "we need two vertices to succeed" if ( @e != 2 );

    if ( $from->has_column( $from->_group_column ) ) {

        # we have no relationship

        $g->delete_edge( $from, $g->successors($from) )
          if ( $from->_connect_by eq "successor"
            && $g->successors($from) );

        $g->delete_edge( $g->predecessors($to), $to )
          if ( $to->_connect_by eq "predecessor"
            && $g->predecessors($to) );

    }

    ( $from, $to ) = ( $to, $from )
      if ( $to->_connect_by eq "predecessor" );

    if ( $from->has_column( $from->_group_column ) ) {
        $from->update( { $from->_group_column => $to->id } )
          unless ( $from->_group_column eq $to->id );
    }
    elsif ( $from->result_source->has_relationship( $from->_group_column ) ) {

        # warn "foobar";
    }
    else {
        warn "foobar";
        my $rel    = $from->_group_rel;
        my $addrel = "add_to_" . $from->_group_rel;
        my $next   = 0;
        for ( $to->$rel->all ) {
            if ( $_->id == $from->id ) {
                $next = 1;
                last;
            }
        }
        unless ($next) {
            $to->$addrel($from);
        }
    }
    return @e;
}

sub delete_edge {
    my $g = shift;
    my ( $from, $to ) = @_;
    $from->throw_exception("need 2 vertices to delete an edge") if ( @_ != 2 );

    my $column = $from->_group_column;

    ( $from, $to ) = ( $to, $from )
      unless ( $from->_connect_by eq "predecessor" );

    if ( $from->has_column($column) ) {
        $to->update( { $from->_group_column => undef } );
    } else {
        my $rel = $from->_group_rel;
        $to->delete_related( $rel,
            { $from->_graph_foreign_column => $from->id } );
    }

    return $g->next::method(@_);
}

sub delete_vertex {
    my $g = shift;
    my $v = shift;
    my @succ;
    if ( $v->_connect_by eq "predecessor" ) {
        @succ = $g->successors($v);
    }
    else {
        @succ = $g->predecessors($v);
    }
    for (@succ) {
        $_->update( { $_->_group_column => undef } );
    }
    my $e = $g->next::method($v);
    $v->delete;
    return $e;
}

sub get_vertex {
    my $self = shift;
    my $id   = shift;
    my @v    = $self->vertices;
    my @cols = $self->_rs->result_source->primary_columns;
    my $pkey = shift @cols;
    for (@v) { return $_ if ( $_->can($pkey) && $_->$pkey eq $id ); }

}

sub all_successors {
    my $g    = shift;
    my @root = @_;
    my @succ;
    my @return;
    foreach my $succ (@root) {
        push( @succ, $g->successors($succ) );
        @succ = uniq @succ;
    }
    foreach my $succ (@succ) {
        push( @succ, $g->successors($succ) );
        @succ = uniq @succ;
    }
    return @succ;
}

sub all_predecessors {
    my $g    = shift;
    my @root = @_;
    my @pred;
    my @return;
    foreach my $pred (@root) {
        push( @pred, $g->predecessors($pred) );
        @pred = uniq @pred;
    }
    foreach my $pred (@pred) {
        push( @pred, $g->predecessors($pred) );
        @pred = uniq @pred;
    }
    return @pred;
}

# Preloaded methods go here.
1;

=head1 NAME

DBIx::Class::Graph::Wrapper - Subclass of L<Graph>

=head1 DESCRIPTION

Inherits from L<Graph> and overloads some methods to store the data to the database.

=head1 SEE ALSO

See L<DBIx::Class::Graph> for details.

=head1 AUTHOR

Moritz Onken, E<lt>onken@houseofdesign.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Moritz Onken

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
