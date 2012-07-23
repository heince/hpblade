package Bladecmd;

use base qw( CLI::Framework);

use v5.10;
use strict;
use warnings;

sub usage_text {
    # The usage_text() hook in the Application Class is meant to return a
    # usage string describing the whole application.
    my $usage = <<EOF;
cloudcmd <cmd> [--cmd-opt] [cmd-arg]

Display help on each command:
bladecmd.pl <cmd> -h
bladecmd.pl set -h

(commands):
console             run interactively
cmd-list            list available commands
set                 set boot
show                show mac
    
EOF
}

sub option_spec {
    # The option_spec() hook in the Application class provides the option
    # specification for the whole application.
    [ 'help|h'         => 'display help' ],
}

sub validate_options {
    # The validate_options() hook can be used to ensure that the application
    # options are valid.
    my ($self, $opts) = @_;
    die $self->usage_text unless defined $opts or $opts->{'help'};
    
    # ...nothing to check for this application
}

sub command_map {
    
    # In this *list*, the command names given as keys will be bound to the
    # command classes given as values.  This will be used by CLIF as a hash
    # initializer and the command_map_hashref() method will be provided to
    # return a hash created from this list for convenience.
    
    console     => 'CLI::Framework::Command::Console',
    alias       => 'CLI::Framework::Command::Alias',
    'cmd-list'  => 'CLI::Framework::Command::List',
    set			=> 'Bladecmd::Command::Set',
    show		=> 'Bladecmd::Command::Show',
}

sub command_alias {
    # In this list, the keys are aliases to the command names given as values
    # (the values should be found as "keys" in command_map()).
    sh  => 'console',
}

sub init {
    # This initialization is performed once for the application (default
    # behavior).
    my ($self, $opts) = @_;

}
1;
