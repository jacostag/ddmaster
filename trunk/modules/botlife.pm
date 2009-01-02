# Admin password - Maybe it's better stored in core.pl, temporarily here
$AdminPass = "test";
@Admins;

RegisterKey("login", "BotLife_Login");
#RegisterKey("logout", "BotLife_Logout");
#RegisterKey("adminlist", "BotLife_AdminList");
RegisterKey("quit", "BotLife_Quit");

sub BotLife_Login {
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg) = @_;
	if($Msg =~ m/^\!login (.+)/){
		if($1 eq $AdminPass){
            if(grep{ $_ eq $MsgNick } @Admins){
                SendMsg("query", "You're already logged in!\n", $MsgNick);
            }
            else{
                push(@Admins, $MsgNick);
                SendMsg("query", "Okay, you're logged in. Have fun!\n", $MsgNick);
            }
        } else {
        	SendMsg("query", "Wrong password. Retry. :)\n", $MsgNick);
       	}
	}
}
sub BotLife_Quit {
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg) = @_;
	if($Msg =~ /^\!quit/){
		print $Core::IRCHandler "QUIT\n";
		exit(0);
	}
}

1;
