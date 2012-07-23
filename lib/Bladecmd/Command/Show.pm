package Bladecmd::Command::Show;

use base qw( CLI::Framework::Command );
use v5.10;
use strict;
use warnings;

#return usage output
sub usage_text{
    my $usage = <<EOF;
Usage:
bladecmd.pl show [--cmd-opt] [cmd-arg]

available cmd-opt:
-s              => 'set slot number'
-g              => 'set blade enclosure group'         
            
available cmd-arg:
boot

example:
#show blade's NIC mac address
bladecmd.pl show mac

#show slot 1 & 2 blade's NIC mac address
bladecmd.pl show -s 1,2 mac

EOF
}

sub validate{
    my ($self, $cmd_opts, @args) = @_;
    
    if(defined $cmd_opts->{'h'}){
        die $self->usage_text();
    }
    
    if(@args){
        given($args[0]){
            when (/\bmac\b/i){
            	break;
            }
            default{
                die "$_ argument not supported\n";
            }
        }
    }else{
        die $self->usage_text();
    }
}

sub option_spec {
    # The option_spec() hook in the Command Class provides the option
    # specification for a particular command.
    [ 'help|h' => 'help' ],
    [ 's=s'    => 'set slot' ],
    [ 'g=s'	   => 'set enclosure group']
}

sub check_general_opts{
	my ($opts, $obj) = @_;
	
    if(defined $$opts->{'g'}){
        $$obj->encgroup($$opts->{'g'});
    }
}

sub check_mac_opts{
    my ($opts, $obj) = @_;

    if(defined $$opts->{'s'}){
        $$obj->slot($$opts->{'s'});
    }
}

sub run{
	my ($self, $opts, @args) = @_;
   
   my $obj;
   
   given($args[0]){
        when (/\bmac\b/i){
            use Server::MAC;
            
            $obj = MAC->new();
            check_general_opts(\$opts, \$obj);
            check_mac_opts(\$opts, \$obj);
            $obj->showmac();
        }
   }
   
   return;
}

1;