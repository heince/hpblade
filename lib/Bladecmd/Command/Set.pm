package Bladecmd::Command::Set;

use base qw( CLI::Framework::Command );
use v5.10;
use strict;
use warnings;

#return usage output
sub usage_text{
    my $usage = <<EOF;
Usage:
bladecmd.pl set [--cmd-opt] [cmd-arg]

available cmd-opt:
-s              => 'set slot number'
--once          => 'set only one time boot'  
-d              => 'set device' 
-g              => 'set blade enclosure group'         
            
available cmd-arg:
boot

example:
#set all blade first boot to pxe
bladecmd.pl set -d pxe boot

#set slot 1, 2 & 3 boot once to cd
bladecmd.pl set -s 1,2,3 --once -d cd boot

EOF
}

sub validate{
    my ($self, $cmd_opts, @args) = @_;
    
    if(defined $cmd_opts->{'h'}){
        die $self->usage_text();
    }
    
    if(@args){
        given($args[0]){
            when (/\bboot\b/i){
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
    [ 'once'   => ' set once' ],
    [ 'd=s'	   => 'set device'],
    [ 'g=s'	   => 'set enclosure group']
}

sub check_general_opts{
	my ($opts, $obj) = @_;
	
    if(defined $$opts->{'g'}){
        $$obj->encgroup($$opts->{'g'});
    }
}

sub check_boot_opts{
    my ($opts, $obj) = @_;

    if(defined $$opts->{'s'}){
        $$obj->slot($$opts->{'s'});
    }
    if(defined $$opts->{'d'}){
    	$$obj->check_valid_device($$opts->{'d'});
        $$obj->device($$opts->{'d'});
    }
    if(defined $$opts->{'once'}){
        $$obj->type('once');
    }
}

sub run{
	my ($self, $opts, @args) = @_;
   
   my $obj;
   
   given($args[0]){
        when (/\bboot\b/i){
            use Server::Boot;
            
            $obj = Boot->new();
            check_general_opts(\$opts, \$obj);
            check_boot_opts(\$opts, \$obj);
            $obj->set_bootorder();
        }
   }
   
   return;
}

1;