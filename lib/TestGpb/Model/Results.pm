package TestGpb::Model::Results;
use Mojo::Base -base;

has 'pg';

sub find_by_address {
	my ($self, $address) = @_;
	return $self->pg->db->query('select int_id, created, address from message where address = ? union select int_id, created, address from logs where address = ? ORDER BY 1,2', $address, $address)->hashes->to_array;
}

1;
