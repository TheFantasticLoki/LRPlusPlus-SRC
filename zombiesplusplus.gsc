zpp_startInit()
{
	//thread gscRestart(); //JezuzLizard fix sound stuff
    //thread setPlayersToSpectator(); //JezuzLizard fix sound stuff
}

initServerDvars() //credits to JezuzLizard!!! This is a huge help in making this happen
{
	//level.player_starting_points = getDvarIntDefault( "LRZ2_playerStartingPoints", 500 );
	//sets the perk limit for all players
	//level.perk_purchase_limit = getDvarIntDefault( "LRZ2_perkLimit", 4 );
	//sets the maximum number of zombies that can be on the map at once 32 max
	//level.zombie_ai_limit = getDvarIntDefault( "LRZ2_zombieAiLimit", 24 );
	//sets the number of zombie bodies that can be on the map at once
	//level.zombie_actor_limit = getDvarIntDefault( "LRZ2_zombieActorLimit", 32 );
	//enables midround hellhounds WARNING: causes permanent round pauses on maps that aren't bus depot, town or farm
	//level.mixed_rounds_enabled = getDvarIntDefault( "LRZ2_midroundDogs", 0 );
	//disables the end game check WARNING: make sure to include a spectator respawner and auto revive function
	//level.no_end_game_check = getDvarIntDefault( "LRZ2_noEndGameCheck", 0 );
	//sets the solo laststand pistol
	level.default_solo_laststandpistol = getDvar( "LRZ2_soloLaststandWeapon" );
	//the default laststand pistol
	level.default_laststandpistol = getDvar( "LRZ2_coopLaststandWeapon" );
	//set the starting weapon
	level.start_weapon = getDvar( "LRZ2_startWeaponZm" );
	//sets all zombies to this speed lower values result in walkers higher values sprinters
	//level.zombie_move_speed = getDvarIntDefault( "LRZ2_zombieMoveSpeed", 1 );
	//locks the zombie movespeed to the above value
	//level.zombieMoveSpeedLocked = getDvarIntDefault( "LRZ3_zombieMoveSpeedLocked", 0 );
	//sets whether there is a cap to the zombie movespeed active
	//level.zombieMoveSpeedCap = getDvarIntDefault( "LRZ3_zombieMoveSpeedCap", 0 );
	//sets the value to the zombie movespeed cap
	//level.zombieMoveSpeedCapValue = getDvarIntDefault( "LRZ3_zombieMoveSpeedCapValue", 1 );
	//sets the round number any value between 1-255
	//level.round_number = getDvarIntDefault( "LRZ3_roundNumber", 1 );
	//enables the override for zombies per round
	//level.overrideZombieTotalPermanently = getDvarIntDefault( "LRZ3_overrideZombieTotalPermanently", 0 );
	//sets the number of zombies per round to the value indicated
	//level.overrideZombieTotalPermanentlyValue = getDvarIntDefault( "LRZ3_overrideZombieTotalPermanentlyValue", 6 );
	//enables the override for zombie health
	//level.overrideZombieHealthPermanently = getDvarIntDefault( "LRZ3_overrideZombieHealthPermanently", 0 );
	//sets the health of zombies every round to the value indicated
	//level.overrideZombieHealthPermanentlyValue = getDvarIntDefault( "LRZ3_overrideZombieHealthPermanentlyValue", 150 );
	//enables the health cap override so zombies health won't grow beyond the value indicated
	//level.overrideZombieMaxHealth = getDvarIntDefault( "LRZ3_overrideZombieMaxHealth", 0 );
	//sets the maximum health zombie health will increase to 
	//level.overrideZombieMaxHealthValue = getDvarIntDefault( "LRZ3_overrideZombieMaxHealthValue" , 150 );
	/*
	//disables walkers 
	level.disableWalkers = getDvarIntDefault( "LRZ4_disableWalkers", 0 );
	if ( level.disableWalkers )
	{
		level.speed_change_round = undefined;
	}
	//set afterlives on mob to 1 like a normal coop match and sets the prices of doors on origins to be higher
	level.disableSoloMode = getDvarIntDefault( "LRZ4_disableSoloMode", 0 );
	if ( level.disableSoloMode )
	{
		level.is_forever_solo_game = undefined;
	}
	//disables all drops
	level.zmPowerupsNoPowerupDrops = getDvarIntDefault( "LRZ4_zmPowerupsNoPowerupDrops", 0 );
	
	//Zombie_Vars:
	//The reason zombie_vars are first set to a var is because they don't reliably set when set directly to the value of a dvar
	//sets the maximum number of drops per round
	level.maxPowerupsPerRound = getDvarIntDefault( "LRZ4_maxPowerupsPerRound", 4 );
	level.zombie_vars["zombie_powerup_drop_max_per_round"] = level.maxPowerupsPerRound;
	//sets the powerup drop rate lower is better
	level.powerupDropRate = getDvarIntDefault( "LRZ4_powerupDropRate", 2000 );
	level.zombie_vars["zombie_powerup_drop_increment"] = level.powerupDropRate;
	//makes every zombie drop a powerup
	level.zombiesAlwaysDropPowerups = getDvarIntDefault( "LRZ4_zombiesAlwaysDropPowerups", 0 );
	level.zombie_vars[ "zombie_drop_item" ] = level.zombiesAlwaysDropPowerups;
	//increase these below vars to increase drop rate
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.fourPlayerPowerupScore = getDvarIntDefault( "LRZ4_fourPlayerPowerupScore", 50 );
	level.zombie_vars[ "zombie_score_kill_4p_team" ] = level.fourPlayerPowerupScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.threePlayerPowerupScore = getDvarIntDefault( "LRZ4_threePlayerPowerupScore", 50 );
	level.zombie_vars[ "zombie_score_kill_3p_team" ] = level.threePlayerPowerupScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.twoPlayerPowerupScore = getDvarIntDefault( "LRZ4_twoPlayerPowerupScore", 50 );
	level.zombie_vars[ "zombie_score_kill_2p_team" ] = level.twoPlayerPowerupScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.onePlayerPowerupScore = getDvarIntDefault( "LRZ4_onePlayerPowerupScore", 50 );
	level.zombie_vars[ "zombie_score_kill_1p_team" ] = level.onePlayerPowerupScore;
	//points for melee kills to the powerup increment to a powerup drop
	level.powerupScoreMeleeKill = getDvarIntDefault( "LRZ4_powerupScoreMeleeKill", 80 );
	level.zombie_vars[ "zombie_score_bonus_melee" ] = level.powerupScoreMeleeKill;
	//points for headshot kills to the powerup increment to a powerup drop
	level.powerupScoreHeadshotKill = getDvarIntDefault( "LRZ4_powerupScoreHeadshotKill", 50 );
	level.zombie_vars[ "zombie_score_bonus_head" ] = level.powerupScoreHeadshotKill;
	//points for neck kills to the powerup increment to a powerup drop
	level.powerupScoreNeckKill = getDvarIntDefault( "LRZ4_powerupScoreNeckKill", 20 );
	level.zombie_vars[ "zombie_score_bonus_neck" ] = level.powerupScoreNeckKill;
	//points for torso kills to the powerup increment to a powerup drop
	level.powerupScoreTorsoKill = getDvarIntDefault( "LRZ4_powerupScoreTorsoKill", 10 );
	level.zombie_vars[ "zombie_score_bonus_torso" ] = level.powerupScoreTorsoKill;
	//sets the zombie spawnrate; max is 0.08 
	level.zombieSpawnRate = getDvarFloatDefault( "zombieSpawnRate", 2 );
	level.zombie_vars[ "zombie_spawn_delay" ] = level.zombieSpawnRate;
	//sets the zombie spawnrate multiplier increase
	level.zombieSpawnRateMultiplier = getDvarFloatDefault( "zombieSpawnRateMultiplier", 0.95 );
	//locks the spawnrate so it does not change throughout gameplay
	level.zombieSpawnRateLocked = getDvarIntDefault( "LRZ4_zombieSpawnRateLocked", 0 );
	//alters the number of zombies per round formula amount of zombies per round is roughly correlated to this value
	//ie half as many zombies per player is half as many zombies per round
	level.zombiesPerPlayer = getDvarIntDefault( "LRZ4_zombiesPerPlayer", 6 );
	level.zombie_vars["zombie_ai_per_player"] = level.zombiesPerPlayer;
	//sets the flat amount of hp the zombies gain per round not used after round 10
	level.zombieHealthIncreaseFlat = getDvarIntDefault( "LRZ4_zombieHealthIncreaseFlat", 100 );
	level.zombie_vars[ "zombie_health_increase" ] = level.zombieHealthIncreaseFlat;
	//multiplies zombie health by this value every round after round 10
	level.zombieHealthIncreaseMultiplier = getDvarFloatDefault( "zombieHealthIncreaseMultiplier", 0.1 );
	level.zombie_vars[ "zombie_health_increase_multiplier" ] = level.zombieHealthIncreaseMultiplier;
	//base zombie health before any multipliers or additions
	level.zombieHealthStart = getDvarIntDefault( "LRZ4_zombieHealthStart", 150 );
	level.zombie_vars[ "zombie_health_start" ] = level.zombieHealthStart;
	//time before new runners spawn on early rounds
	level.zombieNewRunnerInterval = getDvarIntDefault( "LRZ4_zombieNewRunnerInterval", 10 );
	level.zombie_vars[ "zombie_new_runner_interval" ] = level.zombieNewRunnerInterval;
	//determines level.zombie_move_speed on original
	level.zombieMoveSpeedMultiplier = getDvarIntDefault( "LRZ4_zombieMoveSpeedMultiplier", 10 );
	level.zombie_vars[ "zombie_move_speed_multiplier" ] = level.zombieMoveSpeedMultiplier;
	//determines level.zombie_move_speed on easy
	level.zombieMoveSpeedMultiplierEasy = getDvarIntDefault( "LRZ4_zombieMoveSpeedMultiplierEasy", 8 );
	level.zombie_vars[ "zombie_move_speed_multiplier_easy"] = level.zombieMoveSpeedMultiplierEasy;
	//affects the number of zombies per round formula
	level.zombieMaxAi = getDvarIntDefault( "LRZ4_zombieMaxAi", 24 );
	level.zombie_vars[ "zombie_max_ai" ] = level.zombieMaxAi;
	//affects the check for zombies that have fallen thru the map
	level.belowWorldCheck = getDvarIntDefault( "LRZ4_belowWorldCheck", -1000 );
	level.zombie_vars[ "below_world_check" ] = level.belowWorldCheck;
	//sets whether spectators respawn at the end of the round
	level.customSpectatorsRespawn = getDvarIntDefault( "LRZ4_customSpectatorsRespawn", 1 );
	level.zombie_vars[ "spectators_respawn" ] = level.customSpectatorsRespawn;
	//sets the time that the game takes during the end game intermission
	level.zombieIntermissionTime = getDvarIntDefault( "LRZ4_zombieIntermissionTime", 20 );
	level.zombie_vars["zombie_intermission_time"] = level.zombieIntermissionTime;
	//the time between rounds
	level.zombieBetweenRoundTime = getDvarIntDefault( "LRZ4_zombieBetweenRoundTime", 15 );
	level.zombie_vars["zombie_between_round_time"] = level.zombieBetweenRoundTime;
	//time before the game starts 
	level.roundStartDelay = getDvarIntDefault( "LRZ4_roundStartDelay", 0 );
	level.zombie_vars[ "game_start_delay" ] = level.roundStartDelay;
	//points all players lose when a player bleeds out %10 default
	level.bleedoutPointsLostAllPlayers = getDvarFloatDefault( "bleedoutPointsLostAllPlayers", 0.1 );
	level.zombie_vars[ "penalty_no_revive" ] = level.bleedoutPointsLostAllPlayers;
	//penalty to the player who died 10% of points by default
	level.bleedoutPointsLostSelf = getDvarFloatDefault( "bleedoutPointsLostSelf", 0.1 );
	level.zombie_vars[ "penalty_died" ] = level.bleedoutPointsLostSelf;
	//points players lose on down %5 by default
	level.downedPointsLostSelf = getDvarFloatDefault( "downedPointsLostSelf", 0.05 );
	level.zombie_vars[ "penalty_downed" ] = level.downedPointsLostSelf;
	//unknown
	level.playerStartingLives = getDvarIntDefault( "LRZ4_playerStartingLives", 1 );
	level.zombie_vars[ "starting_lives" ] = level.playerStartingLives;
	//points earned per zombie kill in a 4 player game
	level.fourPlayerScorePerZombieKill = getDvarIntDefault( "LRZ4_fourPlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_4player" ] = level.fourPlayerScorePerZombieKill;
	//points earned per zombie kill in a 3 player game
	level.threePlayerScorePerZombieKill = getDvarIntDefault( "LRZ4_threePlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_3player" ] = level.threePlayerScorePerZombieKill;
	//points earned per zombie kill in a 2 player game
	level.twoPlayerScorePerZombieKill = getDvarIntDefault( "LRZ4_twoPlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_2player" ] = level.twoPlayerScorePerZombieKill;
	//points earned per zombie kill in a 1 player game
	level.onePlayerScorePerZombieKill = getDvarIntDefault( "LRZ4_onePlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_1player" ] = level.onePlayerScorePerZombieKill;
	//points given for a normal attack
	level.pointsPerNormalAttack = getDvarIntDefault( "LRZ4_pointsPerNormalAttack", 10 );
	level.zombie_vars[ "zombie_score_damage_normal" ] = level.pointsPerNormalAttack;
	//points given for a light attack
	level.pointsPerLightAttack = getDvarIntDefault( "LRZ4_pointsPerLightAttack", 10 );
	level.zombie_vars[ "zombie_score_damage_light" ] = level.pointsPerLightAttack;
	//players turn into a zombie on death WARNING: buggy as can be and is missing assets
	level.shouldZombifyPlayer = getDvarIntDefault( "LRZ4_shouldZombifyPlayer", 0 );
	level.zombie_vars[ "zombify_player" ] = level.shouldZombifyPlayer;
	//points scalar for allies team
	level.alliesPointsMultiplier = getDvarIntDefault( "LRZ4_alliesPointsMultiplier", 1 );
	level.zombie_vars[ "allies" ][ "zombie_point_scalar" ] = level.alliesPointsMultiplier;
	//points scalar for axis team
	level.axisPointsMultiplier = getDvarIntDefault( "LRZ4_axisPointsMultiplier", 1 );
	level.zombie_vars[ "axis" ][ "zombie_point_scalar" ] = level.axisPointsMultiplier;
	//sets the radius of emps explosion lower this to 1 to render emps useless
	level.empPerkExplosionRadius = getDvarIntDefault( "LRZ4_empPerkExplosionRadius", 420 );
	level.zombie_vars[ "emp_perk_off_range" ] = level.empPerkExplosionRadius;
	//sets the duration of emps on perks set to 0 for infiinite emps
	level.empPerkOffDuration = getDvarIntDefault( "LRZ4_empPerkOffDuration", 90 );
	level.zombie_vars[ "emp_perk_off_time" ] = level.empPerkOffDuration;
	//riotshield health 
	level.riotshieldHitPoints = getDvarIntDefault( "LRZ4_riotshieldHitPoints", 2250 );
	level.zombie_vars[ "riotshield_hit_points" ] = level.riotshieldHitPoints;
	//jugg health bonus
	level.juggHealthBonus = getDvarIntDefault( "LRZ4_juggHealthBonus", 160 );
	level.zombie_vars[ "zombie_perk_juggernaut_health" ] = level.juggHealthBonus;	
	//perma jugg health bonus 
	level.permaJuggHealthBonus = getDvarIntDefault( "LRZ4_permaJuggHealthBonus", 190 );
	level.zombie_vars[ "zombie_perk_juggernaut_health_upgrade" ] = level.permaJuggHealthBonus;
	//phd min explosion damage
	level.minPhdExplosionDamage = getDvarIntDefault( "LRZ4_minPhdExplosionDamage", 1000 );
	level.zombie_vars[ "zombie_perk_divetonuke_min_damage" ] = level.minPhdExplosionDamage;
	//phd max explosion damage
	level.maxPhdExplosionDamage = getDvarIntDefault( "LRZ4_maxPhdExplosionDamage", 5000 );
	level.zombie_vars[ "zombie_perk_divetonuke_max_damage" ] = level.maxPhdExplosionDamage;
	//phd explosion radius
	level.phdDamageRadius = getDvarIntDefault( "LRZ4_phdDamageRadius", 300 );
	level.zombie_vars[ "zombie_perk_divetonuke_radius" ] = level.phdDamageRadius;
	//zombie counter onscreen
	level.enableZombieCounter = getDvarIntDefault( "LRZ4_enableZombieCounter", 1 );
	level.zombie_vars[ "enableZombieCounter" ] = level.enableZombieCounter;*/
	//change mystery box price
	level.customMysteryBoxPriceEnabled = getDvarIntDefault( "LRZ5_customMysteryBoxPriceEnabled", 0 );
	level.zombie_vars[ "customMysteryBoxPriceEnabled" ] = level.customMysteryBoxPriceEnabled;
	//set mystery box price
	level.customMysteryBoxPrice = getDvarIntDefault( "LRZ5_customMysteryBoxPrice", 500 );
	level.zombie_vars[ "customMysteryBoxPrice" ] = level.customMysteryBoxPrice;
	//disable custom perks
	level.disableAllCustomPerks = getDvarIntDefault( "LRZ5_disableAllCustomPerks", 0 );
	level.zombie_vars[ "disableAllCustomPerks" ] = level.disableAllCustomPerks;
	//enable custom phdflopper
	level.enablePHDFlopper = getDvarIntDefault( "LRZ5_enablePHDFlopper", 1 );
	level.zombie_vars[ "enablePHDFlopper" ] = level.enablePHDFlopper;
	//enable custom staminup
	level.enableStaminUp = getDvarIntDefault( "LRZ5_enableStaminUp", 1 );
	level.zombie_vars[ "enableStaminUp" ] = level.enableStaminUp;
	//enable custom deadshot
	level.enableDeadshot = getDvarIntDefault( "LRZ5_enableDeadshot", 1 );
	level.zombie_vars[ "enableDeadshot" ] = level.enableDeadshot;
	//enable custom mule kick
	level.enableMuleKick = getDvarIntDefault( "LRZ5_enableMuleKick", 1 );
	level.zombie_vars[ "enableMuleKick" ] = level.enableMuleKick;
	//disable_specific_powerups();
	zpp_checks();
	//thread zombies_always_drop_powerups();
	//thread zombies_per_round_override();
	//thread zombie_health_override();
	//thread zombie_health_cap_override();
	//thread zombie_spawn_delay_fix();
	//thread zombie_speed_fix();
}

