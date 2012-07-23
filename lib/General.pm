package General;

use Mouse;
use v5.10;
use Path::Class;
use strict;
use warnings;

has [ qw \slot encgroup\ ] => (is => 'rw');

sub getConfigHash{
	my $self = shift;
	
	my $configfile = file($ENV{'hpbladecmd'}, 'etc', 'blade.cfg');

	my $conf = new Config::General(
				-ConfigFile => $configfile
			);

	my %config = $conf->getall();
	return \%config;
}

sub getAllBlades{
	my $self = shift;
	
	my $config = $self->getConfigHash();
	for (keys $config){
		for my $blade(keys $$config{$_}){
			say "ip : " . $$config{'blades'}{$blade}{'ip'};
		}
	}
}

sub connect_ssh{
	my $self = shift;
	
	my ($hostname, $user, $password, $port, $timeout) = @_;
	
	use Net::SSH2;
	my $ssh2 = Net::SSH2->new();

  	$ssh2->connect($hostname, $port, Timeout => $timeout) or die $!;
  	
  	if ($ssh2->auth_password($user, $password)) {
		return $ssh2;
  	}else{
  		die "Authentication failed";
  	}
  	
  	return $ssh2;
}

sub exec_ssh_cmd{
	my $self = shift;
	
	my ($ssh2, $cmd) = @_;
	
	my $chan = $ssh2->channel();
	$chan->blocking(1);
    $chan->ext_data('merge');
    $chan->exec($cmd);	
    my $output;
    my $len = $chan->read($output,20480);
      	
    $chan->close();
    $ssh2->disconnect();

    return $output;
}

1;