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
# - Players_Edit() - ADMIN ONLY - Edit a value in a player's sheet file
# - Players_LoadSheet() - ADMIN ONLY - Load a sheet file and put the player info in %Players::List
# - Players_UnloadSheet() - ADMIN ONLY - Remove the player info from %Players::List
# Others... (?)
