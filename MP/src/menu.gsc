CreateMenu()
{
	if(self isVerified())//Verified Menu
	{
		add_menu(self.AIO["menuName"], undefined, self.AIO["menuName"]);
		
			A="A";
			add_option(self.AIO["menuName"], "Main Menu", ::submenu, A, "Main Menu");
				add_menu(A, self.AIO["menuName"], "Main Menu");
					add_option(A, "God Mode", ::InfiniteHealth, true);
					add_option(A, "Debug Exit", ::debugexit);//for testing
					add_option(A, "Test League Stat Edit", ::testLeagueStatsEdit);			
	}
	if(self isVerified())//Verified Menu
	{
			THEME="THEME";
			add_option(self.AIO["menuName"], "Theme Menu", ::submenu, THEME, "Theme Menu");
				add_menu(THEME, self.AIO["menuName"], "Theme Menu");
					add_option(THEME, "^5Default", ::dodefaultpls);
					add_option(THEME, "^4Blue", ::dobluetheme);
					add_option(THEME, "^1Red", ::dopureredtheme);
					add_option(THEME, "^2Green", ::dogreentheme);
					add_option(THEME, "^6Pink", ::dopinktheme);
					add_option(THEME, "^1Demon ^4V6", ::doredtheme);
					add_option(THEME, "^1F^2l^3a^4s^5h^6i^7n^8g", ::stopbitchinghoe);
	}
	if(self.status == "Developer" || self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP")//VIP Menu
	{
			B="B";
			add_option(self.AIO["menuName"], "VIP Menu", ::submenu, B, "VIP Menu");
				add_menu(B, self.AIO["menuName"], "VIP Menu");
					add_option(B, "Not Ready", ::test);
					add_option(B, "Not Ready", ::test);
					add_option(B, "Not Ready", ::test);
					add_option(B, "Not Ready", ::test);
					add_option(B, "Not Ready", ::test);
	}
	if(self.status == "Developer" || self.status == "Host" || self.status == "Co-Host" || self.status == "Admin")//Admin Menu
	{
			C="C";
			add_option(self.AIO["menuName"], "Admin Menu", ::submenu, C, "Admin Menu");
				add_menu(C, self.AIO["menuName"], "Admin Menu");
					add_option(C, "Not Ready", ::test);
					add_option(C, "Not Ready", ::test);
					add_option(C, "Not Ready", ::test);
					add_option(C, "Not Ready", ::test);
	}
	if(self.status == "Developer" || self.status == "Host" || self.status == "Co-Host")//Co-Host Menu
	{
			D="D";
			add_option(self.AIO["menuName"], "Co-Host Menu", ::submenu, D, "Co-Host Menu");
				add_menu(D, self.AIO["menuName"], "Co-Host Menu");
					add_option(D, "Not Ready", ::test);
					add_option(D, "Not Ready", ::test);
					add_option(D, "Not Ready", ::test);
	}
	if(self isHost())//Host only menu
	{
			E="E";
			add_option(self.AIO["menuName"], "Host Menu", ::submenu, E, "Host Menu");
				add_menu(E, self.AIO["menuName"], "Host Menu");
					add_option(E, "Color Name", ::colorname);
					add_option(E, "Not Ready", ::debug_name);
					add_option(E, "Not Ready", ::debug_isDev);
	}
	if(self.status == "Developer" || self.status == "Host" || self.status == "Co-Host")//only co-host has access to the player menu 
	{
			add_option(self.AIO["menuName"], "Client Options", ::submenu, "PlayersMenu", "Client Options");
				add_menu("PlayersMenu", self.AIO["menuName"], "Client Options");
					for (i = 0; i < 18; i++)
					add_menu("pOpt " + i, "PlayersMenu", "");
					
			F="F";
			add_option(self.AIO["menuName"], "All Clients", ::submenu, F, "All Clients");
				add_menu(F, self.AIO["menuName"], "All Clients");
					add_option(F, "Unverify All", ::changeVerificationAllPlayers, "Unverified");
					add_option(F, "Verify All", ::changeVerificationAllPlayers, "Verified");
	}
	if(self isDev())//Developer Only Menu
	{
			DEV="DEV";
			add_option(self.AIO["menuName"], "Developer Menu", ::submenu, DEV, "Developer Menu");
				add_menu(DEV, self.AIO["menuName"], "Developer Menu");
					add_option(DEV, "Change Camo Test", ::camo_change, 10);
					add_option(DEV, "Change Camo Test", ::camo_change, 11);
					add_option(DEV, "Change Camo Test", ::camo_change, 12);
					add_option(DEV, "Change Camo Test", ::camo_change, 13);
					add_option(DEV, "Change Camo Test", ::camo_change, 14);
					add_option(DEV, "Change Camo Test", ::camo_change, 15);
					add_option(DEV, "Change Camo Test", ::camo_change, 16);
					add_option(DEV, "Change Camo Test", ::camo_change, 17);
	}
}

updatePlayersMenu()
{
	self endon("disconnect");
	
	self.menu.menucount["PlayersMenu"] = 0;
	
	for (i = 0; i < 18; i++)
	{
		player = level.players[i];
		playerName = getPlayerName(player);
		playersizefixed = level.players.size - 1;
		
        if(self.menu.curs["PlayersMenu"] > playersizefixed)
        {
            self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
            self.menu.curs["PlayersMenu"] = playersizefixed;
        }
		
		add_option("PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName, ::submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
			add_menu("pOpt " + i, "PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName);
				add_option("pOpt " + i, "Status", ::submenu, "pOpt " + i + "_3", "[" + verificationToColor(player.status) + "^7] " + playerName);
					add_menu("pOpt " + i + "_3", "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
						add_option("pOpt " + i + "_3", "Unverify", ::changeVerificationMenu, player, "Unverified");
						add_option("pOpt " + i + "_3", "^3Verify", ::changeVerificationMenu, player, "Verified");
						add_option("pOpt " + i + "_3", "^4VIP", ::changeVerificationMenu, player, "VIP");
						add_option("pOpt " + i + "_3", "^1Admin", ::changeVerificationMenu, player, "Admin");
						add_option("pOpt " + i + "_3", "^5Co-Host", ::changeVerificationMenu, player, "Co-Host");
						
		if(!player isHost() || player isDev())//makes it so no one can harm the host
		{
				add_option("pOpt " + i, "Options", ::submenu, "pOpt " + i + "_2", "[" + verificationToColor(player.status) + "^7] " + playerName);
					add_menu("pOpt " + i + "_2", "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
						add_option("pOpt " + i + "_2", "Kill Player", ::killPlayer, player);
		}
	}
}

add_menu(Menu, prevmenu, menutitle)
{
    self.menu.getmenu[Menu] = Menu;
    self.menu.scrollerpos[Menu] = 0;
    self.menu.curs[Menu] = 0;
    self.menu.menucount[Menu] = 0;
    self.menu.subtitle[Menu] = menutitle;
    self.menu.previousmenu[Menu] = prevmenu;
}

add_option(Menu, Text, Func, arg1, arg2)
{
    Menu = self.menu.getmenu[Menu];
    Num = self.menu.menucount[Menu];
    self.menu.menuopt[Menu][Num] = Text;
    self.menu.menufunc[Menu][Num] = Func;
    self.menu.menuinput[Menu][Num] = arg1;
    self.menu.menuinput1[Menu][Num] = arg2;
    self.menu.menucount[Menu] += 1;
}

_openMenu()
{
	self.recreateOptions = true;
	self freezeControlsallowlook(false);
	self setClientUiVisibilityFlag("hud_visible", false);
	self enableInvulnerability();//do not remove
	
	self playsoundtoplayer("mpl_flagcapture_sting_friend",self);//opening menu sound
	self showHud();//opening menu effects
    
	self thread StoreText(self.CurMenu, self.CurTitle);
	self updateScrollbar();
	
	self.menu.open = true;
	self.recreateOptions = false;
}

_closeMenu()
{
	self freezeControlsallowlook(false);
	
	//do not remove
	if(!self.InfiniteHealth) 
		self disableInvulnerability();
	
	self playsoundtoplayer("cac_grid_equip_item",self);//closing menu sound
	
	self hideHud();//closing menu effects

	self setClientUiVisibilityFlag("hud_visible", true);
	self.menu.open = false;
}

giveMenu()
{
	if(self isVerified())
	{
		if(!self.MenuInit)
		{
			self.MenuInit = true;
			self thread MenuInit();
		}
	}
}

destroyMenu()
{
	self.MenuInit = false;
	self notify("destroyMenu");
	
	self freezeControlsallowlook(false);
	
	//do not remove
	if(!self.InfiniteHealth) 
		self disableInvulnerability();
	
	if(isDefined(self.AIO["options"]))//do not remove this
	{
		for(i = 0; i < self.AIO["options"].size; i++)
			self.AIO["options"][i] destroy();
	}

	self setClientUiVisibilityFlag("hud_visible", true);
	self.menu.open = false;
	
	wait 0.01;//do not remove this
	//destroys hud elements
	self.AIO["backgroundouter"] destroyElem();
	self.AIO["barclose"] destroyElem();
	self.AIO["background"] destroyElem();
	self.AIO["scrollbar"] destroyElem();
	self.AIO["bartop"] destroyElem();
	self.AIO["barbottom"] destroyElem();
	
	//destroys text elements
	self.AIO["title"] destroy();
	self.AIO["closeText"] destroy();
	self.AIO["status"] destroy();
}

submenu(input, title)
{
	if(!self.isOverflowing)
	{
		if(isDefined(self.AIO["options"]))//do not remove this
		{		
			for(i = 0; i < self.AIO["options"].size; i++)
				self.AIO["options"][i] affectElement("alpha", 0, 0);
		}
		self.AIO["title"] affectElement("alpha", 0, 0);
	}

	if (input == self.AIO["menuName"]) 
		self thread StoreText(input, self.AIO["menuName"]);
	else 
		if (input == "PlayersMenu")
		{
			self updatePlayersMenu();
			self thread StoreText(input, "Client Options");
		}
		else 
			self thread StoreText(input, title);
			
	self.CurMenu = input;
	self.CurTitle = title;
	
	self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
	self.menu.curs[input] = self.menu.scrollerpos[input];
	
	if(!self.isOverflowing)
	{
		if(isDefined(self.AIO["options"]))//do not remove this
		{		
			for(i = 0; i < self.AIO["options"].size; i++)
				self.AIO["options"][i] affectElement("alpha", .2, 1);
		}
		self.AIO["title"] affectElement("alpha", .2, 1);
	}
	
	self updateScrollbar();
	self.isOverflowing = false;
}
