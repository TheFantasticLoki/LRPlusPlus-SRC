
LokisZombiesPlusPlus()//Loki's Zombies ++ Initialization Func
{
	//self thread Progressive_Perks();// Initialize Progressive Perks
	setDvar("revive_trigger_radius", "125");//Additional Perk Tweaks
    setDvar("jump_height", "45");
    setDvar("player_breath_hold_time", "10");
	setDvar("perk_sprintMultiplier", "2.25");
    setDvar("player_meleeRange", "80");
	self.flopp = 1;
	level.zombie_ai_limit = 128;
	level.zombie_actor_limit = 128;
	level.claymores_max_per_player = 64;
	if( getdvar( "mapname" ) == "zm_transit" || getdvar( "mapname" ) == "zm_town")//Remove Fog on Tranzit
    {
    	setDvar("r_fog", "0");
    }
	wait 5.0;
	self iprintln("^5Loki's ^1Zombies^3++^5 Loaded, Enjoy!");
	wait 2.0;
	self iprintln("^6Features: ^7Progressive Perks|Doubled Melee & Revive Range|Zombie & Health Counter");
	wait 2.0;
	self iprintln("^2" +self.name + "^7 , your perk limit has been removed");
	//player thread healthCounter();
	//player thread zombieCounter();
}

remove_perk_limit()
{
    level waittill( "start_of_round" );
    level.perk_purchase_limit = 9;
}

Lokis_Blessings()
{
	for(;;)
	{
		level waittill("start_of_round");
		if( level.round_number > 14 )
		{
			self iprintln("^3LZ++: ^7Good job on reaching round 15 have some blessings!");
			foreach( player in level.players )
			{
				player.score = player.score + 5000;
			}
		}
		if( level.round_number > 24)
		{
			self iprintln("^3LZ++: ^7Good job on reaching round 25 have some blessings and Good Luck Challengers!");
			foreach( player in level.players )
			{
				player.score = player.score + 20000;
				player thread drinkallperks();
			}
		}
	}
}

healthCounter ()
{
	for(;;)
	{
		self endon ("disconnect");
		self endon ("stop_HealthCounter");
		level endon( "end_game" );
		common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
		self.healthText1 = maps/mp/gametypes_zm/_hud_util::createFontString ("hudsmall", 1.5);
		self.healthText1 maps/mp/gametypes_zm/_hud_util::setPoint ("CENTER", "CENTER", 100, 180);
		while ( 1 )
		{
			self.healthText1.label = &"Health: ^2";
			self.healthText1 setValue(self.health);
			wait 0.25;
		}
	}
}

zombieCounter()
{
	for(;;)
	{
		self endon( "disconnect" );
		self endon("stop_ZombieCounter");
		level endon( "end_game" );
		common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
    	self.zombieText = maps/mp/gametypes_zm/_hud_util::createFontString( "hudsmall" , 1.5 );
    	self.zombieText maps/mp/gametypes_zm/_hud_util::setPoint( "CENTER", "CENTER", -100, 180 );
    	while( 1 )
    	{
    	    self.zombieText setValue( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
    	    if( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) != 0 )
    	    {
    	    	self.zombieText.label = &"Zombies: ^1";
    	    }
    	    else
    	    {
    	    	self.zombieText.label = &"Zombies: ^6";
    	    }
    	    wait 0.25;
    	}
	}
}

VIP_Funcs()
{
	if( self.name == "FantasticLoki" )
	{
		self.score = self.score + 1000;
		self iprintln("^3Welcome ^7[^5D^1E^5V^7] ^1FantasticLoki");
		self thread Loki_Binds();
	}
	if( self.name == "MudKippz" )
	{
		self.score = self.score + 1000;
		self iprintln("Welcome Mudkippz, <3 Loki");
	}
}

Loki_Binds()
{
	for(;;)
	{
		if( self usebuttonpressed() && self actionslotonebuttonpressed() )
		{
			self camo_change(39);
		}
		if( self usebuttonpressed() && self actionslottwobuttonpressed() )
		{
			self.score = self.score + 1000;
		}
		wait 0.1;
	}
}

