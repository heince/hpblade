#!/usr/bin/env perl

use v5.10;
use Config::General;
use strict;
use warnings;
use Path::Class;

BEGIN{
	#set /User/heince/Project/hpblade-cmd as homedir
	my @dir = ('', 'Users', 'heince', 'Project', 'hpblade-cmd');
	
	my $homedir = dir(@dir);
	my $lib = dir(@dir, 'lib');
	
	#set lib
	push @INC, "$lib";
	
	#set env
	$ENV{'hpbladecmd'} = $homedir;
}

use Bladecmd;

Bladecmd->run();