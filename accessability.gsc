verificationToColor(status)
{
    if (status == "Host")
		return "^2Host";
	if (status == "Developer")
		return"^5D^1e^5v^1e^5l^1o^5p^1e^5r";
    if (status == "Co-Host")
		return "^5Co-Host";
    if (status == "Admin")
		return "^1Admin";
    if (status == "VIP")
		return "^4VIP";
    if (status == "Verified")
		return "^3Verified";
    if (status == "Unverified")
		return "None";
}

changeVerificationMenu(player, verlevel)
{
	if (player.status != verlevel && !player == "FantasticLoki")
	{
		if(player isVerified())
		player thread destroyMenu();
		wait 0.03;
		player.status = verlevel;
		wait 0.01;
		
		if(player.status == "Unverified")
		{
			player iPrintln("Your Access Level Has Been Set To None");
			self iprintln("Access Level Has Been Set To None");
		}
		if(player isVerified())
		{
			player giveMenu();
			
			self iprintln("Set Access Level For " + getPlayerName(player) + " To " + verificationToColor(verlevel));
			player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
			player iPrintln("Welcome to "+player.AIO["menuName"]);
		}
	}
	else
	{
		if (player == "FantasticLoki")
			self iprintln("You Cannot Change The Access Level of The " + verificationToColor(player.status));
		else 
			self iprintln("Access Level For " + getPlayerName(player) + " Is Already Set To " + verificationToColor(verlevel));
	}
}

changeVerification(player, verlevel)
{
	if(player isVerified() && !player == "FantasticLoki")
	player thread destroyMenu();
	wait 0.03;
	player.status = verlevel;
	wait 0.01;
	
	if(player.status == "Unverified")
		player iPrintln("Your Access Level Has Been Set To None");
		
	if(player isVerified())
	{
		player giveMenu();
		
		player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
		player iPrintln("Welcome to "+player.AIO["menuName"]);
	}
}

changeVerificationAllPlayers(verlevel)
{
	self iprintln("Access Level For Unverified Clients Has Been Set To " + verificationToColor(verlevel));
	
	foreach(player in level.players) 
		if(!(player.status == "Developer" || player.status == "Host" || player.status == "Co-Host" || player.status == "Admin" || player.status == "VIP")) 
			changeVerification(player, verlevel);
}

getPlayerName(player)
{
    playerName = getSubStr(player.name, 0, player.name.size);
    for(i = 0; i < playerName.size; i++)
    {
		if(playerName[i] == "]")
			break;
    }
    if(playerName.size != i)
		playerName = getSubStr(playerName, i + 1, playerName.size);
		
    return playerName;
}

playerMenuAuth()
{
	/*foreach( player in level.players )
	{*/
		
	//}
}

/*playerMenuAuth()
{
	foreach( player in level.players ) {
	if( player == "FantasticLoki")//Developer Role //Default Role Asignment
		{
			player.status = "Developer";
		}
		else 
		{
			if( player ishost() )//here you can add host players
			{
				player.status = "Host";
			}
			else
			{
				if(player == "MudKippz")// MudKippz as Co-Host
				{
					player.status = "Co-Host";
				}
				else
				{
					player.status = "Unverified";
				}
			}
		}
	}
}*/

isVerified()
{
	if(self.status == "Host" || self.status == "Developer" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified")
		return true;
	else 
		return false;
}

isDev()
{
	if(self.status == "Developer")
		return true;
	else 
		return false;
}