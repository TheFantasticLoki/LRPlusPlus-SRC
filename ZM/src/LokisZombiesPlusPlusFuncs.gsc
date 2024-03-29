
LokisZombiesPlusPlus()//Loki's Zombies ++ Initialization Func
{
	level endon( "LRZ_Trigger_Disable" );
	setDvar("revive_trigger_radius", "125");//Additional Perk Tweaks
    setDvar("jump_height", "45");
    setDvar("player_breath_hold_time", "10");
	setDvar("perk_sprintMultiplier", "2.25");
    setDvar("player_meleeRange", "80");
	level.zombie_vars["zombie_powerup_drop_max_per_round"] = 8;
	self.flopp = 1;
	level.zombie_ai_limit = 32;
	level.zombie_actor_limit = 32;
	level.claymores_max_per_player = 64;
	if( getdvar( "mapname" ) == "zm_transit" || getdvar( "mapname" ) == "zm_town")//Remove Fog on Tranzit
    {
    	setDvar("r_fog", "0");
    }
}

init_LRZ_Dvars()
{
	create_dvar("LRZ_PerkLimit", "4");
	create_dvar("LRZ_ZPP_enabled", "1");
}

LRZ_Visual_Settings()
{
	foreach( player in level.players )
	{
		setDvar("r_dof_enable", 0);
		setDvar("r_dof_tweak", 1);
		setDvar("r_dof_nearStart", 1);
		setDvar("r_dof_nearEnd", 25);
		setDvar("r_dof_nearBlur", 4);
		setDvar("r_dof_farStart", 1800);
		setDvar("r_dof_farEnd", 20000);
		setDvar("r_dof_farBlur", 1.2);
		setDvar("r_dof_viewModelEnd", 2);
		setDvar("r_dof_viewModelStart", 1);
		setDvar("r_bloomHiQuality", 1);
		setDvar("r_bloomTweaks", 1);
		self setClientDvar("r_dof_enable", 0);
		self setClientDvar("r_dof_tweak", 1);
		self setClientDvar("r_dof_nearStart", 1);
		self setClientDvar("r_dof_nearEnd", 25);
		self setClientDvar("r_dof_nearBlur", 4);
		self setClientDvar("r_dof_farStart", 1800);
		self setClientDvar("r_dof_farEnd", 20000);
		self setClientDvar("r_dof_farBlur", 1.2);
		self setClientDvar("r_dof_viewModelEnd", 2);
		self setClientDvar("r_dof_viewModelStart", 1);
		self setClientDvar("r_bloomHiQuality", 1);
		self setClientDvar("r_bloomTweaks", 1);
		wait 0.05;
	}
}

remove_perk_limit()
{
    //level waittill( "start_of_round" );
	setDvar("LRZ_PerkLimit", "9");
    level.perk_purchase_limit = getDvarInt("LRZ_PerkLimit");
	//level.perk_purchase_limit = 9;
}

Lokis_Blessings()
{
	self.Blessing1Triggered = "0";
	self.Blessing2Triggered = "0";
	for(;;)
	{
		level waittill("start_of_round");
		level endon( "LRZ_Trigger_Disable" );
		while( self.Blessing1Triggered == "0" )
		{
			if( level.round_number > 14 && level.round_number < 25 )
			{
				self LRZ_Big_Msg("^3LZ++: ^7Good job on reaching round 15 have some blessings!");
				foreach( player in level.players )
				{
					player.score = player.score + 5000;
				}
				wait 0.05;
				self.Blessing1Triggered = "1";
			}
			wait 0.05;
			break;
		}
		while( self.Blessing2Triggered == "0" )
		{
			if( level.round_number > 24 )
			{
				self LRZ_Big_Msg("^3LZ++: ^7Good job on reaching round 25 have some blessings and Good Luck Challengers!");
				foreach( player in level.players )
				{
					player.score = player.score + 10000;
					player thread drinkallperks();
				}
				wait 0.05;
				self.Blessing2Triggered = "1";
			}
			wait 0.05;
			break;
		}
		wait 0.05;
	}
}

healthCounter ()
{
	for(;;)
	{
		self endon ("disconnect");
		self endon ("stop_HealthCounter");
		level endon( "end_game" );
		common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
		self.healthText1 = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1.5);
		self.healthText1 maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", 100, 180);
		while ( 1 )
		{
			self.healthText1.label = &"Health: ^2";
			self.healthText1 setValue(self.health);
			wait 0.25;
		}
		wait 0.05;
	}
}

zombieCounter()
{
	for(;;)
	{
		self endon( "disconnect" );
		self endon("stop_ZombieCounter");
		level endon( "end_game" );
		common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
    	self.zombieText = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    	self.zombieText maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", -100, 180 );
    	while( 1 )
    	{
    	    self.zombieText setValue( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
    	    if( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) != 0 )
    	    {
    	    	self.zombieText.label = &"Zombies: ^1";
    	    }
    	    else
    	    {
    	    	self.zombieText.label = &"Zombies: ^6";
    	    }
    	    wait 0.25;
    	}
		wait 0.05;
	}
}

Define_Loki_CrossSize( size )
{
	create_dvar( "Loki_CrossSize", size );
	if( isDvarAllowed( "Loki_CrossSize" ) )
	{
		level.Loki_CrossSize = getDvarInt( "Loki_CrossSize" );
		self thread Loki_CrossSize();
		level notify("Trigger_Loki_CrossSize");
		while( 1 )
		{
			if( level.Loki_CrossSize != getDvarInt( "Loki_CrossSize" ) )
			{
				level.Loki_CrossSize = getDvarInt( "Loki_CrossSize" );
				self setClientDvar("Loki_CrossSize", getDvarInt("Loki_CrossSize"));
				wait 0.05;
				level notify("Trigger_Loki_CrossSize");
			}
			foreach( player in level.players )
			{
			if( level.Loki_CrossSize != getDvarInt( "Loki_CrossSize" ) )
			{
				level.Loki_CrossSize = getDvarInt( "Loki_CrossSize" );
				self setClientDvar("Loki_CrossSize", getDvarInt("Loki_CrossSize"));
				wait 0.05;
				level notify("Trigger_Loki_CrossSize");
			}
			}
			wait 0.5;
		}
	}
}

