package Boot;
use v5.10;
use Mouse;
use strict;
use warnings;
use General;

extends 'General';

has 'type' => (is => 'rw', isa => "Str", default => 'first'); 
has 'device' => (is => 'rw', isa => "Str", default => 'cd');

sub set_bootorder{
	my $self = shift;
	
	my $cmd =  $self->set_bootcmd();
	
	my $config = $self->getConfigHash();
	for (keys $config){
		for my $blade(keys $$config{$_}){
			my $ip = $$config{'blades'}{$blade}{'ip'};
			my $username = $$config{'blades'}{$blade}{'user'};
			my $password = $$config{'blades'}{$blade}{'password'};
			my $timeout = $$config{'sshtimeout'} || 5;
			my $port = $$config{'sshport'} || 22;
			
			say "Running $cmd on $ip";
			my $ssh2 = $self->connect_ssh($ip, $username, $password, $port, $timeout);
			
			my $result = $self->exec_ssh_cmd($ssh2, $cmd);
			map {print} @$result;
		}
	}
}

sub get_slot{
	my $self = shift;
	
	if($self->slot){
		return $self->slot;
	}else{
		return 'all';
	}
}

sub check_valid_device{
	my $self = shift;
	
	my $device = shift;
	
	my @valid = qw \HDD PXE CD FLOPPY USB\;
	my @check = grep {/\b$device\b/i} @valid;
	
	unless(@check){
		say "invalid device, supported device is:"; 
		map{say} @valid;
		exit 1;
	}
}

sub set_bootcmd{
	my $self = shift;
	
	my $cmd = "set server boot " . $self->type . " " . $self->device . " " . $self->get_slot(); 
	return $cmd;
}

1;