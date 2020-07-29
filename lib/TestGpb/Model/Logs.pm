package TestGpb::Model::Logs;
use Mojo::Base -base;

has 'pg';

sub add {
	my ($self, $logs) = @_;
	return $self->pg->db->insert('logs', $logs, {returning => 'int_id'})->hash->{int_id};
}

sub all { shift->pg->db->select('logs')->hashes->to_array }

sub find {
	my ($self, $int_id) = @_;
	return $self->pg->db->select('logs', '*', {int_id => $int_id})->hash;
}

sub remove {
	my ($self, $int_id) = @_;
	$self->pg->db->delete('logs', {int_id => $int_id});
}

sub save {
	my ($self, $int_id, $logs) = @_;
	$self->pg->db->update('logs', $logs, {id => $int_id});
}

1;
