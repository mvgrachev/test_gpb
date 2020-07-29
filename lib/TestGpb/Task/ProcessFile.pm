package TestGpb::Task::ProcessFile;
use Mojo::Base 'Mojolicious::Plugin';

use Archive::Zip qw( :CONSTANTS :ERROR_CODES );

my %flags = (
	'<=' => 1,
	'=>' => 1,
	'->' => 1,
	'==' => 1,
	'**' => 1,
);


sub register {
	my ($self, $app) = @_;
	$app->minion->add_task(process_file => sub {
		my ($job, $path) = @_;
	
		my $zip = Archive::Zip->new( $path );
		my $member = $zip->memberNamed( 'out' );
		my ( $string, $status ) = $member->contents();
		die "error $status" unless $status == AZ_OK;
		foreach my $line ( split /\n/, $string ) {
			chomp $line;
			if ( $line =~ /<=\s+(?!<>\s)/ ) {
				my ($date, $time, $int_id, $flag, $address, $host, $ip, $protocol, $unknown_field, $id) = split /\s/, $line;
				my $datetime = sprintf '%s %s', $date, $time;
				my $str_without_datetime = sprintf '%s %s %s %s %s %s %s %s', $int_id, $flag, $address, $host, $ip, $protocol, $unknown_field, $id;
				$app->messages->add(
					{
						created => $datetime,
						id => $id,
						int_id => $int_id,
						str => $str_without_datetime,
						address => $address
					},
				);
			}
			else {
				my ($date, $time, $int_id, $flag, $address) = split /\s/, $line;
				my $datetime = sprintf '%s %s', $date, $time;
				my $str_without_datetime = $line;
				$str_without_datetime =~ s/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\s//;
				$address = '' unless exists $flags{$flag};
				$app->logs->add(
					{
						created => $datetime,
						int_id => $int_id,
						str => $str_without_datetime,
						address => $address,
					},
				);
			}
			$job->app->log->debug("Insert into db");
		}

		$job->finish('Processed job');
	});

}

1;