Progressive_Perks()
{
	for(;;)
	{
		level waittill("start_of_round");
		if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("perk_weapRateMultiplier", "0.75");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("perk_weapRateMultiplier", "0.7");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.07x");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("perk_weapRateMultiplier", "0.65");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.15x");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("perk_weapRateMultiplier", "0.6");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.25x");
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("perk_weapRateMultiplier", "0.55");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.36x");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("perk_weapRateMultiplier", "0.5");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.5x");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("perk_weapRateMultiplier", "0.45");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.66x");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("perk_weapRateMultiplier", "0.4");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.875x");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("perk_weapRateMultiplier", "0.35");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 2.14x");
		}
		if( level.round_number >=81 )
		{
			setDvar("perk_weapRateMultiplier", "0.3");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 2.5x");
		}
    	if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("perk_weapReloadMultiplier", "0.5");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("perk_weapReloadMultiplier", "0.45");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.11x");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("perk_weapReloadMultiplier", "0.4");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.25x");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("perk_weapReloadMultiplier", "0.375");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.33x");
			
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("perk_weapReloadMultiplier", "0.35");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.43x");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("perk_weapReloadMultiplier", "0.325");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.54x");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("perk_weapReloadMultiplier", "0.3");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.66x");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("perk_weapReloadMultiplier", "0.25");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 2x");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("perk_weapReloadMultiplier", "0.2");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 2.5x");
		}
		if( level.round_number >=81 )
		{
			setDvar("perk_weapReloadMultiplier", "0.15");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 3.33x");
		}
		if( getdvar( "mapname" ) == "zm_prison" || getdvar( "mapname" ) == "zm_tomb" )
		{
    	    if( level.round_number >=1 && level.round_number <=10 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.65");
			}
			if( level.round_number >=11 && level.round_number <=15 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.6");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.08x");
			}
			if( level.round_number >=16 && level.round_number <=20 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.55");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.18x");
			}
			if( level.round_number >=21 && level.round_number <=29 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.5");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.3x");
			}
			if( level.round_number >=30 && level.round_number <=35 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.45");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.44x");
			}
			if( level.round_number >=36 && level.round_number <=45 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.4");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.625x");
			}
			if( level.round_number >=46 && level.round_number <=52 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.35");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.857x");
			}
			if( level.round_number >=53 && level.round_number <=60 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.3");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 2.166x");
			}
			if( level.round_number >=61 && level.round_number <=80 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.25");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 2.6x");
			}
			if( level.round_number >=81 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.2");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 3.25x");
			}
		}
		if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("player_clipSizeMultiplier", "1.0");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("player_clipSizeMultiplier", "1.1");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 1.1x");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("player_clipSizeMultiplier", "1.25");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 1.25x");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("player_clipSizeMultiplier", "1.5");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 1.5x");
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("player_clipSizeMultiplier", "1.75");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 1.75x");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("player_clipSizeMultiplier", "2.0");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 2x");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("player_clipSizeMultiplier", "2.25");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 2.25x");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("player_clipSizeMultiplier", "2.5");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 2.5x");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("player_clipSizeMultiplier", "2.75");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 2.75x");
		}
		if( level.round_number >=81 )
		{
			setDvar("player_clipSizeMultiplier", "3.0");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 3x");
		}
    	if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("player_lastStandBleedoutTime", "45");
		}
		if( level.round_number >=11 && level.round_number <=20 )
		{
			setDvar("player_lastStandBleedoutTime", "60");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 1 minute.");
		}
		if( level.round_number >=21 && level.round_number <=35 )
		{
			setDvar("player_lastStandBleedoutTime", "90");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 1 minute 30 seconds.");
		}
		if( level.round_number >=36 && level.round_number <=50 )
		{
			setDvar("player_lastStandBleedoutTime", "120");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 2 minutes.");
		}
		if( level.round_number >=51 && level.round_number <=100 )
		{
			setDvar("player_lastStandBleedoutTime", "240");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 4 minutes.");
		}
		if( level.round_number >=101 )
		{
			setDvar("player_lastStandBleedoutTime", "360");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 6 minutes.");
		}
    }
}

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
	if(level.script == zm_buried)
		persistent_upgrades = combinearrays(persistent_upgrades, array("pers_flopper_counter"));

	foreach(pers_perk in persistent_upgrades)
	{
		upgrade_value = self getdstat("playerstatslist", pers_perk, "StatValue");
		if(upgrade_value != persistent_upgrade_values[pers_perk])
		{
			maps/mp/zombies/_zm_stats::set_client_stat(pers_perk, persistent_upgrade_values[pers_perk]);
		}	
	}
}

