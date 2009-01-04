############################################################
# 	- BotLife.pm v0.1a -
# Written by:
# 	EverlastingFire 
# 		(everlastingfire@autistici.org)
############################################################

# NOTE: This module is strongly commented to explain how to create other modules for the bot.
# Most of the functions are explained better in functions.pm, anyway. ;)

# Keywords registering for the core...
# If the core find a keyword registered, it calls the relative function.
# Each function should be prefixed with ModuleName_ 
# in order to avoid conflicts with other modules

RegisterKey "admlogin", "BotLife_AdmLogin";
RegisterKey "admlogout", "BotLife_AdmLogout";
RegisterKey "admlist", "BotLife_AdminList";
RegisterKey "quit", "BotLife_Quit";

sub BotLife_AdmLogin {
	# The core provides these variables to each function.
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg) = @_;
	# You MUST re-check $Msg, because the core only search for the keywords 
	# and doesn't send parameters to the module
	if($Msg =~ m/^\!login (.+)/){
		if($1 eq $Core::AdminPass){
			# If you need to check if a user is admin, you can use IsAdmin($Nickname)
			# IsAdmin() returns 1 if yes, 0 if not.
			if(IsAdmin $MsgNick){
				SendMsg $MsgNick, $MsgTarget, "You're already logged in!\n";
			} else {
				push @Core::Admins, $MsgNick;
				SendMsg $MsgNick, $MsgTarget, "Okay, you're logged in. Have fun!\n";
			}
		} else {
			SendMsg $MsgNick, $MsgTarget, "Wrong password. Retry. :)\n";
		}
	}
}

sub BotLife_AdmLogout {
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg) = @_;
	my @AdminsTmp;
	if($Msg =~ m/^\!logout/){
		if(IsAdmin $MsgNick){
			for($i = 0; $i < scalar @Core::Admins; $i++){
				if($Core::Admins[$i] ne $MsgNick){
					$AdminsTmp[$i] = $Core::Admins[$i];
				}
			}
			@Core::Admins = @AdminsTmp;
			shift @Core::Admins;
			SendMsg $MsgNick, $MsgTarget, "Okay, you're logged out. See ya!";
		}
		else {
			SendMsg $MsgNick, $MsgTarget, "But... you aren't logged in! o.o";
		}
	}
}

sub BotLife_AdminList {
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg) = @_;
	if($Msg =~ m/^\!adminlist/){
		my $List = join ", ", @Core::Admins;
		SendMsg $MsgNick, $MsgTarget, $List;
	}
}

sub BotLife_Quit {
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg) = @_;
	if(IsAdmin $MsgNick){
		if($Msg =~ /^\!quit/){
			print $Core::IRCHandler "QUIT\n";
			exit(0);
		}
	}
}

1;
