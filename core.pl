############################################################
# 	- DDBot v0.1a -
# Written by:
# 	EverlastingFire 
# 		(everlastingfire@autistici.org)
# core.pl
############################################################

use strict;
use IO::Socket;
require "functions.pl";
%Core::Functions = ('aaa' => 'prova');
# Local vars, only for init
my $ModList = "modlist";
my $Config = "config";
my $ErrLog = "error.log";
my @Errors;

# Module loader
print("[*] Loading modules...\n");
open(ModFile, "<$ModList");
while(my $ModName = <ModFile>){
	chomp($ModName);
	print("  - \"$ModName\"... ");
	if(!(-e "modules/$ModName")){
		print("Not found.\n");
	} else {
		eval{ require "modules/$ModName" };
		if($@){ # Error handling - if a module can't be loaded skip it and push the error in @Errors
			print("Errors. Skipping...\n");
			push(@Errors, "- Module: $ModName -\n---------------------------\n");
			push(@Errors, $@);
			push(@Errors, "---------------------------\n");
		} else {
			print("Loaded.\n");
		}
	}
}
close(ModFile);

# Write the error log
open(ErrFile, ">$ErrLog");
foreach my $ErrLine (@Errors){
	print ErrFile $ErrLine . "\n";
}
close(ErrFile);

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
    	    ParseLine($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg);
    	}
	}
}
# - ParseLine() - Search in %functions if there's a index matching the line
sub ParseLine(){
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg, $State) = @_;
	while(my ($Index, $Value) = each(%Core::Functions)){
		#syswrite STDOUT, ("Index check: $Index\n");
		if($Msg =~ m/$Index/){
			# We need to disable temporarily strict to make this work...
			# Maybe it's better to use only strict 'vars' ?
			no strict;
			#syswrite STDOUT, ("Found index. Calling $Value...\n");
			$Value->();
		}
	}
}