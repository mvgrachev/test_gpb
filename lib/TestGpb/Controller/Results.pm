package TestGpb::Controller::Results;
use Mojo::Base 'Mojolicious::Controller';

sub index {
	my $self = shift;
	$self->render(results => [], alert => 0);
}

sub search {
	my $self = shift;
	my $results = $self->results->find_by_address($self->param('address'));
	my $alert = 0;
	if ( scalar @{$results} > 100 ) {
		@{$results} = splice @{$results}, 0, 100;
		$alert = 1;
	}
	$self->render(results => $results, alert => $alert);
}

1;