Loki_CrossSize()
{
	while(1)
	{
		if( self.name == "FantasticLoki")
		{
			level waittill("Trigger_Loki_CrossSize");
			self setSpreadOverride( level.Loki_CrossSize );
			//player setSpreadOverride( level.Loki_CrossSize );
			wait 0.05;
		}
		wait 0.05;
	}

}

Loki_CrossSize_up()
{
	level.Loki_CrossSize = level.Loki_CrossSize + 1;
	setDvar("Loki_CrossSize", level.Loki_CrossSize);
	level notify("Trigger_Loki_CrossSize");
	self iprintlnbold( "CrossSize Set To ^1" + ( level.Loki_CrossSize + "" ) );
	wait 0.5;

}

Loki_CrossSize_down()
{
	level.Loki_CrossSize = level.Loki_CrossSize - 1;
	setDvar("Loki_CrossSize", level.Loki_CrossSize);
	level notify("Trigger_Loki_CrossSize");
	self iprintlnbold( "CrossSize Set To ^1" + ( level.Loki_CrossSize + "" ) );
	wait 0.5;

}

VIP_Check()
{
	switch(self.name)
	{
		case "FantasticLoki":
			self.vip_status = "Developer";
			break;
		case "MudKippz":
			self.vip_status = "Friend";
			break;
		case "Sorex":
			self.vip_status = "Contributor";
			break;
		default:
			self.vip_status = "notvip";
			break;
	}
	wait 0.05;
}

VIP_Funcs()
{
	player = level.players;
	if( self.vip_status == "Developer" )
	{
		//self waittill( "spawned_player" );
		self create_dvar("Sys_LRZ_P_" + self.guid + "_VIP_Status", self.vip_status);
		//self create_dvar("Sys_LRZ_P_VIP_Status", self.vip_status);
		self.status = "Developer";
		//self LRZ_Bold_Msg("^3Welcome ^7[^5D^1E^5V^7] ^1" + self.name + "");
		self LRZ_Bold_Msg("Welcome [" + verificationtocolor( player.status ) + "]" + self.name + " \n^1LR++ Features some of your code! ^3Thanks for your contribution!");
		self.score = self.score + 1000;
		self thread Loki_Binds();
		self thread set_persistent_stats();
		self setperk( "specialty_fastmantle" );
		self setperk( "specialty_fastladderclimb" );
		self thread LRZ_Perma_Deadshot();
		self thread Loki_CrossSize();
		//self thread watch_for_cluster_grenade_throw();
	}
	if( self.vip_status == "Contributor")
	{
		self.status = "Co-Host";
		self.score = self.score + 2000;
		self LRZ_Bold_Msg("Welcome [" + verificationtocolor( player.status ) + "]" + self.name + " \n^1LR++ Features some of your code! ^3Thanks for your contribution!");
	}
	if( self.vip_status == "Friend" )
	{
		self.status = "Admin";
		self.score = self.score + 1000;
		if( self.name == "MudKippz" )
			self LRZ_Bold_Msg("Welcome Mudkippz, <3 Loki");
		else
			self LRZ_Bold_Msg("Welcome [" + verificationtocolor( player.status ) + "]" + self.name + "");
	}
	if( self.vip_status == "VIP++")
	{
		self.status = "VIP++";
		self.score = self.score + 750;
		self LRZ_Bold_Msg("Welcome [" + verificationtocolor( player.status ) + "]" + self.name + "");
	}
	if( self.vip_status == "VIP+" )
	{
		self.status = "VIP+";
		self.score = self.score + 500;
		self LRZ_Bold_Msg("Welcome [" + verificationtocolor( player.status ) + "]" + self.name + "");
	}
	if( self.vip_status == "VIP" )
	{
		self.status = "VIP";
		self.score = self.score + 250;
		self LRZ_Bold_Msg("Welcome [" + verificationtocolor( player.status ) + "]" + self.name + "");
	}
	if( self.vip_status == "notvip" )
	{
		self.status = "Player";
	}
	wait 0.05;
}

Loki_Binds()
{
	for(;;)
	{
		while( self usebuttonpressed() )
		{
			if( self actionslottwobuttonpressed() )
			{
				self.score = self.score + 1000;
				wait 0.05;
			}
			if( self actionslotonebuttonpressed() )
			{
				self camo_change(39);
				wait 0.05;
			}
			wait 0.05;
		}
		wait 0.1;
	}
}

LRZ_Menu_Options_Toggle_LRZ()
{
	if(self.LRZPlusPlus == 0)
    {
        self iprintln("LRZ++: ^2On");
        level notify("LRZ_Trigger_Enable");
        self.LRZPlusPlus = 1;
    }
    else
    {
        self iprintln("LRZ++: ^1Off");
        level notify("LRZ_Trigger_Disable");
        self.LRZPlusPlus = 0;
    }
}

