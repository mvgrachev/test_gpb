package TestGpb::Controller::Logs;
use Mojo::Base 'Mojolicious::Controller';

sub index {
	my $self = shift;
	$self->render(logs => $self->logs->all);
}

sub show {
	my $self = shift;
	$self->render(logs => $self->logs->find($self->param('id')));
}

1;