zpp_checks()
{
	if( level.customMysteryBoxPriceEnabled == 1) //custom mystery box price
	{
		level thread setMysteryBoxPrice();
	}
	/*if ( level.mixed_rounds_enabled )
	{
		if ( level.script != "zm_transit" || is_classic() || level.scr_zm_ui_gametype == "zgrief" )
		{
			level.mixed_rounds_enabled = 0;
		}
	}
    */
	if ( level.start_weapon == "" || level.start_weapon== "m1911_zm" )
	{
		level.start_weapon = "m1911_zm";
		if ( level.script == "zm_tomb" )
		{
			level.start_weapon = "c96_zm";
		}
	}
	if ( level.default_laststandpistol == "" || level.default_laststandpistol == "m1911_zm" )
	{
		level.default_laststandpistol = "m1911_zm";
		if ( level.script == "zm_tomb" )
		{
			level.default_laststandpistol = "c96_zm";
		}
	}
	if ( level.default_solo_laststandpistol == "" || level.default_solo_laststandpistol == "m1911_upgraded_zm" )
	{
		level.default_solo_laststandpistol = "m1911_upgraded_zm";
		if ( level.script == "zm_tomb" )
		{
			level.default_solo_laststandpistol = "c96_upgraded_zm";
		}
	}

}

