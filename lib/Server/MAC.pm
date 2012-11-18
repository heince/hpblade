package MAC;
use v5.10;
use Mouse;
use strict;
use warnings;
use General;

extends 'General';

sub showmac{
	my $self = shift;
	
	my $cmd =  $self->set_showmac_cmd();
	
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
			my @output = split '\n' => $result;
            for (@output){
            	if(/\bServer Name\b/){
                	print "\n";
                    say;
                }
                if(/([0-9A-F]{2}[:-]){5}([0-9A-F]{2})/i){
                	say;
                }
            }
            print "\n";
		}
	}
}

sub showmac_byenc{
	my $self = shift;
	
	my ($enc) = @_;
	my @encs = split ',' => $enc;
	my $cmd =  $self->set_showmac_cmd();
	
	my $config = $self->getConfigHash();
	for (keys $config){
		for my $blade(keys $$config{$_}){
			my @tmp = grep {/\b$blade\b/} @encs;
			if(@tmp){
				my $ip = $$config{'blades'}{$blade}{'ip'};
				my $username = $$config{'blades'}{$blade}{'user'};
				my $password = $$config{'blades'}{$blade}{'password'};
				my $timeout = $$config{'sshtimeout'} || 5;
				my $port = $$config{'sshport'} || 22;
				
				say "Running $cmd on $ip";
				my $ssh2 = $self->connect_ssh($ip, $username, $password, $port, $timeout);
				
				my $result = $self->exec_ssh_cmd($ssh2, $cmd);
				my @output = split '\n' => $result;
	            for (@output){
	            	if(/\bServer Name\b/){
	                	print "\n";
	                    say;
	                }
	                if(/([0-9A-F]{2}[:-]){5}([0-9A-F]{2})/i){
	                	say;
	                }
				}
			}
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


sub set_showmac_cmd{
	my $self = shift;
	
	my $cmd = "show server info " . $self->get_slot(); 
	return $cmd;
}

1;