Progressive_Perks()
{
	for(;;)
	{
		level waittill("start_of_round");
		level endon( "END_LRZ_Progressive_Perks" );
		level endon( "LRZ_Trigger_Disable" );
		if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("perk_weapRateMultiplier", "0.75");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("perk_weapRateMultiplier", "0.7");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("perk_weapRateMultiplier", "0.65");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("perk_weapRateMultiplier", "0.6");
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("perk_weapRateMultiplier", "0.55");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("perk_weapRateMultiplier", "0.5");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("perk_weapRateMultiplier", "0.45");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("perk_weapRateMultiplier", "0.4");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("perk_weapRateMultiplier", "0.35");
		}
		if( level.round_number >=81 )
		{
			setDvar("perk_weapRateMultiplier", "0.3");
		}
    	if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("perk_weapReloadMultiplier", "0.5");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("perk_weapReloadMultiplier", "0.45");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("perk_weapReloadMultiplier", "0.4");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("perk_weapReloadMultiplier", "0.375");
			
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("perk_weapReloadMultiplier", "0.35");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("perk_weapReloadMultiplier", "0.325");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("perk_weapReloadMultiplier", "0.3");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("perk_weapReloadMultiplier", "0.25");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("perk_weapReloadMultiplier", "0.2");
		}
		if( level.round_number >=81 )
		{
			setDvar("perk_weapReloadMultiplier", "0.15");
		}
		if( getdvar( "mapname" ) == "zm_prison" || getdvar( "mapname" ) == "zm_tomb" )
		{
    	    if( level.round_number >=1 && level.round_number <=10 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.65");
			}
			if( level.round_number >=11 && level.round_number <=15 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.55");
			}
			if( level.round_number >=16 && level.round_number <=20 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.475");
			}
			if( level.round_number >=21 && level.round_number <=29 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.40");
			}
			if( level.round_number >=30 && level.round_number <=35 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.35");
			}
			if( level.round_number >=36 && level.round_number <=45 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.325");
			}
			if( level.round_number >=46 && level.round_number <=52 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.3");
			}
			if( level.round_number >=53 && level.round_number <=60 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.275");
			}
			if( level.round_number >=61 && level.round_number <=80 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.25");
			}
			if( level.round_number >=81 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.2");
			}
		}
		if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("player_clipSizeMultiplier", "1.0");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("player_clipSizeMultiplier", "1.1");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("player_clipSizeMultiplier", "1.25");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("player_clipSizeMultiplier", "1.5");
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("player_clipSizeMultiplier", "1.75");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("player_clipSizeMultiplier", "2.0");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("player_clipSizeMultiplier", "2.25");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("player_clipSizeMultiplier", "2.5");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("player_clipSizeMultiplier", "2.75");
		}
		if( level.round_number >=81 )
		{
			setDvar("player_clipSizeMultiplier", "3.0");
		}
    	if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("player_lastStandBleedoutTime", "45");
		}
		if( level.round_number >=11 && level.round_number <=20 )
		{
			setDvar("player_lastStandBleedoutTime", "60");
		}
		if( level.round_number >=21 && level.round_number <=35 )
		{
			setDvar("player_lastStandBleedoutTime", "90");
		}
		if( level.round_number >=36 && level.round_number <=50 )
		{
			setDvar("player_lastStandBleedoutTime", "120");
		}
		if( level.round_number >=51 && level.round_number <=100 )
		{
			setDvar("player_lastStandBleedoutTime", "240");
		}
		if( level.round_number >=101 )
		{
			setDvar("player_lastStandBleedoutTime", "360");
		}
		wait 0.05;
    }
}

Progressive_Perks_Alerts()
{
	if( level.LRZ_Progressive_Perks )
	{
	self.rc1 = "0";
	self.rc2 = "0";
	self.rc3 = "0";
	self.rc4 = "0";
	self.rc5 = "0";
	self.rc6 = "0";
	self.rc7 = "0";
	self.rc8 = "0";
	self.rc9 = "0";
	self.rc10 = "0";
	self.rc11 = "0";
	self.rc12 = "0";
	self.rc13 = "0";
	self.rc14 = "0";
	for(;;)
	{
		level waittill("start_of_round");
		
		while(self.rc == "0")
		{
			if( level.round_number >=11 && level.round_number <=15 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.07x");
					wait 0.5; 
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.11x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.18x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 1.1x");
				}
				wait 0.05;
				self.rc = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc2 == "0")
		{
			if( level.round_number >=16 && level.round_number <=20 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.15x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.25x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.36x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 1.25x");
				}
				wait 0.05;
				self.rc2 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc3 == "0")
		{
			if( level.round_number >=21 && level.round_number <=29 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.25x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.33x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.625x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 1.5x");
				}
				wait 0.05;
				self.rc3 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc4 == "0")
		{
			if( level.round_number >=30 && level.round_number <=35 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.36x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.43x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.85x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 1.75x");
				}
				wait 0.05;
				self.rc4 = "1";
			}
			wait 0.05;
			break;
		}	
		while(self.rc5 == "0")
		{
			if( level.round_number >=36 && level.round_number <=45 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.5x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.54x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 2x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 2x");
				}
				wait 0.05;
				self.rc5 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc6 == "0")
		{
			if( level.round_number >=46 && level.round_number <=52 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.66x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.66x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 2.16x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 2.25x");
				}
				wait 0.05;
				self.rc6 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc7 == "0")
		{
			if( level.round_number >=53 && level.round_number <=60 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.875x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 2x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 2.36x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 2.5x");
				}
				wait 0.05;
				self.rc7 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc8 == "0")
		{
			if( level.round_number >=61 && level.round_number <=80 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 2.14x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 2.5x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 2.6x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 2.75x");
				}
				wait 0.05;
				self.rc8 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc9 == "0")
		{
			if( level.round_number >=81 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 2.5x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 3.33x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 3.25x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 3x");
				}
				wait 0.05;
				self.rc9 = "1";
			}
			wait 0.05;
			break;
		}

		while(self.rc10 == "0")
		{
			if( level.round_number >=11 && level.round_number <=20 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 1 minute.");
				}
				wait 0.05;
				self.rc10 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc11 == "0")
		{
			if( level.round_number >=21 && level.round_number <=35 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 1 minute 30 seconds.");
				}
				wait 0.05;
				self.rc11 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc12 == "0")
		{
			if( level.round_number >=36 && level.round_number <=50 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 2 minutes.");
				}
				wait 0.05;
				self.rc12 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc13 == "0")
		{
			if( level.round_number >=51 && level.round_number <=100 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 4 minutes.");
				}
				wait 0.05;
				self.rc13 = "1";
			}
			wait 0.05;
			break;
		}
		while(self.rc14 == "0")
		{
			if( level.round_number >=101 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 6 minutes.");
				}
				wait 0.05;
				self.rc14 = "1";
			}
			wait 0.05;
			break;
		}
		wait 0.05;
	}
	wait 0.05;
    }
}
/*
Progressive_Perks()
{

}

Progressive_Perks_Alerts()
{

}
*/
camo_change( value )
{
	weapon = self getcurrentweapon();
	self takeweapon( weapon );
	self giveweapon( weapon, 0, self calcweaponoptions( value, 0, 0, 0 ) );
	self givestartammo( weapon );
	self switchtoweapon( weapon );

}