setMysteryBoxPrice() //mystery box price
{
	i = 0;
    while (i < level.chests.size)
    {
        level.chests[ i ].zombie_cost = level.customMysteryBoxPrice;
        level.chests[ i ].old_cost = level.customMysteryBoxPrice;
        i++;
    }
}

doPHDdive() //credit to extinct. just edited to add self.hasPHD variable
{
	self endon("disconnect");
	level endon("end_game");
	
	for(;;)
	{
		if(isDefined(self.divetoprone) && self.divetoprone)
		{
			if(self isOnGround() && isDefined(self.hasPHD))
			{
				if(level.script == "zm_tomb" || level.script == "zm_buried")	
					explosionfx = level._effect["divetonuke_groundhit"];
				else
					explosionfx = loadfx("explosions/fx_default_explosion");
				self playSound("zmb_phdflop_explo");
				playfx(explosionfx, self.origin);
				self damageZombiesInRange(310, self, "kill");
				wait .3;
			}
		}
		wait .05;
	}
}

damageZombiesInRange(range, what, amount) //damage zombies for phd flopper
{
	enemy = getAiArray(level.zombie_team);
	foreach(zombie in enemy)
	{
		if(distance(zombie.origin, what.origin) < range)
		{
			if(amount == "kill")
				zombie doDamage(zombie.health * 2, zombie.origin, self);
			else
				zombie doDamage(amount, zombie.origin, self);
		}
	}
}