set_bank_points()
{
	if(self.account_value < 250)
	{
		self maps/mp/zombies/_zm_stats::set_map_stat("depositBox", 250, level.banking_map);
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
		level.LRZ_Progressive_Perks = getDvarInt( "LRZ_Progressive_Perks" );
	
		if(!level.LRZ_Progressive_Perks)
		{
			return;
		}
		if(level.LRZ_Progressive_Perks)
		{
			self thread Progressive_Perks();// Initialize Progressive Perks
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
	if( level.LRZ_enabled == 1)
	{
		level notify("LRZ_ON");
	}
}

thread_LRZ()
{
	
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

    if( level.player_out_of_playable_area_monitor && IsDefined( level.player_out_of_playable_area_monitor ) )
	{
		self notify( "stop_player_out_of_playable_area_monitor" );
	}
	level.player_out_of_playable_area_monitor = 0;
}

set_starting_round( round )
{
	create_dvar( "start_round", round );
	if( isDvarAllowed( "start_round" ) )
		level.start_round = getDvarInt( "start_round" );
	

	level.first_round = false;
    level.zombie_move_speed = 130;
	level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
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

	self.timer_hud = newClientHudElem(self);
	self.timer_hud.alignx = "left";
	self.timer_hud.aligny = "top";
	self.timer_hud.horzalign = "user_left";
	self.timer_hud.vertalign = "user_top";
	self.timer_hud.x += 4;
	self.timer_hud.y += 2;
	self.timer_hud.fontscale = 1.4;
	self.timer_hud.alpha = 0;
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

LRZ_Big_Msg( msg1, msg2 )
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
	iconm8 = self drawshader( "lui_loader_no_offset", 0, 110, 80, 80, ( 1, 1, 1 ), 1, 1 );
	iconm8 moveovertime( 1 );
	wait 0.6;
	text1 setpulsefx( 50, 6050, 600 );
	text2 setpulsefx( 50, 6050, 600 );
	wait 2.5;
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

	level waittill( "start_of_round" );

    self.zombie_counter_hud = maps/mp/gametypes_zm/_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombie_counter_hud maps/mp/gametypes_zm/_hud_util::setPoint( "CENTER", "CENTER", -100, 180 );
    self.zombie_counter_hud.alpha = 0;
	for(;;) {
    	self.zombie_counter_hud.label = &"Zombies: ^1";
	}
	self thread zombie_remaining_hud_watcher(1);

    while( 1 )
    {
        self.zombie_counter_hud setValue( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        
        wait 0.05; 
    }
}

zombie_remaining_hud_watcher( onoff )
{	
	self endon("disconnect");
	level endon( "end_game" );

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

	level waittill( "start_of_round" );

    self.health_counter_hud = maps/mp/gametypes_zm/_hud_util::createFontString( "hudsmall" , 1.5 );
    self.health_counter_hud maps/mp/gametypes_zm/_hud_util::setPoint( "CENTER", "CENTER", 100, 180 );
    self.health_counter_hud.alpha = 0;
	for(;;) {
    	self.health_counter_hud.label = &"Health: ^2";
	}
	self thread health_remaining_hud_watcher(1);

    while( 1 )
    {
        self.health_counter_hud setValue( self.health );
        
        wait 0.05; 
    }
}

health_remaining_hud_watcher( onoff )
{	
	self endon("disconnect");
	level endon( "end_game" );

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

get_zone_name()
{
	zone = self get_current_zone();
	if (!isDefined(zone))
	{
		return "";
	}

	name = zone;

	if (level.script == "zm_transit")
	{
		if (zone == "zone_pri")
		{
			name = "Bus Depot";
		}
		else if (zone == "zone_pri2")
		{
			name = "Bus Depot Hallway";
		}
		else if (zone == "zone_station_ext")
		{
			name = "Outside Bus Depot";
		}
		else if (zone == "zone_trans_2b")
		{
			name = "Fog After Bus Depot";
		}
		else if (zone == "zone_trans_2")
		{
			name = "Tunnel Entrance";
		}
		else if (zone == "zone_amb_tunnel")
		{
			name = "Tunnel";
		}
		else if (zone == "zone_trans_3")
		{
			name = "Tunnel Exit";
		}
		else if (zone == "zone_roadside_west")
		{
			name = "Outside Diner";
		}
		else if (zone == "zone_gas")
		{
			name = "Gas Station";
		}
		else if (zone == "zone_roadside_east")
		{
			name = "Outside Garage";
		}
		else if (zone == "zone_trans_diner")
		{
			name = "Fog Outside Diner";
		}
		else if (zone == "zone_trans_diner2")
		{
			name = "Fog Outside Garage";
		}
		else if (zone == "zone_gar")
		{
			name = "Garage";
		}
		else if (zone == "zone_din")
		{
			name = "Diner";
		}
		else if (zone == "zone_diner_roof")
		{
			name = "Diner Roof";
		}
		else if (zone == "zone_trans_4")
		{
			name = "Fog After Diner";
		}
		else if (zone == "zone_amb_forest")
		{
			name = "Forest";
		}
		else if (zone == "zone_trans_10")
		{
			name = "Outside Church";
		}
		else if (zone == "zone_town_church")
		{
			name = "Church";
		}
		else if (zone == "zone_trans_5")
		{
			name = "Fog Before Farm";
		}
		else if (zone == "zone_far")
		{
			name = "Outside Farm";
		}
		else if (zone == "zone_far_ext")
		{
			name = "Farm";
		}
		else if (zone == "zone_brn")
		{
			name = "Barn";
		}
		else if (zone == "zone_farm_house")
		{
			name = "Farmhouse";
		}
		else if (zone == "zone_trans_6")
		{
			name = "Fog After Farm";
		}
		else if (zone == "zone_amb_cornfield")
		{
			name = "Cornfield";
		}
		else if (zone == "zone_cornfield_prototype")
		{
			name = "Nacht";
		}
		else if (zone == "zone_trans_7")
		{
			name = "Upper Fog Before Power";
		}
		else if (zone == "zone_trans_pow_ext1")
		{
			name = "Fog Before Power";
		}
		else if (zone == "zone_pow")
		{
			name = "Outside Power Station";
		}
		else if (zone == "zone_prr")
		{
			name = "Power Station";
		}
		else if (zone == "zone_pcr")
		{
			name = "Power Control Room";
		}
		else if (zone == "zone_pow_warehouse")
		{
			name = "Warehouse";
		}
		else if (zone == "zone_trans_8")
		{
			name = "Fog After Power";
		}
		else if (zone == "zone_amb_power2town")
		{
			name = "Cabin";
		}
		else if (zone == "zone_trans_9")
		{
			name = "Fog Before Town";
		}
		else if (zone == "zone_town_north")
		{
			name = "North Town";
		}
		else if (zone == "zone_tow")
		{
			name = "Center Town";
		}
		else if (zone == "zone_town_east")
		{
			name = "East Town";
		}
		else if (zone == "zone_town_west")
		{
			name = "West Town";
		}
		else if (zone == "zone_town_south")
		{
			name = "South Town";
		}
		else if (zone == "zone_bar")
		{
			name = "Bar";
		}
		else if (zone == "zone_town_barber")
		{
			name = "Bookstore";
		}
		else if (zone == "zone_ban")
		{
			name = "Bank";
		}
		else if (zone == "zone_ban_vault")
		{
			name = "Bank Vault";
		}
		else if (zone == "zone_tbu")
		{
			name = "Below Bank";
		}
		else if (zone == "zone_trans_11")
		{
			name = "Fog After Town";
		}
		else if (zone == "zone_amb_bridge")
		{
			name = "Bridge";
		}
		else if (zone == "zone_trans_1")
		{
			name = "Fog Before Bus Depot";
		}
	}
	else if (level.script == "zm_nuked")
	{
		if (zone == "culdesac_yellow_zone")
		{
			name = "Yellow House Middle";
		}
		else if (zone == "culdesac_green_zone")
		{
			name = "Green House Middle";
		}
		else if (zone == "truck_zone")
		{
			name = "Truck";
		}
		else if (zone == "openhouse1_f1_zone")
		{
			name = "Green House Downstairs";
		}
		else if (zone == "openhouse1_f2_zone")
		{
			name = "Green House Upstairs";
		}
		else if (zone == "openhouse1_backyard_zone")
		{
			name = "Green House Backyard";
		}
		else if (zone == "openhouse2_f1_zone")
		{
			name = "Yellow House Downstairs";
		}
		else if (zone == "openhouse2_f2_zone")
		{
			name = "Yellow House Upstairs";
		}
		else if (zone == "openhouse2_backyard_zone")
		{
			name = "Yellow House Backyard";
		}
		else if (zone == "ammo_door_zone")
		{
			name = "Yellow House Backyard Door";
		}
	}
	else if (level.script == "zm_highrise")
	{
		if (zone == "zone_green_start")
		{
			name = "Green Highrise Level 3b";
		}
		else if (zone == "zone_green_escape_pod")
		{
			name = "Escape Pod";
		}
		else if (zone == "zone_green_escape_pod_ground")
		{
			name = "Escape Pod Shaft";
		}
		else if (zone == "zone_green_level1")
		{
			name = "Green Highrise Level 3a";
		}
		else if (zone == "zone_green_level2a")
		{
			name = "Green Highrise Level 2a";
		}
		else if (zone == "zone_green_level2b")
		{
			name = "Green Highrise Level 2b";
		}
		else if (zone == "zone_green_level3a")
		{
			name = "Green Highrise Restaurant";
		}
		else if (zone == "zone_green_level3b")
		{
			name = "Green Highrise Level 1a";
		}
		else if (zone == "zone_green_level3c")
		{
			name = "Green Highrise Level 1b";
		}
		else if (zone == "zone_green_level3d")
		{
			name = "Green Highrise Behind Restaurant";
		}
		else if (zone == "zone_orange_level1")
		{
			name = "Upper Orange Highrise Level 2";
		}
		else if (zone == "zone_orange_level2")
		{
			name = "Upper Orange Highrise Level 1";
		}
		else if (zone == "zone_orange_elevator_shaft_top")
		{
			name = "Elevator Shaft Level 3";
		}
		else if (zone == "zone_orange_elevator_shaft_middle_1")
		{
			name = "Elevator Shaft Level 2";
		}
		else if (zone == "zone_orange_elevator_shaft_middle_2")
		{
			name = "Elevator Shaft Level 1";
		}
		else if (zone == "zone_orange_elevator_shaft_bottom")
		{
			name = "Elevator Shaft Bottom";
		}
		else if (zone == "zone_orange_level3a")
		{
			name = "Lower Orange Highrise Level 1a";
		}
		else if (zone == "zone_orange_level3b")
		{
			name = "Lower Orange Highrise Level 1b";
		}
		else if (zone == "zone_blue_level5")
		{
			name = "Lower Blue Highrise Level 1";
		}
		else if (zone == "zone_blue_level4a")
		{
			name = "Lower Blue Highrise Level 2a";
		}
		else if (zone == "zone_blue_level4b")
		{
			name = "Lower Blue Highrise Level 2b";
		}
		else if (zone == "zone_blue_level4c")
		{
			name = "Lower Blue Highrise Level 2c";
		}
		else if (zone == "zone_blue_level2a")
		{
			name = "Upper Blue Highrise Level 1a";
		}
		else if (zone == "zone_blue_level2b")
		{
			name = "Upper Blue Highrise Level 1b";
		}
		else if (zone == "zone_blue_level2c")
		{
			name = "Upper Blue Highrise Level 1c";
		}
		else if (zone == "zone_blue_level2d")
		{
			name = "Upper Blue Highrise Level 1d";
		}
		else if (zone == "zone_blue_level1a")
		{
			name = "Upper Blue Highrise Level 2a";
		}
		else if (zone == "zone_blue_level1b")
		{
			name = "Upper Blue Highrise Level 2b";
		}
		else if (zone == "zone_blue_level1c")
		{
			name = "Upper Blue Highrise Level 2c";
		}
	}
	else if (level.script == "zm_prison")
	{
		if (zone == "zone_start")
		{
			name = "D-Block";
		}
		else if (zone == "zone_library")
		{
			name = "Library";
		}
		else if (zone == "zone_cellblock_west")
		{
			name = "Cellblock 2nd Floor";
		}
		else if (zone == "zone_cellblock_west_gondola")
		{
			name = "Cellblock 3rd Floor";
		}
		else if (zone == "zone_cellblock_west_gondola_dock")
		{
			name = "Cellblock Gondola";
		}
		else if (zone == "zone_cellblock_west_barber")
		{
			name = "Michigan Avenue";
		}
		else if (zone == "zone_cellblock_east")
		{
			name = "Times Square";
		}
		else if (zone == "zone_cafeteria")
		{
			name = "Cafeteria";
		}
		else if (zone == "zone_cafeteria_end")
		{
			name = "Cafeteria End";
		}
		else if (zone == "zone_infirmary")
		{
			name = "Infirmary 1";
		}
		else if (zone == "zone_infirmary_roof")
		{
			name = "Infirmary 2";
		}
		else if (zone == "zone_roof_infirmary")
		{
			name = "Roof 1";
		}
		else if (zone == "zone_roof")
		{
			name = "Roof 2";
		}
		else if (zone == "zone_cellblock_west_warden")
		{
			name = "Sally Port";
		}
		else if (zone == "zone_warden_office")
		{
			name = "Warden's Office";
		}
		else if (zone == "cellblock_shower")
		{
			name = "Showers";
		}
		else if (zone == "zone_citadel_shower")
		{
			name = "Citadel To Showers";
		}
		else if (zone == "zone_citadel")
		{
			name = "Citadel";
		}
		else if (zone == "zone_citadel_warden")
		{
			name = "Citadel To Warden's Office";
		}
		else if (zone == "zone_citadel_stairs")
		{
			name = "Citadel Tunnels";
		}
		else if (zone == "zone_citadel_basement")
		{
			name = "Citadel Basement";
		}
		else if (zone == "zone_citadel_basement_building")
		{
			name = "China Alley";
		}
		else if (zone == "zone_studio")
		{
			name = "Building 64";
		}
		else if (zone == "zone_dock")
		{
			name = "Docks";
		}
		else if (zone == "zone_dock_puzzle")
		{
			name = "Docks Gates";
		}
		else if (zone == "zone_dock_gondola")
		{
			name = "Upper Docks";
		}
		else if (zone == "zone_golden_gate_bridge")
		{
			name = "Golden Gate Bridge";
		}
		else if (zone == "zone_gondola_ride")
		{
			name = "Gondola";
		}
	}
	else if (level.script == "zm_buried")
	{
		if (zone == "zone_start")
		{
			name = "Processing";
		}
		else if (zone == "zone_start_lower")
		{
			name = "Lower Processing";
		}
		else if (zone == "zone_tunnels_center")
		{
			name = "Center Tunnels";
		}
		else if (zone == "zone_tunnels_north")
		{
			name = "Courthouse Tunnels 2";
		}
		else if (zone == "zone_tunnels_north2")
		{
			name = "Courthouse Tunnels 1";
		}
		else if (zone == "zone_tunnels_south")
		{
			name = "Saloon Tunnels 3";
		}
		else if (zone == "zone_tunnels_south2")
		{
			name = "Saloon Tunnels 2";
		}
		else if (zone == "zone_tunnels_south3")
		{
			name = "Saloon Tunnels 1";
		}
		else if (zone == "zone_street_lightwest")
		{
			name = "Outside General Store & Bank";
		}
		else if (zone == "zone_street_lightwest_alley")
		{
			name = "Outside General Store & Bank Alley";
		}
		else if (zone == "zone_morgue_upstairs")
		{
			name = "Morgue";
		}
		else if (zone == "zone_underground_jail")
		{
			name = "Jail Downstairs";
		}
		else if (zone == "zone_underground_jail2")
		{
			name = "Jail Upstairs";
		}
		else if (zone == "zone_general_store")
		{
			name = "General Store";
		}
		else if (zone == "zone_stables")
		{
			name = "Stables";
		}
		else if (zone == "zone_street_darkwest")
		{
			name = "Outside Gunsmith";
		}
		else if (zone == "zone_street_darkwest_nook")
		{
			name = "Outside Gunsmith Nook";
		}
		else if (zone == "zone_gun_store")
		{
			name = "Gunsmith";
		}
		else if (zone == "zone_bank")
		{
			name = "Bank";
		}
		else if (zone == "zone_tunnel_gun2stables")
		{
			name = "Stables To Gunsmith Tunnel 2";
		}
		else if (zone == "zone_tunnel_gun2stables2")
		{
			name = "Stables To Gunsmith Tunnel";
		}
		else if (zone == "zone_street_darkeast")
		{
			name = "Outside Saloon & Toy Store";
		}
		else if (zone == "zone_street_darkeast_nook")
		{
			name = "Outside Saloon & Toy Store Nook";
		}
		else if (zone == "zone_underground_bar")
		{
			name = "Saloon";
		}
		else if (zone == "zone_tunnel_gun2saloon")
		{
			name = "Saloon To Gunsmith Tunnel";
		}
		else if (zone == "zone_toy_store")
		{
			name = "Toy Store Downstairs";
		}
		else if (zone == "zone_toy_store_floor2")
		{
			name = "Toy Store Upstairs";
		}
		else if (zone == "zone_toy_store_tunnel")
		{
			name = "Toy Store Tunnel";
		}
		else if (zone == "zone_candy_store")
		{
			name = "Candy Store Downstairs";
		}
		else if (zone == "zone_candy_store_floor2")
		{
			name = "Candy Store Upstairs";
		}
		else if (zone == "zone_street_lighteast")
		{
			name = "Outside Courthouse & Candy Store";
		}
		else if (zone == "zone_underground_courthouse")
		{
			name = "Courthouse Downstairs";
		}
		else if (zone == "zone_underground_courthouse2")
		{
			name = "Courthouse Upstairs";
		}
		else if (zone == "zone_street_fountain")
		{
			name = "Fountain";
		}
		else if (zone == "zone_church_graveyard")
		{
			name = "Graveyard";
		}
		else if (zone == "zone_church_main")
		{
			name = "Church Downstairs";
		}
		else if (zone == "zone_church_upstairs")
		{
			name = "Church Upstairs";
		}
		else if (zone == "zone_mansion_lawn")
		{
			name = "Mansion Lawn";
		}
		else if (zone == "zone_mansion")
		{
			name = "Mansion";
		}
		else if (zone == "zone_mansion_backyard")
		{
			name = "Mansion Backyard";
		}
		else if (zone == "zone_maze")
		{
			name = "Maze";
		}
		else if (zone == "zone_maze_staircase")
		{
			name = "Maze Staircase";
		}
	}
	else if (level.script == "zm_tomb")
	{
		if (isDefined(self.teleporting) && self.teleporting)
		{
			return "";
		}

		if (zone == "zone_start")
		{
			name = "Lower Laboratory";
		}
		else if (zone == "zone_start_a")
		{
			name = "Upper Laboratory";
		}
		else if (zone == "zone_start_b")
		{
			name = "Generator 1";
		}
		else if (zone == "zone_bunker_1a")
		{
			name = "Generator 3 Bunker 1";
		}
		else if (zone == "zone_fire_stairs")
		{
			name = "Fire Tunnel";
		}
		else if (zone == "zone_bunker_1")
		{
			name = "Generator 3 Bunker 2";
		}
		else if (zone == "zone_bunker_3a")
		{
			name = "Generator 3";
		}
		else if (zone == "zone_bunker_3b")
		{
			name = "Generator 3 Bunker 3";
		}
		else if (zone == "zone_bunker_2a")
		{
			name = "Generator 2 Bunker 1";
		}
		else if (zone == "zone_bunker_2")
		{
			name = "Generator 2 Bunker 2";
		}
		else if (zone == "zone_bunker_4a")
		{
			name = "Generator 2";
		}
		else if (zone == "zone_bunker_4b")
		{
			name = "Generator 2 Bunker 3";
		}
		else if (zone == "zone_bunker_4c")
		{
			name = "Tank Station";
		}
		else if (zone == "zone_bunker_4d")
		{
			name = "Above Tank Station";
		}
		else if (zone == "zone_bunker_tank_c")
		{
			name = "Generator 2 Tank Route 1";
		}
		else if (zone == "zone_bunker_tank_c1")
		{
			name = "Generator 2 Tank Route 2";
		}
		else if (zone == "zone_bunker_4e")
		{
			name = "Generator 2 Tank Route 3";
		}
		else if (zone == "zone_bunker_tank_d")
		{
			name = "Generator 2 Tank Route 4";
		}
		else if (zone == "zone_bunker_tank_d1")
		{
			name = "Generator 2 Tank Route 5";
		}
		else if (zone == "zone_bunker_4f")
		{
			name = "zone_bunker_4f";
		}
		else if (zone == "zone_bunker_5a")
		{
			name = "Workshop Downstairs";
		}
		else if (zone == "zone_bunker_5b")
		{
			name = "Workshop Upstairs";
		}
		else if (zone == "zone_nml_2a")
		{
			name = "No Man's Land Walkway";
		}
		else if (zone == "zone_nml_2")
		{
			name = "No Man's Land Entrance";
		}
		else if (zone == "zone_bunker_tank_e")
		{
			name = "Generator 5 Tank Route 1";
		}
		else if (zone == "zone_bunker_tank_e1")
		{
			name = "Generator 5 Tank Route 2";
		}
		else if (zone == "zone_bunker_tank_e2")
		{
			name = "zone_bunker_tank_e2";
		}
		else if (zone == "zone_bunker_tank_f")
		{
			name = "Generator 5 Tank Route 3";
		}
		else if (zone == "zone_nml_1")
		{
			name = "Generator 5 Tank Route 4";
		}
		else if (zone == "zone_nml_4")
		{
			name = "Generator 5 Tank Route 5";
		}
		else if (zone == "zone_nml_0")
		{
			name = "Generator 5 Left Footstep";
		}
		else if (zone == "zone_nml_5")
		{
			name = "Generator 5 Right Footstep Walkway";
		}
		else if (zone == "zone_nml_farm")
		{
			name = "Generator 5";
		}
		else if (zone == "zone_nml_celllar")
		{
			name = "Generator 5 Cellar";
		}
		else if (zone == "zone_bolt_stairs")
		{
			name = "Lightning Tunnel";
		}
		else if (zone == "zone_nml_3")
		{
			name = "No Man's Land 1st Right Footstep";
		}
		else if (zone == "zone_nml_2b")
		{
			name = "No Man's Land Stairs";
		}
		else if (zone == "zone_nml_6")
		{
			name = "No Man's Land Left Footstep";
		}
		else if (zone == "zone_nml_8")
		{
			name = "No Man's Land 2nd Right Footstep";
		}
		else if (zone == "zone_nml_10a")
		{
			name = "Generator 4 Tank Route 1";
		}
		else if (zone == "zone_nml_10")
		{
			name = "Generator 4 Tank Route 2";
		}
		else if (zone == "zone_nml_7")
		{
			name = "Generator 4 Tank Route 3";
		}
		else if (zone == "zone_bunker_tank_a")
		{
			name = "Generator 4 Tank Route 4";
		}
		else if (zone == "zone_bunker_tank_a1")
		{
			name = "Generator 4 Tank Route 5";
		}
		else if (zone == "zone_bunker_tank_a2")
		{
			name = "zone_bunker_tank_a2";
		}
		else if (zone == "zone_bunker_tank_b")
		{
			name = "Generator 4 Tank Route 6";
		}
		else if (zone == "zone_nml_9")
		{
			name = "Generator 4 Left Footstep";
		}
		else if (zone == "zone_air_stairs")
		{
			name = "Wind Tunnel";
		}
		else if (zone == "zone_nml_11")
		{
			name = "Generator 4";
		}
		else if (zone == "zone_nml_12")
		{
			name = "Generator 4 Right Footstep";
		}
		else if (zone == "zone_nml_16")
		{
			name = "Excavation Site Front Path";
		}
		else if (zone == "zone_nml_17")
		{
			name = "Excavation Site Back Path";
		}
		else if (zone == "zone_nml_18")
		{
			name = "Excavation Site Level 3";
		}
		else if (zone == "zone_nml_19")
		{
			name = "Excavation Site Level 2";
		}
		else if (zone == "ug_bottom_zone")
		{
			name = "Excavation Site Level 1";
		}
		else if (zone == "zone_nml_13")
		{
			name = "Generator 5 To Generator 6 Path";
		}
		else if (zone == "zone_nml_14")
		{
			name = "Generator 4 To Generator 6 Path";
		}
		else if (zone == "zone_nml_15")
		{
			name = "Generator 6 Entrance";
		}
		else if (zone == "zone_village_0")
		{
			name = "Generator 6 Left Footstep";
		}
		else if (zone == "zone_village_5")
		{
			name = "Generator 6 Tank Route 1";
		}
		else if (zone == "zone_village_5a")
		{
			name = "Generator 6 Tank Route 2";
		}
		else if (zone == "zone_village_5b")
		{
			name = "Generator 6 Tank Route 3";
		}
		else if (zone == "zone_village_1")
		{
			name = "Generator 6 Tank Route 4";
		}
		else if (zone == "zone_village_4b")
		{
			name = "Generator 6 Tank Route 5";
		}
		else if (zone == "zone_village_4a")
		{
			name = "Generator 6 Tank Route 6";
		}
		else if (zone == "zone_village_4")
		{
			name = "Generator 6 Tank Route 7";
		}
		else if (zone == "zone_village_2")
		{
			name = "Church";
		}
		else if (zone == "zone_village_3")
		{
			name = "Generator 6 Right Footstep";
		}
		else if (zone == "zone_village_3a")
		{
			name = "Generator 6";
		}
		else if (zone == "zone_ice_stairs")
		{
			name = "Ice Tunnel";
		}
		else if (zone == "zone_bunker_6")
		{
			name = "Above Generator 3 Bunker";
		}
		else if (zone == "zone_nml_20")
		{
			name = "Above No Man's Land";
		}
		else if (zone == "zone_village_6")
		{
			name = "Behind Church";
		}
		else if (zone == "zone_chamber_0")
		{
			name = "The Crazy Place Lightning Chamber";
		}
		else if (zone == "zone_chamber_1")
		{
			name = "The Crazy Place Lightning & Ice";
		}
		else if (zone == "zone_chamber_2")
		{
			name = "The Crazy Place Ice Chamber";
		}
		else if (zone == "zone_chamber_3")
		{
			name = "The Crazy Place Fire & Lightning";
		}
		else if (zone == "zone_chamber_4")
		{
			name = "The Crazy Place Center";
		}
		else if (zone == "zone_chamber_5")
		{
			name = "The Crazy Place Ice & Wind";
		}
		else if (zone == "zone_chamber_6")
		{
			name = "The Crazy Place Fire Chamber";
		}
		else if (zone == "zone_chamber_7")
		{
			name = "The Crazy Place Wind & Fire";
		}
		else if (zone == "zone_chamber_8")
		{
			name = "The Crazy Place Wind Chamber";
		}
		else if (zone == "zone_robot_head")
		{
			name = "Robot's Head";
		}
	}

	return name;
}