drinkallperks()
{
	if( getdvar( "mapname" ) == "zm_transit" )
	{
		self iprintlnbold( "^5All Perks Given!" );
		self thread dogiveperk( "specialty_armorvest" );
		self thread dogiveperk( "specialty_fastreload" );
		self thread dogiveperk( "specialty_quickrevive" );
		self thread dogiveperk( "specialty_rof" );
		self thread dogiveperk( "specialty_longersprint" );
		self thread dogiveperk( "specialty_scavenger" );
	}
	if( getdvar( "mapname" ) == "zm_nuked" )
	{
		self iprintlnbold( "^5All Perks Given!" );
		self thread dogiveperk( "specialty_armorvest" );
		self thread dogiveperk( "specialty_fastreload" );
		self thread dogiveperk( "specialty_quickrevive" );
		self thread dogiveperk( "specialty_rof" );
	}
	if( getdvar( "mapname" ) == "zm_highrise" )
	{
		self iprintlnbold( "^5All Perks Given!" );
		self thread dogiveperk( "specialty_armorvest" );
		self thread dogiveperk( "specialty_fastreload" );
		self thread dogiveperk( "specialty_quickrevive" );
		self thread dogiveperk( "specialty_rof" );
		self thread dogiveperk( "specialty_additionalprimaryweapon" );
		self thread dogiveperk( "specialty_finalstand" );
	}
	if( getdvar( "mapname" ) == "zm_prison" )
	{
		self iprintlnbold( "^5All Perks Given!" );
		self thread dogiveperk( "specialty_armorvest" );
		self thread dogiveperk( "specialty_fastreload" );
		self thread dogiveperk( "specialty_deadshot" );
		self thread dogiveperk( "specialty_rof" );
		self thread dogiveperk( "specialty_grenadepulldeath" );
	}
	if( getdvar( "mapname" ) == "zm_buried" )
	{
		self iprintlnbold( "^5All Perks Given!" );
		self thread dogiveperk( "specialty_armorvest" );
		self thread dogiveperk( "specialty_fastreload" );
		self thread dogiveperk( "specialty_quickrevive" );
		self thread dogiveperk( "specialty_rof" );
		self thread dogiveperk( "specialty_longersprint" );
		self thread dogiveperk( "specialty_nomotionsensor" );
		self thread dogiveperk( "specialty_additionalprimaryweapon" );
	}
	if( getdvar( "mapname" ) == "zm_tomb" )
	{
		self iprintlnbold( "^5All Perks Given!" );
		self thread dogiveperk( "specialty_armorvest" );
		self thread dogiveperk( "specialty_fastreload" );
		self thread dogiveperk( "specialty_quickrevive" );
		self thread dogiveperk( "specialty_rof" );
		self thread dogiveperk( "specialty_longersprint" );
		self thread dogiveperk( "specialty_grenadepulldeath" );
		self thread dogiveperk( "specialty_additionalprimaryweapon" );
		self thread dogiveperk( "specialty_flakjacket" );
		self thread dogiveperk( "specialty_deadshot" );
	}

}

increaseZombiesLimit()
{
    level.zombie_ai_limit = 128;
    level.zombie_actor_limit = 128;
}

/*
* *****************************************************
*	
* ******************* Persistent **********************
*
* *****************************************************
*/

set_persistent_stats()
{
	if( !isVictisMap() )
		return;
	
	flag_wait("initial_blackscreen_passed");

	set_perma_perks();
	set_bank_points();
	set_fridge_weapon();
}

set_perma_perks() // Huthtv
{
	
	persistent_upgrades = array("pers_revivenoperk", "pers_multikill_headshots", "pers_insta_kill", "pers_jugg", "pers_perk_lose_counter", "pers_sniper_counter", "pers_box_weapon_counter");
	
	persistent_upgrade_values = [];
	persistent_upgrade_values["pers_revivenoperk"] = 17;
	persistent_upgrade_values["pers_multikill_headshots"] = 5;
	persistent_upgrade_values["pers_insta_kill"] = 2;
	persistent_upgrade_values["pers_jugg"] = 3;
	persistent_upgrade_values["pers_perk_lose_counter"] = 3;
	persistent_upgrade_values["pers_sniper_counter"] = 1;
	persistent_upgrade_values["pers_box_weapon_counter"] = 5;
	persistent_upgrade_values["pers_flopper_counter"] = 1;
	level.pers_sniper_misses = 9999;
	if(level.script == "zm_buried")
		persistent_upgrades = combinearrays(persistent_upgrades, array("pers_flopper_counter"));

	foreach(pers_perk in persistent_upgrades)
	{
		upgrade_value = self getdstat("playerstatslist", pers_perk, "StatValue");
		if(upgrade_value != persistent_upgrade_values[pers_perk])
		{
			maps\mp\zombies\_zm_stats::set_client_stat(pers_perk, persistent_upgrade_values[pers_perk]);
		}	
	}
}

set_bank_points()
{
	if(self.account_value < 250)
	{
		self maps\mp\zombies\_zm_stats::set_map_stat("depositBox", 250, level.banking_map);
		self.account_value = 250;
	}
}

set_fridge_weapon()
{
	self clear_stored_weapondata();
	if( level.script == "zm_highrise" )
	{
		self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms" );
		self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600 );
		self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50 );
	}
	else if ( level.script == "zm_transit" || level.script == "zm_buried" )
	{
		self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "m32_upgraded_zm" );
		self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 48 );
		self setdstat( "PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 6 );
	}
}

isVictisMap()
{
	switch(level.script)
	{
		case "zm_transit":
		case "zm_highrise":
		case "zm_buried":
			return true;
		default:
			return false;
	}	
}

enable_LRZ( onoff )
{

    create_dvar( "LRZ_enabled", onoff );
	if( isDvarAllowed( "LRZ_enabled" ) )
		level.LRZ_enabled = getDvarInt( "LRZ_enabled" );
}

enable_LRZ_Menu( onoff )
{
	create_dvar( "LRZ_Menu", onoff );
	if( isDvarAllowed( "LRZ_Menu" ) )
		level.LRZ_Menu = getDvarInt( "LRZ_Menu" );
}

