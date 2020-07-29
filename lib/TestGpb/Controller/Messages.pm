package TestGpb::Controller::Messages;
use Mojo::Base 'Mojolicious::Controller';

sub index {
	my $self = shift;
	$self->render(message => $self->messages->all);
}

sub show {
	my $self = shift;
	$self->render(message => $self->messages->find($self->param('id')));
}

1;
