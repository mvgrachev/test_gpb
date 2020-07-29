package TestGpb;
use Mojo::Base 'Mojolicious';

use TestGpb::Model::Logs;
use TestGpb::Model::Messages;
use TestGpb::Model::Results;

use Mojo::Pg;
use Mojo::Log;

# This method will run once at server start
sub startup {
	my $self = shift;

	# Load configuration
	my $config = $self->plugin(Config => {file => 'test_gpb.conf'});
	$self->secrets($config->{'secrets'});

	#Logger
	$self->helper(log => sub { state $log  = Mojo::Log->new(path => '/var/log/test_gpb.log') });
	
	# Model
	$self->helper(pg => sub { state $pg  = Mojo::Pg->new(shift->config('pg')) });
	$self->helper(logs => sub { state $logs = TestGpb::Model::Logs->new(pg => shift->pg) });
	$self->helper(messages => sub { state $messages = TestGpb::Model::Messages->new(pg => shift->pg) });
	$self->helper(results => sub { state $results = TestGpb::Model::Results->new(pg => shift->pg) });

	# Migrate to latest version if necessary
	my $path = $self->home->child('migrations', 'test_gpb.sql');
	$self->pg->auto_migrate(1)->migrations->name('test_gpb')->from_file($path)->migrate(1);
	
	$self->plugin(Minion => {Pg => $config->{pg}});
	$self->plugin('Minion::Admin');
	$self->plugin('TestGpb::Task::ProcessFile');
  
	# Controller
	my $r = $self->routes;
	$r->get('/' => sub { shift->redirect_to('results') });
	$r->get('/results')->to('results#index');
	$r->get('/search')->to('results#search');
	$r->post('/files')->to('files#process');
	#$r->get('/logs/:id')->to('logs#result')->name('result');
}

1;