enable_LRZ_Progressive_Perks( onoff )
{
	create_dvar( "LRZ_Progressive_Perks", onoff );
	if( isDvarAllowed( "LRZ_Progressive_Perks" ) )
	{
		level.LRZ_Progressive_Perks = getDvarInt( "LRZ_Progressive_Perks" );

		level thread LRZ_Toggle_Progressive_Perks();
		level notify("LRZ_Trigger_Progressive_Perks");
		while( 1 )
		{
			if( level.LRZ_NoPerkLimit != getDvarInt( "LRZ_Progressive_Perks" ) )
			{
				level.LRZ_NoPerkLimit = getDvarInt( "LRZ_Progressive_Perks" );
				wait 0.05;
				level notify("LRZ_Trigger_Progressive_Perks");
			}
			wait 0.5;
		}
	}
}

LRZ_Toggle_Progressive_Perks()
{
	for(;;)
	{
		level waittill("LRZ_Trigger_Progressive_Perks");
		level endon( "LRZ_Trigger_Disable" );
		if(!level.LRZ_Progressive_Perks)
		{
			level notify( "END_LRZ_Progressive_Perks" );
			setDvar("perk_weapRateMultiplier", "0.75");
			setDvar("perk_weapReloadMultiplier", "0.5");
			setDvar("perk_weapSpreadMultiplier", "0.65");
			setDvar("player_clipSizeMultiplier", "1.0");
			setDvar("player_lastStandBleedoutTime", "45");
			//return;
		}
		if(level.LRZ_Progressive_Perks)
		{
			//player thread Progressive_Perks_Alerts();// Init Progressive Perks Alert System
			self thread Progressive_Perks();// Initialize Progressive Perks
		}
		wait 0.05;
	}
}

enable_LRZ_NoPerkLimit( onoff )
{
	create_dvar( "LRZ_NoPerkLimit", onoff );
	if( isDvarAllowed( "LRZ_NoPerkLimit" ) )
	{
		level.LRZ_NoPerkLimit = getDvarInt( "LRZ_NoPerkLimit" );

		self thread LRZ_No_Perk_Limit();
		level notify("LRZ_Trigger_Perk_Limit");
		while( 1 )
		{
			if( level.LRZ_NoPerkLimit != getDvarInt( "LRZ_NoPerkLimit" ) )
			{
				level.LRZ_NoPerkLimit = getDvarInt( "LRZ_NoPerkLimit" );
				wait 0.05;
				level notify("LRZ_Trigger_Perk_Limit");
			}
			wait 0.5;
		}
	}
}

LRZ_No_Perk_Limit()
{
	for(;;)
	{
		level waittill("LRZ_Trigger_Perk_Limit");
		if(!level.LRZ_NoPerkLimit)
		{
			level.perk_purchase_limit = 4;
			//return;
		}
		if(level.LRZ_NoPerkLimit)
		{
			level thread remove_perk_limit();// Initialize No Perk Limit
			wait 1.0;
			self thread LRZ_Bold_Msg("^2" +self.name + "^7 , your perk limit has been removed");
			wait 0.05;
		}
		wait 0.05;
	}
}

enable_LRZ_Harder_Zombies( onoff )
{
	create_dvar( "LRZ_Harder_Zombies", onoff );
	if( isDvarAllowed( "LRZ_Harder_Zombies" ) )
	{
		level.LRZ_Harder_Zombies = getDvarInt( "LRZ_Harder_Zombies" );

		level thread LRZ_Toggle_Harder_Zombies();
		level notify("LRZ_Trigger_Harder_Zombies");
		while( 1 )
		{
			/*if( getDvarInt( "zmDifficulty" ) == "2") 
			{
				setDvarInt( "LRZ_Harder_Zombies", 1 );
			}
			if( getDvarInt( "zmDifficulty" ) != "2") 
			{
				setDvarInt( "LRZ_Harder_Zombies", 0 );
			}*/
			if( level.LRZ_Harder_Zombies != getDvarInt( "LRZ_Harder_Zombies" ) )
			{
				level.LRZ_Harder_Zombies = getDvarInt( "LRZ_Harder_Zombies" );
				wait 0.05;
				level notify("LRZ_Trigger_Harder_Zombies");
			}
			wait 0.5;
		}
	}
}

LRZ_Toggle_Harder_Zombies()
{
	for(;;)
	{
		level waittill("LRZ_Trigger_Harder_Zombies");
		if(!level.LRZ_Harder_Zombies)
		{
			level.zombie_vars[ "zombie_spawn_delay" ] = "1.8";
			//return;
		}
		if(level.LRZ_Harder_Zombies)
		{
			self thread Zombie_Vars();// Initialize Harder Zombies
		}
		wait 0.05;
	}
}

enable_LRZ_Nonstop_Zombies( onoff )
{
	create_dvar( "LRZ_Nonstop_Zombies", onoff );
	if( isDvarAllowed( "LRZ_Nonstop_Zombies" ) )
	{
		level.LRZ_Nonstop_Zombies = getDvarInt( "LRZ_Nonstop_Zombies" );

		level thread LRZ_Toggle_Harder_Zombies();
		level notify("LRZ_Trigger_Nonstop_Zombies");
		while( 1 )
		{
			if( level.LRZ_Nonstop_Zombies != getDvarInt( "LRZ_Nonstop_Zombies" ) )
			{
				level.LRZ_Nonstop_Zombies = getDvarInt( "LRZ_Nonstop_Zombies" );
				wait 0.05;
				level notify("LRZ_Trigger_Nonstop_Zombies");
			}
			wait 0.5;
		}
	}
}

LRZ_Toggle_Nonstop_Zombies()
{
	for(;;)
	{
		level waittill("LRZ_Trigger_Nonstop_Zombies");
		level endon( "LRZ_Trigger_Disable" );
		if(!level.LRZ_Nonstop_Zombies)
		{
			level.zombie_vars["zombie_between_round_time"] = 10; //remove the delay at the end of each round 
			//level.zombie_round_start_delay = 2; //remove the delay before zombies start to spawn
		}
		if(level.LRZ_Nonstop_Zombies)
		{
			level.zombie_vars["zombie_between_round_time"] = 1; //remove the delay at the end of each round 
			//level.zombie_round_start_delay = 0; //remove the delay before zombies start to spawn
		}
		wait 0.05;
	}
}