phd_flopper_dmg_check( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex ) //phdflopdmgchecker lmao
{
	if ( smeansofdeath == "MOD_SUICIDE" || smeansofdeath == "MOD_FALLING" || smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" || smeansofdeath == "MOD_EXPLOSIVE" )
	{
		if(isDefined(self.hasPHD)) //if player has phd flopper, dont damage the player
			return;
	}
	[[ level.playerDamageStub ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex );
}

CustomPerkMachine( bottle, model, perkname, cost, origin, perk, angles ) //custom perk system. orginal code from ZeiiKeN. edited to work for all maps and custom phd perk
{
	level endon( "end_game" );
	if(!isDefined(level.customPerkNum))
		level.customPerkNum = 1;
	else
		level.customPerkNum += 1;
	collision = spawn("script_model", origin);
    collision setModel("collision_geo_cylinder_32x128_standard");
    collision rotateTo(angles, .1);
	RPerks = spawn( "script_model", origin );
	RPerks setModel( model );
	RPerks rotateTo(angles, .1);
	level thread LowerMessage( "Custom Perks", "Hold ^3F ^7for "+perkname+" [Cost: "+cost+"]" );
	trig = spawn("trigger_radius", origin, 1, 25, 25);
	trig SetCursorHint( "HINT_NOICON" );
	trig setLowerMessage( trig, "Custom Perks" );
	for(;;)
	{
		trig waittill("trigger", player);
		if(player useButtonPressed() && player.score >= cost)
		{
			wait .25;
			if(player useButtonPressed())
			{
				if(perk != "PHD_FLOPPER" && !player hasPerk(perk) || perk == "PHD_FLOPPER" && !isDefined(player.hasPHD))
				{
					player playsound( "zmb_cha_ching" ); //money shot
					player.score -= cost; //take points
					level.trig hide();
					player thread zpp_GivePerk( bottle, perk, perkname ); //give perk
					wait 2;
					level.trig show();
				}
				else
					player iprintln("You Already Have "+perkname+"!");
			}
		}
	}
}

zpp_startCustomPerkMachines()
{
	if(level.disableAllCustomPerks == 0)
	{
		if(getDvar("mapname") == "zm_prison" && getDvar("CUSTOM_MAP") == "0") //mob of the dead
		{
			if(level.enablePHDFlopper == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_deadshot", "p6_zm_al_vending_nuke_on", "PHD Flopper", 3000, (2427.45, 10048.4, 1704.13), "PHD_FLOPPER", (0, 0, 0) );
			if(level.enableStaminUp == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_deadshot", "p6_zm_al_vending_doubletap2_on", "Stamin-Up", 2000, (-339.642, -3915.84, -8447.88), "specialty_longersprint", (0, 270, 0) );
		}
		else if(getDvar("mapname") == "zm_highrise" && getDvar("CUSTOM_MAP") == "0") //die rise
		{
			if(level.enablePHDFlopper == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_whoswho", "zombie_vending_nuke_on_lo", "PHD Flopper", 3000, (1260.3, 2736.36, 3047.49), "PHD_FLOPPER", (0, 0, 0) );
			if(level.enableDeadshot == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_whoswho", "zombie_vending_revive", "Deadshot Daiquiri", 1500, (3690.54, 1932.36, 1420), "specialty_deadshot", (-15, 0, 0) );
			if(level.enableStaminUp == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_revive", "zombie_vending_doubletap2", "Stamin-Up", 2000, (1704, -35, 1120.13), "specialty_longersprint", (0, -30, 0) );
		}
		else if(getDvar("mapname") == "zm_buried" && getDvar("CUSTOM_MAP") == "0") //buried
		{
			if(level.enablePHDFlopper == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_marathon", "zombie_vending_jugg", "PHD Flopper", 3000, (2631.73, 304.165, 240.125), "PHD_FLOPPER", (5, 0, 0) );
			if(level.enableDeadshot == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_marathon", "zombie_vending_revive", "Deadshot Daiquiri", 1500, (1055.18, -1055.55, 201), "specialty_deadshot", (3, 270, 0) );
		}
		else if(getDvar("mapname") == "zm_nuked" && getDvar("CUSTOM_MAP") == "0") //nuketown
		{
			if(level.enablePHDFlopper == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_revive", "zombie_vending_jugg", "PHD Flopper", 3000, (683, 727, -56), "PHD_FLOPPER", (5, 250, 0) );
			if(level.enableDeadshot == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_jugg", "zombie_vending_revive", "Deadshot Daiquiri", 1500, (747, 356, 91), "specialty_deadshot", (0, 330, 0) );
			if(level.enableStaminUp == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_revive", "zombie_vending_doubletap2", "Stamin-Up", 2000, (-638, 268, -54), "specialty_longersprint", (0, 165, 0) );
			if(level.enableMuleKick == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_jugg", "zombie_vending_sleight", "Mule Kick", 3000, (-953, 715, 83), "specialty_additionalprimaryweapon", (0, 75, 0) );
		}
		else if(getDvar("mapname") == "zm_transit" && getDvar("CUSTOM_MAP") == "0") //transit
		{
			if(level.enablePHDFlopper == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_revive", "zombie_vending_jugg", "PHD Flopper", 3000, (-6304, 5430, -55), "PHD_FLOPPER", (0, 90, 0) );
			if(level.enableDeadshot == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_jugg", "zombie_vending_revive", "Deadshot Daiquiri", 1500, (-6088, -7419, 0), "specialty_deadshot", (0, 90, 0) );
			if(level.enableMuleKick == 1)
				level thread CustomPerkMachine( "zombie_perk_bottle_jugg", "zombie_vending_sleight", "Mule Kick", 3000, (1149, -215, -304), "specialty_additionalprimaryweapon", (0, 180, 0) );
		}
	}
}

solo_tombstone_removal()
{
	level notify( "tombstone_on" );
}

turn_tombstone_on()
{
	while ( 1 )
	{
		machine = getentarray( "vending_tombstone", "targetname" );
		machine_triggers = getentarray( "vending_tombstone", "target" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "tombstone" ].off_model );
			i++;
		}
		level thread do_initial_power_off_callback( machine, "tombstone" );
		array_thread( machine_triggers, ::set_power_on, 0 );
		level waittill( "tombstone_on" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "tombstone" ].on_model );
			machine[ i ] vibrate( vectorScale( ( 0, -1, 0 ), 100 ), 0,3, 0,4, 3 );
			machine[ i ] playsound( "zmb_perks_power_on" );
			machine[ i ] thread perk_fx( "tombstone_light" );
			machine[ i ] thread play_loop_on_machine();
			i++;
		}
		level notify( "specialty_scavenger_power_on" );
		array_thread( machine_triggers, ::set_power_on, 1 );
		if ( isDefined( level.machine_assets[ "tombstone" ].power_on_callback ) )
		{
			array_thread( machine, level.machine_assets[ "tombstone" ].power_on_callback );
		}
		level waittill( "tombstone_off" );
		if ( isDefined( level.machine_assets[ "tombstone" ].power_off_callback ) )
		{
			array_thread( machine, level.machine_assets[ "tombstone" ].power_off_callback );
		}
		array_thread( machine, ::turn_perk_off );
		players = get_players();
		_a1718 = players;
		_k1718 = getFirstArrayKey( _a1718 );
		while ( isDefined( _k1718 ) )
		{
			player = _a1718[ _k1718 ];
			player.hasperkspecialtytombstone = undefined;
			_k1718 = getNextArrayKey( _a1718, _k1718 );
		}
	}
}

perk_machine_spawn_init()
{
	match_string = "";
	location = level.scr_zm_map_start_location;
	if ( location != "default" && location == "" && isDefined( level.default_start_location ) )
	{
		location = level.default_start_location;
	}
	match_string = ( level.scr_zm_ui_gametype + "_perks_" ) + location;
	pos = [];
	if ( isDefined( level.override_perk_targetname ) )
	{
		structs = getstructarray( level.override_perk_targetname, "targetname" );
	}
	else
	{
		structs = getstructarray( "zm_perk_machine", "targetname" );
	}
	_a3578 = structs;
	_k3578 = getFirstArrayKey( _a3578 );
	while ( isDefined( _k3578 ) )
	{
		struct = _a3578[ _k3578 ];
		if ( isDefined( struct.script_string ) )
		{
			tokens = strtok( struct.script_string, " " );
			_a3583 = tokens;
			_k3583 = getFirstArrayKey( _a3583 );
			while ( isDefined( _k3583 ) )
			{
				token = _a3583[ _k3583 ];
				if ( token == match_string )
				{
					pos[ pos.size ] = struct;
				}
				_k3583 = getNextArrayKey( _a3583, _k3583 );
			}
		}
		else pos[ pos.size ] = struct;
		_k3578 = getNextArrayKey( _a3578, _k3578 );
	}
	if ( !isDefined( pos ) || pos.size == 0 )
	{
		return;
	}
	precachemodel( "zm_collision_perks1" );
	i = 0;
	while ( i < pos.size )
	{
		perk = pos[ i ].script_noteworthy;
		if ( isDefined( perk ) && isDefined( pos[ i ].model ) )
		{
			use_trigger = spawn( "trigger_radius_use", pos[ i ].origin + vectorScale( ( 0, -1, 0 ), 30 ), 0, 40, 70 );
			use_trigger.targetname = "zombie_vending";
			use_trigger.script_noteworthy = perk;
			use_trigger triggerignoreteam();
			perk_machine = spawn( "script_model", pos[ i ].origin );
			perk_machine.angles = pos[ i ].angles;
			perk_machine setmodel( pos[ i ].model );
			if ( isDefined( level._no_vending_machine_bump_trigs ) && level._no_vending_machine_bump_trigs )
			{
				bump_trigger = undefined;
			}
			else
			{
				bump_trigger = spawn( "trigger_radius", pos[ i ].origin, 0, 35, 64 );
				bump_trigger.script_activated = 1;
				bump_trigger.script_sound = "zmb_perks_bump_bottle";
				bump_trigger.targetname = "audio_bump_trigger";
				if ( perk != "specialty_weapupgrade" )
				{
					bump_trigger thread thread_bump_trigger();
				}
			}
			collision = spawn( "script_model", pos[ i ].origin, 1 );
			collision.angles = pos[ i ].angles;
			collision setmodel( "zm_collision_perks1" );
			collision.script_noteworthy = "clip";
			collision disconnectpaths();
			use_trigger.clip = collision;
			use_trigger.machine = perk_machine;
			use_trigger.bump = bump_trigger;
			if ( isDefined( pos[ i ].blocker_model ) )
			{
				use_trigger.blocker_model = pos[ i ].blocker_model;
			}
			if ( isDefined( pos[ i ].script_int ) )
			{
				perk_machine.script_int = pos[ i ].script_int;
			}
			if ( isDefined( pos[ i ].turn_on_notify ) )
			{
				perk_machine.turn_on_notify = pos[ i ].turn_on_notify;
			}
			if ( perk == "specialty_scavenger" || perk == "specialty_scavenger_upgrade" )
			{
				use_trigger.script_sound = "mus_perks_tombstone_jingle";
				use_trigger.script_string = "tombstone_perk";
				use_trigger.script_label = "mus_perks_tombstone_sting";
				use_trigger.target = "vending_tombstone";
				perk_machine.script_string = "tombstone_perk";
				perk_machine.targetname = "vending_tombstone";
				if ( isDefined( bump_trigger ) )
				{
					bump_trigger.script_string = "tombstone_perk";
				}
			}
			if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].perk_machine_set_kvps ) )
			{
				[[ level._custom_perks[ perk ].perk_machine_set_kvps ]]( use_trigger, perk_machine, bump_trigger, collision );
			}
		}
		i++;
	}
}

isTown()
{
	if (isDefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
	{
		level thread perk_machine_spawn_init();
		thread solo_tombstone_removal();
		thread turn_tombstone_on();
	}
}

give_afterlife_loadout()
{

	self takeallweapons();
	loadout = self.loadout;
	primaries = self getweaponslistprimaries();
	if ( loadout.weapons.size > 1 || primaries.size > 1 )
	{
		foreach ( weapon in primaries )
		{
			self takeweapon( weapon );
		}
	}
	i = 0;
	while ( i < loadout.weapons.size )
	{

		if ( !isDefined( loadout.weapons[ i ] ) )
		{
			i++;

			continue;
		}
		if ( loadout.weapons[ i ][ "name" ] == "none" )
		{
			i++;

			continue;
		}
		self maps\mp\zombies\_zm_weapons::weapondata_give( loadout.weapons[ i ] );
		i++;
	}
	self setspawnweapon( loadout.weapons[ loadout.current_weapon ] );
	self switchtoweaponimmediate( loadout.weapons[ loadout.current_weapon ] );
	if ( isDefined( self get_player_melee_weapon() ) )
	{
		self giveweapon( self get_player_melee_weapon() );
	}
	self maps\mp\zombies\_zm_equipment::equipment_give( self.loadout.equipment );
	if ( isDefined( loadout.hasclaymore ) && loadout.hasclaymore && !self hasweapon( "claymore_zm" ) )
	{
		self giveweapon( "claymore_zm" );
		self set_player_placeable_mine( "claymore_zm" );
		self setactionslot( 4, "weapon", "claymore_zm" );
		self setweaponammoclip( "claymore_zm", loadout.claymoreclip );
	}
	if ( isDefined( loadout.hasemp ) && loadout.hasemp )
	{
		self giveweapon( "emp_grenade_zm" );
		self setweaponammoclip( "emp_grenade_zm", loadout.empclip );
	}
	if ( isDefined( loadout.hastomahawk ) && loadout.hastomahawk )
	{
		self giveweapon( self.current_tomahawk_weapon );
		self set_player_tactical_grenade( self.current_tomahawk_weapon );
		self setclientfieldtoplayer( "tomahawk_in_use", 1 );
	}
	self.score = loadout.score;
	perk_array = maps\mp\zombies\_zm_perks::get_perk_array( 1 );
	i = 0;
	while ( i < perk_array.size )
	{
		perk = perk_array[ i ];
		self unsetperk( perk );
		self set_perk_clientfield( perk, 0 );
		i++;
	}
	if (is_true(self.keep_perks))
	{
		if(is_true(self.hadphd))
		{
			self.hasphd = true;
			self.hadphd = undefined;
			self thread drawCustomPerkHUD("specialty_doubletap_zombies", 0, (1, 0.25, 1));
		}
	}
	if ( isDefined( self.keep_perks ) && self.keep_perks && isDefined( loadout.perks ) && loadout.perks.size > 0 )
	{
		i = 0;
		while ( i < loadout.perks.size )
		{
			if ( self hasperk( loadout.perks[ i ] ) )
			{
				i++;
				continue;
			}
			if ( loadout.perks[ i ] == "specialty_quickrevive" && flag( "solo_game" ) )
			{
				level.solo_game_free_player_quickrevive = 1;
			}
			if ( loadout.perks[ i ] == "specialty_longersprint" )
			{
				self setperk( "specialty_longersprint" ); //removes the staminup perk functionality
				self.hasStaminUp = true; //resets the staminup variable
				self thread drawCustomPerkHUD("specialty_juggernaut_zombies", 0, (1, 1, 0));
				arrayremovevalue( loadout.perks, "specialty_longersprint" );

				continue;
			}
			if ( loadout.perks[ i ] == "specialty_additionalprimaryweapon" )
			{
				self setperk( "specialty_additionalprimaryweapon"); //removes the deadshot perk functionality
				self.hasMuleKick = true; //resets the deadshot variable
				self thread drawCustomPerkHUD("specialty_fastreload_zombies", 0, (0, 0.7, 0));
				arrayremovevalue( loadout.perks, "specialty_additionalprimaryweapon" );
				continue;
			}
			if ( loadout.perks[ i ] == "specialty_finalstand" )
			{
				i++;
				continue;
			}
			maps\mp\zombies\_zm_perks::give_perk( loadout.perks[ i ] );
			i++;
			wait 0.05;
		}
	}
	self.keep_perks = undefined;
	self set_player_lethal_grenade( self.loadout.lethal_grenade );
	if ( loadout.grenade > 0 )
	{
		curgrenadecount = 0;
		if ( self hasweapon( self get_player_lethal_grenade() ) )
		{
			self getweaponammoclip( self get_player_lethal_grenade() );
		}
		else
		{
			self giveweapon( self get_player_lethal_grenade() );
		}
		self setweaponammoclip( self get_player_lethal_grenade(), loadout.grenade + curgrenadecount );
	}

}
save_afterlife_loadout() //checked changed to match cerberus output
{
	primaries = self getweaponslistprimaries();
	currentweapon = self getcurrentweapon();
	self.loadout = spawnstruct();
	self.loadout.player = self;
	self.loadout.weapons = [];
	self.loadout.score = self.score;
	self.loadout.current_weapon = -1;
	index = 0;
	foreach ( weapon in primaries )
	{
		self.loadout.weapons[ index ] = maps\mp\zombies\_zm_weapons::get_player_weapondata( self, weapon );
		if ( weapon == currentweapon || self.loadout.weapons[ index ][ "alt_name" ] == currentweapon )
		{
			self.loadout.current_weapon = index;
		}
		index++;
	}
	self.loadout.equipment = self get_player_equipment();
	if ( isDefined( self.loadout.equipment ) )
	{
		self maps\mp\zombies\_zm_equipment::equipment_take( self.loadout.equipment );
	}
	if ( self hasweapon( "claymore_zm" ) )
	{
		self.loadout.hasclaymore = 1;
		self.loadout.claymoreclip = self getweaponammoclip( "claymore_zm" );
	}
	if ( self hasweapon( "emp_grenade_zm" ) )
	{
		self.loadout.hasemp = 1;
		self.loadout.empclip = self getweaponammoclip( "emp_grenade_zm" );
	}
	if ( self hasweapon( "bouncing_tomahawk_zm" ) || self hasweapon( "upgraded_tomahawk_zm" ) )
	{
		self.loadout.hastomahawk = 1;
		self setclientfieldtoplayer( "tomahawk_in_use", 0 );
	}
	self.loadout.perks = afterlife_save_perks( self );
	lethal_grenade = self get_player_lethal_grenade();
	if ( self hasweapon( lethal_grenade ) )
	{
		self.loadout.grenade = self getweaponammoclip( lethal_grenade );
	}
	else
	{
		self.loadout.grenade = 0;
	}
	self.loadout.lethal_grenade = lethal_grenade;
	self set_player_lethal_grenade( undefined );
}

afterlife_save_perks( ent ) //checked changed to match cerberus output
{
	perk_array = ent get_perk_array( 1 );
	foreach ( perk in perk_array )
	{
		ent unsetperk( perk );
	}
	return perk_array;
}
onPlayerRevived()
{
	self endon("disconnect");
	level endon("end_game");
	
	for(;;)
	{
		self waittill_any( "whos_who_self_revive","player_revived","fake_revive","do_revive_ended_normally", "al_t" );
		wait 1;
		if(is_true(self.hadPHD))
		{
			self setperk( "PHD_FLOPPER" ); //removes the staminup perk functionality
			self.hasPHD = true;
			self.hadPHD = undefined;
			self thread drawCustomPerkHUD("specialty_doubletap_zombies", 0, (1, 0.25, 1));
		}
		else
			return;
	}
}
