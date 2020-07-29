package TestGpb::Model::Messages;
use Mojo::Base -base;

has 'pg';

sub add {
	my ($self, $messages) = @_;
	return $self->pg->db->insert('message', $messages, {returning => 'id'})->hash->{id};
}

sub all { shift->pg->db->select('message')->hashes->to_array }

sub find {
	my ($self, $id) = @_;
	return $self->pg->db->select('message', '*', {id => $id})->hash;
}

sub remove {
	my ($self, $id) = @_;
	$self->pg->db->delete('message', {id => $id});
}

sub save {
	my ($self, $id, $messages) = @_;
	$self->pg->db->update('message', $messages, {id => $id});
}

1;