enable_LRZ_HUD( onoff )
{
	create_dvar( "LRZ_HUD", onoff );
	if( isDvarAllowed( "LRZ_HUD" ) )
		level.LRZ_Menu = getDvarInt( "LRZ_HUD" );
}

LRZ_Checks()
{
	for(;;)
	{
		if( level.LRZ_enabled != getDvarInt( "LRZ_enabled" ) )
		{
			level.LRZ_enabled = getDvarInt( "LRZ_enabled" );
			wait 0.05;
			//level notify("LRZ_Trigger_Enable");
		}
		wait 0.05;
		if( getDvarInt( "LRZ_enabled" ) == 1 )
		{
			level notify("LRZ_Trigger_Enable");
		}
		wait 0.05;
		if( getDvarInt( "LRZ_enabled" ) == 0 )
		{
			level notify("LRZ_Trigger_Disable");
		}
		wait 0.05;
	}
}

round_pause( delay )
{
	if ( !IsDefined( delay ) )
	{
		delay = 30;
	}

	level.countdown_hud = create_simple_hud();
	level.countdown_hud.alignx = "center";
	level.countdown_hud.aligny = "top";
	level.countdown_hud.horzalign = "user_center";
	level.countdown_hud.vertalign = "user_top";
	level.countdown_hud.fontscale = 32;
	level.countdown_hud setshader( "hud_chalk_1", 64, 64 );
	level.countdown_hud SetValue( delay );
	level.countdown_hud.color = ( 1, 1, 1 );
	level.countdown_hud.alpha = 0;
	level.countdown_hud FadeOverTime( 2.0 );
	level.countdown_hud.color = ( 0.21, 0, 0 );
	level.countdown_hud.alpha = 1;
	wait 2;
	level thread zombie_spawn_wait( delay );

	while (delay >= 1)
	{
		wait 1;
		delay--;
		level.countdown_hud SetValue( delay );
	}

	// Zero!  Play end sound
	players = GetPlayers();
	for (i=0; i<players.size; i++ )
	{
		players[i] playlocalsound( "zmb_perks_packa_ready" );
	}

	level.countdown_hud FadeOverTime( 1.0 );
	level.countdown_hud.color = (1,1,1);
	level.countdown_hud.alpha = 0;
	wait( 1.0 );

	level.countdown_hud destroy_hud();
}

enable_cheats()
{
    setDvar( "sv_cheats", 1 );
	setDvar( "cg_ufo_scaler", 0.7 );

    /*if( level.player_out_of_playable_area_monitor && IsDefined( level.player_out_of_playable_area_monitor ) )
	{
		self notify( "stop_player_out_of_playable_area_monitor" );
	}
	level.player_out_of_playable_area_monitor = 0;*/
}

set_starting_round( round )
{
	create_dvar( "start_round", round );
	if( isDvarAllowed( "start_round" ) )
	{
		//setDvarInt( "start_round", getgametypesetting( "startRound" ) );
		SetGametypeSetting( "startRound" , getDvarInt( "start_round" ) );
		level.start_round = getDvarInt( "start_round" );
	}

	level.first_round = false;
	level.round_number = level.start_round;
}

start_round_delay( delay )
{
	create_dvar("LRZ_start_delay", delay);
	if( isDvarAllowed( "LRZ_start_delay" ) )
		level.LRZ_start_delay = getDvarInt( "LRZ_start_delay" );

	flag_clear("spawn_zombies");

	flag_wait("initial_blackscreen_passed");

	level thread round_pause( level.LRZ_start_delay );
}

zombie_spawn_wait(time)
{
	level endon("end_game");
	level endon( "restart_round" );

	flag_clear("spawn_zombies");

	wait time;

	flag_set("spawn_zombies");
	level notify("LRZ_start_delay_over");
}

/*
* *****************************************************
*	
* *********************** HUD *************************
*
* *****************************************************
*/

timer_hud()
{	
	self endon("disconnect");
	level endon( "LRZ_Trigger_Disable" );

	self.timer_hud = newClientHudElem(self);
	self.timer_hud.alignx = "left";
	self.timer_hud.aligny = "top";
	self.timer_hud.horzalign = "user_left";
	self.timer_hud.vertalign = "user_top";
	self.timer_hud.x += 4;
	self.timer_hud.y += 2;
	self.timer_hud.fontscale = 1.4;
	self.timer_hud.alpha = 1;
	self.timer_hud.color = ( 1, 1, 1 );
	self.timer_hud.hidewheninmenu = 1;

	self set_hud_offset();
	self thread timer_hud_watcher();

	flag_wait( "initial_blackscreen_passed" );
	self.timer_hud setTimerUp(0);

	level waittill( "end_game" );

	level.total_time -= .1; // need to set it below the number or it shows the next number
	while( 1 )
	{	
		self.timer_hud setTimer(level.total_time);
		self.timer_hud.alpha = 1;
		self.round_timer_hud.alpha = 0;
		wait 0.1;
	}
}

set_hud_offset()
{
	self.timer_hud_offset = 0;
	self.zone_hud_offset = 15;
}

timer_hud_watcher( onoff )
{
	self endon("disconnect");
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

	create_dvar( "LRZ_HUD_timer", onoff );
	if( !isDvarAllowed( "LRZ_HUD_timer" ) )
		return;

	while(1)
	{	
		while( !getDvarInt( "LRZ_HUD_timer" ) )
		{
			wait 0.1;
		}
		level.LRZ_HUD_timer = 1;
		self.timer_hud.y = (2 + self.timer_hud_offset);
		self.timer_hud.alpha = 1;

		while( getDvarInt( "LRZ_HUD_timer" ) )
		{
			wait 0.1;
		}
		level.LRZ_HUD_timer = 0;
		self.timer_hud.alpha = 0;
	}
}

