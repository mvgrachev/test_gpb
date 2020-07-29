package TestGpb::Controller::Files;
use Mojo::Base 'Mojolicious::Controller';

sub process {
	my $self = shift;

	my $v = $self->validation;
	$v->required('path');
	return $self->render(json => { ststus => 'not ok'} ) if $v->has_error;

	my $id = $self->minion->enqueue(process_file => [$v->param('path')]);
	return $self->render(json => { status => 'not ok'} ) unless my $job = $self->minion->job($id);
	#$job->perform;
	$self->render(json => { status => 'ok', result => $job->info->{result} });
}

