############################################################
# 	- DDBot Core v0.1a -
# Written by:
# 	EverlastingFire 
# 		(everlastingfire@autistici.org)
#
############################################################

use strict;
use IO::Socket;
require "functions.pl";

# Local vars, only for init
my $ModList = "modlist";
my $Config = "config";

# Module loader
print("[*] Loading modules...\n");
open(ModFile, "<$ModList");
while(my $ModName = <ModFile>){
	chomp($ModName);
	print("  - \"$ModName\"... ");
	if(!(-e "modules/$ModName")){
		print("Not found.\n");
	} else { # TODO: Real module loading. (maybe eval+warn for error handling)
		print("Loaded.\n");
	}
}
close(ModFile);

print("[*] Loading complete.\n");

# Config loader - if the file doesn't exist, it asks for the vars and create the file
if(-e $Config){
	print("[*] Configuration file found.\n"); 
	InitVars($Config);
} else {
	print("[*] Configuration file not found.\n");
	Config($Config);
	InitVars($Config);
}

# IRC Connection
while(1){
	$Core::IRCHandler = IO::Socket::INET->new(
		PeerAddr => "$Core::Server",
		PeerPort => '6667',
		Proto => 'tcp',
		Timeout => 10 ) || die "[*] Connection failed.\n";
	$Core::IRCHandler->autoflush();	
	my $IRCState;

	print $Core::IRCHandler "USER $Core::Ident $Core::Ident $Core::Ident $Core::Ident :$Core::Realname\n";
	print $Core::IRCHandler "NICK $Core::Nickname\n";
	print $Core::IRCHandler "JOIN $Core::Chan\n";

	while($Core::CurrentLine = <$Core::IRCHandler> ) {
		my $IRCState = 1;
		if($Core::CurrentLine =~ m/^PING \:(.*)/ ) { print $Core::IRCHandler "PONG :$1"; }
		if($Core::CurrentLine =~ m/^\:(.+?)\!(.+?)\@(.+?) PRIVMSG (.+?) \:(.+)/ ) {
    	    my $MsgNick   = $1;
    	    my $MsgIdent  = $2;
    	    my $MsgHost   = $3;
    	    my $MsgTarget = $4;
    	    my $Msg       = $5;
    	    #parse($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg, $State);
    	}
	}
}