LRZ_Big_Msg( msg1, msg2, delay, icon ) // Must Be Threaded
{
	flag_wait( "initial_blackscreen_passed" );
	text1 = self createfontstring( "hudbig", 2.5 );
	text1 setpoint( "CENTER", "CENTER", 0, 0 );
	text1 settext( msg1 );
	text1.glow = 1;
	text1.glowcolor = ( 0, 0, 2 );
	text1.glowalpha = 1;
	text1.alpha = 1;
	text1 moveovertime( 1 );
	text1.y = -150;
	text1.x = 0;
	wait 0.6;
	text2 = self createfontstring( "hudbig", 2.5 );
	text2 setpoint( "CENTER", "CENTER", 0, 0 );
	text2 settext( msg2 );
	text2.glow = 1;
	text2.glowcolor = ( 0, 0, 2 );
	text2.glowalpha = 1;
	text2.alpha = 1;
	text2 moveovertime( 1 );
	text2.y = -120;
	text2.x = 0;
	wait 0.6;
	iconm8 = self drawshader( icon, 0, 110, 80, 80, ( 1, 1, 1 ), 1, 1 );
	iconm8 moveovertime( 1 );
	wait 0.6;
	text1 setpulsefx( 50, 6050, 600 );
	text2 setpulsefx( 50, 6050, 600 );
	if( !delay )
		wait 2.5;
	else
		wait delay;
	text1 fadeovertime( 3 );
	text2 fadeovertime( 3 );
	iconm8 fadeovertime( 3 );
	text1.alpha = 0;
	text2.alpha = 0;
	iconm8.alpha = 0;
	wait 1;
	text1 destroy();
	text2 destroy();
	iconm8 destroy();

}

round_timer_hud()
{
	self endon("disconnect");
	level endon( "LRZ_Trigger_Disable" );

	self.round_timer_hud = newClientHudElem(self);
	self.round_timer_hud.alignx = "left";
	self.round_timer_hud.aligny = "top";
	self.round_timer_hud.horzalign = "user_left";
	self.round_timer_hud.vertalign = "user_top";
	self.round_timer_hud.x += 4;
	self.round_timer_hud.y += (2 + (15 * level.LRZ_HUD_timer ) + self.timer_hud_offset );
	self.round_timer_hud.fontscale = 1.4;
	self.round_timer_hud.alpha = 0;
	self.round_timer_hud.color = ( 1, 1, 1 );
	self.round_timer_hud.hidewheninmenu = 1;

	flag_wait( "initial_blackscreen_passed" );

	self thread round_timer_hud_watcher();

	level.FADE_TIME = 0.2;
	level waittill("LRZ_start_delay_over");
	while( 1 )
	{
		zombies_this_round = level.zombie_total + get_round_enemy_array().size;
		hordes = zombies_this_round / 24;
		dog_round = flag( "dog_round" );
		leaper_round = flag( "leaper_round" );

		self.round_timer_hud setTimerUp(0);
		start_time = int(getTime() / 1000);

		level waittill( "end_of_round" );

		end_time = int(getTime() / 1000);
		time = end_time - start_time;

		self display_round_time(time, hordes, dog_round, leaper_round);

		level waittill( "start_of_round" );

		if( level.LRZ_HUD_round_timer )
		{
			self.round_timer_hud FadeOverTime(level.FADE_TIME);
			self.round_timer_hud.alpha = 1;
		}
	}
}

round_timer_hud_watcher( onoff )
{	
	self endon("disconnect");
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

	create_dvar( "LRZ_HUD_round_timer", onoff );
	if( !isDvarAllowed( "LRZ_HUD_round_timer" ) )
		return;
	
	while( 1 )
	{
		while( !getDvarInt( "LRZ_HUD_round_timer" ) )
		{
			wait 0.1;
		}
		level.LRZ_HUD_round_timer = 1;
		self.round_timer_hud.y = (2 + (15 * level.LRZ_HUD_timer ) + self.timer_hud_offset );
		self.round_timer_hud.alpha = 1;

		while( getDvarInt( "LRZ_HUD_round_timer" ) )
		{
			wait 0.1;
		}
		level.LRZ_HUD_round_timer = 0;
		self.round_timer_hud.alpha = 0;

	}
}

display_round_time(time, hordes, dog_round, leaper_round)
{
	timer_for_hud = time - 0.05;

	sph_off = 1;
	if(level.round_number > 50 && !dog_round && !leaper_round)
	{
		sph_off = 0;
	}

	self.round_timer_hud FadeOverTime(level.FADE_TIME);
	self.round_timer_hud.alpha = 0;
	wait level.FADE_TIME * 2;

	self.round_timer_hud.label = &"Round Time: ";
	self.round_timer_hud FadeOverTime(level.FADE_TIME);
	self.round_timer_hud.alpha = 1;

	for ( i = 0; i < 20 + (20 * sph_off); i++ ) // wait 10s or 5s
	{
		self.round_timer_hud setTimer(timer_for_hud);
		wait 0.25;
	}

	self.round_timer_hud FadeOverTime(level.FADE_TIME);
	self.round_timer_hud.alpha = 0;
	wait level.FADE_TIME * 2;

	if(sph_off == 0)
	{
		self display_sph(time, hordes);
	}

	self.round_timer_hud.label = &"";
}

display_sph( time, hordes )
{
	sph = time / hordes;

	self.round_timer_hud FadeOverTime(level.FADE_TIME);
	self.round_timer_hud.alpha = 1;
	self.round_timer_hud.label = &"SPH: ";
	self.round_timer_hud setValue(sph);

	for ( i = 0; i < 5; i++ )
	{
		wait 1;
	}

	self.round_timer_hud FadeOverTime(level.FADE_TIME);
	self.round_timer_hud.alpha = 0;

	wait level.FADE_TIME;
}

zombie_remaining_hud()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

	//level waittill( "spawned_player" );

    self.zombie_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombie_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", -100, 180 );
    self.zombie_counter_hud.alpha = 1;
	self thread zombie_remaining_hud_watcher(1);

    while( 1 )
    {
        self.zombie_counter_hud.label = &"Zombies: ^1";
		self.zombie_counter_hud setValue( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        
        wait 0.05; 
    }
}

