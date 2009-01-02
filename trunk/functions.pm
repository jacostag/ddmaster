############################################################
# 	- DDBot v0.1a -
# Written by:
# 	EverlastingFire 
# 		(everlastingfire@autistici.org)
# functions.pm
############################################################

# - InitVars(configfile) - Initialize variables from configuration file
sub InitVars {
	print("[*] Initializing vars...\n");
	my $Config = shift();
	open(ConfigFile, "<$Config");
	my $Line = <ConfigFile>;
	close(ConfigFile);
	chomp($Line);
	my @ConfArray = split(":", $Line);
	$Core::Server = $ConfArray[0];
	$Core::Chan = $ConfArray[1];
	$Core::Nickname = $ConfArray[2];
	$Core::Ident = $ConfArray[3];
	$Core::Realname = $ConfArray[4];
	print("  - Server: $Core::Server\n  - Chan: $Core::Chan\n");
	print("  - Nickname = $Core::Nickname\n  - Ident: $Core::Ident\n");
	print("  - Realname = $Core::Realname\n");
	print("Initialization complete. Starting bot...\n");
}

# - Config(configfile) - First-run configuration
sub Config {
	print("[*] Starting DDBot configuration... \n");
	my $Config = shift();
	print("		-- DDBot configuration --\n");
	print("  Server: ");
	my $Server = <STDIN>;
	chomp($Server);
	print("  Chan: ");
	my $Chan = <STDIN>;
	chomp($Chan);
	print("  Nickname: ");
	my $Nickname = <STDIN>;
	chomp($Nickname);
	print("  Ident: ");
	my $Ident = <STDIN>;
	chomp($Ident);
	print("  Realname: ");
	my $Realname = <STDIN>;
	chomp($Realname);
	open(ConfigFile, ">$Config");
	print(ConfigFile "$Server:$Chan:$Nickname:$Ident:$Realname");
	close(ConfigFile);
	print("Configuration written on $Config.\n");
}

# - SendMsg(type, message, <recipient>) - Send a message. 
# The first parameter is the type of message (query or notice), 
# the second is the message. If the type is "query", there's a third parameter
# to specify, the recipient.
sub SendMsg {
	my $MsgType = shift();
	my ($Msg, $To) = @_;
	if($MsgType eq "query"){
		print $Core::IRCHandler "PRIVMSG $To :$Msg\n";
	}
}

sub RegisterKey {
	my ($Keyword, $Function) = @_;
	$Core::Functions{"$Keyword"} = "$Function";
	print("    - Keyword $Keyword registered.\n");
}

1;
