############################################################
# 	- Players.pm v0.1a -
# Written by:
# 	EverlastingFire 
# 		(everlastingfire@autistici.org)
############################################################

# - Player management ideas -
# 
# Player info are stored in a array of hashes. Example:
# $Players::List[$n]{Name} = "TestPlayer";
# $Players::List[$n]{Level} = 5;
# $Players::List[$n]{Other Info} = ...;
 
# Each player as a sheet file located in players/ subdir, called with his name and
# containing all the sheet info in the format: varname=value\n
# It can be edited manually or through the following functions:
# - Players_NewPlayer() - Creates a new player sheet array
# - Players_Accept() - Confirm the informations and write the player file
# - Players_RemovePlayer() - ADMIN ONLY - Remove a player file
# - Players_Edit() - ADMIN ONLY - Edit a value in $Players::List
# - Players_LoadSheet() - ADMIN ONLY - Load a sheet file and put the player info in %Players::List
# - Players_UnloadSheet() - ADMIN ONLY - Remove the player info from %Players::Listsd
# - Players_SaveData() - ADMIN ONLY - Save the content of $Players::List in sheets file
# Others... (?)

RegisterKey $Lang{it}{NewPlayer}, "Players_NewPlayer";
RegisterKey $Lang{it}{Accpt}, "Players_Accept";

# Roll() should go in dice.pm... when I'll start coding dice.pm. :)
RegisterKey $Lang{it}{Roll}, "Roll";
sub Roll {
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg) = @_;
	if($Msg =~ m/\!$Lang{it}{Roll}/){
		if($Msg =~ m/\!$Lang{it}{Roll} (.+) (.+)/){
			my $Num = $1;
			my $DiceType = $2;
			SendMsg $MsgNick, $MsgTarget, "Debug: \$Num = \"$Num\", \$DiceType = \"$DiceType\"" if($Core::Debug);
			# Check the parameter format...
			if(($Num =~ m/^\d{0,2}$/) && ($DiceType =~ m/^\w(\d{0,2})$/)){
				my $Faces = $1;
				SendMsg $MsgNick, $MsgTarget, "Debug: Faces: $Faces" if($Core::Debug);
				# Dice rolling
				my @Result;
				for (1..$Num){
					my $Res = int(rand($Faces));
					push(@Result, $Res);
				}
				SendMsg $MsgNick, $MsgTarget, join ", ", @Result;
			}
		} else {
			SendMsg $MsgNick, $MsgTarget, $Lang{it}{RollUsage};
		}
	}
}

sub Players_NewPlayer {
	my ($MsgNick, $MsgIdent, $MsgHost, $MsgTarget, $Msg) = @_;
	my @Classes = ($Lang{it}{Warrior});
	my @Races = ($Lang{it}{Human});
	if($Msg =~ /^\!$Lang{it}{NewPlayer}/){
		if($Msg =~ /^\!$Lang{it}{NewPlayer} (.+) (.+)/){
			my $Class = lc $1;
			my $Race = lc $2;
			SendMsg $MsgNick, $MsgTarget, "Debug: Players_NewPlayer called! \$Class: $Class, \$Race: $Race" if($Core::Debug);
			SendMsg $MsgNick, $MsgTarget, "Debug: Classes: " . join(",", @Classes) . ", Races: " . join(",", @Races) if($Core::Debug);
			if((grep { $_ eq $Class } @Classes) && (grep { $_ eq $Race } @Races)){
				SendMsg $MsgNick, $MsgTarget, "Debug: Players_NewPlayer called correctly!" if($Core::Debug);
				SendMsg $MsgNick, $MsgTarget, $Lang{it}{CreatingSheet};
				# We need to roll dice before to continue...
				
			} 
			syswrite STDOUT, "Players_NewPlayer\n" if($Core::Debug);
		} else {
			SendMsg $MsgNick, $MsgTarget, $Lang{it}{NewPlayerUsage};
		}
	}
}
1;