zombie_remaining_hud_watcher( onoff )
{	
	self endon("disconnect");
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

	create_dvar( "LRZ_HUD_zombie_counter", onoff );
	if( !isDvarAllowed( "LRZ_HUD_zombie_counter" ) )
		return;
		level.LRZ_HUD_zombie_counter = getDvarInt( "LRZ_HUD_zombie_counter" );
	
	while(1)
	{
		while( !getDvarInt("LRZ_HUD_zombie_counter") )
		{
			wait 0.1;
		}
		level.LRZ_HUD_zombie_counter = 1;
		self.zombie_counter_hud.alpha = 1;

		while( getDvarInt("LRZ_HUD_zombie_counter") )
		{
			wait 0.1;
		}
		level.LRZ_HUD_zombie_counter = 0;
		self.zombie_counter_hud.alpha = 0;
	}
}

health_remaining_hud()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

	//level waittill( "spawned_player" );

    self.health_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.health_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", 100, 180 );
    self.health_counter_hud.alpha = 1;
	self thread health_remaining_hud_watcher(1);

    while( 1 )
    {
        self.health_counter_hud.label = &"Health: ^2";
		self.health_counter_hud setValue( self.health );
        
        wait 0.05; 
    }
}

health_remaining_hud_watcher( onoff )
{	
	self endon("disconnect");
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

	create_dvar( "LRZ_HUD_health_counter", onoff );
	if( !isDvarAllowed( "LRZ_HUD_health_counter" ) )
		return;
		level.LRZ_HUD_health_counter = getDvarInt( "LRZ_HUD_health_counter" );
	
	while(1)
	{
		while( !getDvarInt("LRZ_HUD_health_counter") )
		{
			wait 0.1;
		}
		level.LRZ_HUD_health_counter = 1;
		self.health_counter_hud.alpha = 1;

		while( getDvarInt("LRZ_HUD_health_counter") )
		{
			wait 0.1;
		}
		level.LRZ_HUD_health_counter = 0;
		self.health_counter_hud.alpha = 0;
	}
}

trap_timer_hud()
{
	if( level.script != "zm_prison" || !level.hud_trap_timer )
		return;

	self endon( "disconnect" );
	self endon( "LRZ_Trigger_Disable" );

	self.trap_timer_hud = newclienthudelem( self );
	self.trap_timer_hud.alignx = "left";
	self.trap_timer_hud.aligny = "top";
	self.trap_timer_hud.horzalign = "user_left";
	self.trap_timer_hud.vertalign = "user_top";
	self.trap_timer_hud.x += 4;
	self.trap_timer_hud.y += (2 + (15 * (level.LRZ_HUD_timer + level.LRZ_HUD_round_timer) ) + self.timer_hud_offset );
	self.trap_timer_hud.fontscale = 1.4;
	self.trap_timer_hud.alpha = 0;
	self.trap_timer_hud.color = ( 1, 1, 1 );
	self.trap_timer_hud.hidewheninmenu = 1;
	self.trap_timer_hud.hidden = 0;
	self.trap_timer_hud.label = &"";

	while( 1 )
	{
		level waittill( "trap_activated" );
		if( !level.trap_activated )
		{
			wait 0.5;
			self.trap_timer_hud.alpha = 1;
			self.trap_timer_hud settimer( 50 );
			wait 50;
			self.trap_timer_hud.alpha = 0;
		}
	}
}

zone_hud()
{
	if( !level.LRZ_HUD_zone_names )
		return;

	self endon("disconnect");

	x = 8;
	y = -111;
	if (level.script == "zm_buried")
	{
		y -= 25;
	}
	else if (level.script == "zm_tomb")
	{
		y -= 30;
	}

	self.zone_hud = newClientHudElem(self);
	self.zone_hud.alignx = "left";
	self.zone_hud.aligny = "bottom";
	self.zone_hud.horzalign = "user_left";
	self.zone_hud.vertalign = "user_bottom";
	self.zone_hud.x += x;
	self.zone_hud.y += y;
	self.zone_hud.fontscale = 1.3;
	self.zone_hud.alpha = 0;
	self.zone_hud.color = ( 1, 1, 1 );
	self.zone_hud.hidewheninmenu = 1;

	flag_wait( "initial_blackscreen_passed" );

	self thread zone_hud_watcher(x, y);
}

zone_hud_watcher( x, y )
{	
	self endon("disconnect");
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

	create_dvar( "LRZ_HUD_zone", 1 );
	if( !isDvarAllowed( "LRZ_HUD_zone" ) )
		return;
	
	prev_zone = "";
	while(1)
	{
		while( !getDvarInt("LRZ_HUD_zone") )
		{
			wait 0.1;
		}
		self.zone_hud.alpha = 1;

		while( getDvarInt("LRZ_HUD_zone") )
		{
			self.zone_hud.y = (y + (self.zone_hud_offset * !level.hud_health_bar ) );

			zone = self get_zone_name();
			if(prev_zone != zone)
			{
				prev_zone = zone;

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 0;
				wait 0.2;

				self.zone_hud settext(zone);

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 1;
				wait 0.2;

				continue;
			}

			wait 0.05;
		}
		self.zone_hud.alpha = 0;
	}
}

LRZ_Zone_Hud_settext()
{
	
}

LRZ_Bold_Msg( msg1, delay) // Can NOT be threaded
{
	self iprintlnBold(msg1);
	if(!delay)
		wait 2;
	else
		wait delay;
}

GPA(attachment)
{
    weapon = self getcurrentweapon();
    self takeweapon(weapon);
    self giveWeapon(weapon+attachment);
    self switchToWeapon(weapon+attachment);
    self giveMaxAmmo(weapon+attachment);
    self iPrintln("^6"+attachment+" Given");
}

LRZ_Perma_Deadshot()
{
	self endon("disconnect");
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );
	for(;;)
	{
		self waittill_any( "player_downed", "fake_death", "entering_last_stand", "spawned_player" );//"whos_who_self_revive","player_revived","fake_revive","do_revive_ended_normally", "al_t", "spawned_player" );
		wait 1;
		self thread dogiveperk( "specialty_deadshot" );
		self.hasDeadshot = 1;
		wait 0.05;
	}

}