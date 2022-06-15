bot_set_skill()
{
	setdvar( "bot_MinDeathTime", "250" );
	setdvar( "bot_MaxDeathTime", "500" );
	setdvar( "bot_MinFireTime", "100" );
	setdvar( "bot_MaxFireTime", "250" );
	setdvar( "bot_PitchUp", "-5" );
	setdvar( "bot_PitchDown", "10" );
	setdvar( "bot_Fov", "160" );
	setdvar( "bot_MinAdsTime", "3000" );
	setdvar( "bot_MaxAdsTime", "5000" );
	setdvar( "bot_MinCrouchTime", "100" );
	setdvar( "bot_MaxCrouchTime", "400" );
	setdvar( "bot_TargetLeadBias", "2" );
	setdvar( "bot_MinReactionTime", "40" );
	setdvar( "bot_MaxReactionTime", "70" );
	setdvar( "bot_StrafeChance", "1" );
	setdvar( "bot_MinStrafeTime", "3000" );
	setdvar( "bot_MaxStrafeTime", "6000" );
	setdvar( "scr_help_dist", "512" );
	setdvar( "bot_AllowGrenades", "1" );
	setdvar( "bot_MinGrenadeTime", "1500" );
	setdvar( "bot_MaxGrenadeTime", "4000" );
	setdvar( "bot_MeleeDist", "70" );
	setdvar( "bot_YawSpeed", "4" );
	setdvar( "bot_SprintDistance", "256" );
}

bot_get_closest_enemy( origin )
{
	enemies = getaispeciesarray( level.zombie_team, "all" );
	enemies = arraysort( enemies, origin );
	if ( enemies.size >= 1 )
	{
		return enemies[ 0 ];
	}
	return undefined;
}

spawn_bot()
{
	bot = addtestclient("CUM", "IN ME");
	bot waittill("spawned_player");
	bot thread maps\mp\zombies\_zm::spawnspectator();
	if ( isDefined( bot ) )
	{
		bot.pers[ "isBot" ] = 1;
		bot thread onspawn();
	}
	wait 1;
	bot [[ level.spawnplayer ]]();
}

bot_spawn()
{
	self bot_spawn_init();
	self thread bot_main();
}

bot_spawn_init()
{
	if(level.script == "zm_tomb")
	{
		self SwitchToWeapon("c96_zm");
		self SetSpawnWeapon("c96_zm");
	}
	self SwitchToWeapon("m1911_zm");
	self SetSpawnWeapon("m1911_zm");
	time = getTime();
	if ( !isDefined( self.bot ) )
	{
		self.bot = spawnstruct();
		self.bot.threat = spawnstruct();
	}
	self.bot.glass_origin = undefined;
	self.bot.ignore_entity = [];
	self.bot.previous_origin = self.origin;
	self.bot.time_ads = 0;
	self.bot.update_c4 = time + randomintrange( 1000, 3000 );
	self.bot.update_crate = time + randomintrange( 1000, 3000 );
	self.bot.update_crouch = time + randomintrange( 1000, 3000 );
	self.bot.update_failsafe = time + randomintrange( 1000, 3000 );
	self.bot.update_idle_lookat = time + randomintrange( 1000, 3000 );
	self.bot.update_killstreak = time + randomintrange( 1000, 3000 );
	self.bot.update_lookat = time + randomintrange( 1000, 3000 );
	self.bot.update_objective = time + randomintrange( 1000, 3000 );
	self.bot.update_objective_patrol = time + randomintrange( 1000, 3000 );
	self.bot.update_patrol = time + randomintrange( 1000, 3000 );
	self.bot.update_toss = time + randomintrange( 1000, 3000 );
	self.bot.update_launcher = time + randomintrange( 1000, 3000 );
	self.bot.update_weapon = time + randomintrange( 1000, 3000 );
	self.bot.think_interval = 0.1;
	self.bot.fov = -0.9396;
	self.bot.threat.entity = undefined;
	self.bot.threat.position = ( 0, 0, 0 );
	self.bot.threat.time_first_sight = 0;
	self.bot.threat.time_recent_sight = 0;
	self.bot.threat.time_aim_interval = 0;
	self.bot.threat.time_aim_correct = 0;
	self.bot.threat.update_riotshield = 0;
}

bot_main()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	self thread bot_wakeup_think();
	self thread bot_damage_think();
	self thread bot_give_ammo();
	self thread bot_reset_flee_goal();
	for ( ;; )
	{
		self waittill( "wakeup", damage, attacker, direction );
		if( self isremotecontrolling())
		{
			continue;
		}
		else
		{
			self bot_combat_think( damage, attacker, direction );
			self bot_update_follow_host();
			self bot_update_lookat();
			self bot_teleport_think();
			if(is_true(level.using_bot_weapon_logic))
			{
				self bot_buy_wallbuy();
				self bot_pack_gun();
			}
			if(is_true(level.using_bot_revive_logic))
			{
				self bot_revive_teammates();
			}
			self bot_pickup_powerup();
			//self bot_buy_box();
			//HIGH PRIORITY: PICKUP POWERUP
			//WHEN GIVING BOTS WEAPONS, YOU MUST USE setspawnweapon() FUNCTION!!!
			//ADD OTHER NON-COMBAT RELATED TASKS HERE (BUYING GUNS, CERTAIN GRIEF MECHANICS)
			//ANYTHING THAT CAN BE DONE WHILE THE BOT IS NOT THREATENED BY A ZOMBIE
		}	
	}
}

bot_teleport_think()
{
	self endon("death");
	self endon("disconnect");
	level endon("end_game");
	players = get_players();
	if(Distance(self.origin, players[0].origin) > 1500 && players[0] IsOnGround())
	{
		self SetOrigin(players[0].origin + (0,50,0));
	}
}

bot_reset_flee_goal()
{
	self endon("death");
	self endon("disconnect");
	level endon("end_game");
	while(1)
	{
		self CancelGoal("flee");
		wait 2;
	}
}

bot_revive_teammates()
{
	if(!maps\mp\zombies\_zm_laststand::player_any_player_in_laststand() || self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		self cancelgoal("revive");
		return;
	}
	if(!self hasgoal("revive"))
	{
		teammate = self get_closest_downed_teammate();
		if(!isdefined(teammate))
			return;
		self AddGoal(teammate.origin, 50, 3, "revive");
	}
	else
	{
		if(self AtGoal("revive") || Distance(self.origin, self GetGoal("revive")) < 75)
		{
			teammate = self get_closest_downed_teammate();
			teammate.revivetrigger disable_trigger();
			wait 0.75;
			teammate.revivetrigger enable_trigger();
			if(!self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && teammate maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			{
				teammate maps\mp\zombies\_zm_laststand::auto_revive( self );
			}
		}
	}
}

bot_pickup_powerup()
{
	if(maps\mp\zombies\_zm_powerups::get_powerups(self.origin, 1000).size == 0)
	{
		self CancelGoal("powerup");
		return;
	}
	powerups = maps\mp\zombies\_zm_powerups::get_powerups(self.origin, 1000);
	foreach(powerup in powerups)
	{
		if(FindPath(self.origin, powerup.origin, undefined, 0, 1))
		{
			self AddGoal(powerup.origin, 25, 2, "powerup");
			if(self AtGoal("powerup") || Distance(self.origin, powerup.origin) < 50)
			{
				self CancelGoal("powerup");
			}
			return;
		}
	}
}

get_closest_downed_teammate()
{
	if(!maps\mp\zombies\_zm_laststand::player_any_player_in_laststand())
		return;
	downed_players = [];
	foreach(player in get_players())
	{
		if(player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		downed_players[downed_players.size] = player;
	}
	downed_players = arraysort(downed_players, self.origin);
	return downed_players[0];

}

bot_pack_gun()
{
	if(level.round_number <= 1)
		return;
	if(!self bot_should_pack())
		return;
	machines = GetEntArray("zombie_vending", "targetname");
	foreach(pack in machines)
	{
		if(pack.script_noteworthy != "specialty_weapupgrade")
			continue;
		if(Distance(pack.origin, self.origin) < 400 && self.score >= 5000 && FindPath(self.origin, pack.origin, undefined, 0, 1))
		{
			self maps\mp\zombies\_zm_score::minus_to_player_score(5000);
			weapon = self GetCurrentWeapon();
			upgrade_name = maps\mp\zombies\_zm_weapons::get_upgrade_weapon( weapon );
			self TakeAllWeapons();
			self GiveWeapon(upgrade_name);
			self SetSpawnWeapon(upgrade_name);
			return;
		}
	}
}

bot_buy_wallbuy()
{
	self endon("death");
	self endon("disconnect");
	level endon("end_game");
	if(self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade("mp5k_zm") || self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade("pdw57_zm") || self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		self CancelGoal("weaponBuy");
		return;
	}
	weapon = self GetCurrentWeapon();
	weaponToBuy = undefined;
	wallbuys = array_randomize(level._spawned_wallbuys);
	foreach(wallbuy in wallbuys)
	{
		if(Distance(wallbuy.origin, self.origin) < 400 && wallbuy.trigger_stub.cost <= self.score && bot_best_gun(wallbuy.trigger_stub.zombie_weapon_upgrade, weapon) && FindPath(self.origin, wallbuy.origin, undefined, 0, 1) && weapon != wallbuy.trigger_stub.zombie_weapon_upgrade && !is_offhand_weapon( wallbuy.trigger_stub.zombie_weapon_upgrade ))
		{
			if(!isdefined(wallbuy.trigger_stub))
				return;
			if(!isdefined(wallbuy.trigger_stub.zombie_weapon_upgrade))
				return;
			weaponToBuy = wallbuy;
			break;
		}
	}
	if(!isdefined(weaponToBuy))
		return;
	self AddGoal(weaponToBuy.origin, 75, 2, "weaponBuy");
	//IPrintLn(weaponToBuy.zombie_weapon_upgrade);
	while(!self AtGoal("weaponBuy") && !Distance(self.origin, weaponToBuy.origin) < 100)
	{
		wait 1;
		if(self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			self cancelgoal("weaponBuy");
			return;
		}
	}
	self cancelgoal("weaponBuy");
	self maps\mp\zombies\_zm_score::minus_to_player_score( weaponToBuy.trigger_stub.cost );
	self TakeAllWeapons();
	self GiveWeapon(weaponToBuy.trigger_stub.zombie_weapon_upgrade);
	self SetSpawnWeapon(weaponToBuy.trigger_stub.zombie_weapon_upgrade);
	//IPrintLn("Bot Bought Weapon");
	
}

bot_should_pack()
{
	if(maps\mp\zombies\_zm_weapons::can_upgrade_weapon(self GetCurrentWeapon()))
		return 1;
	return 0;
}

bot_best_gun(buyingweapon, currentweapon)
{
	if(buyingweapon == "mp5k_zm" || buyingweapon == "pdw57_zm")
		return 1;
	if(maps\mp\zombies\_zm_weapons::get_weapon_cost(buyingweapon) > maps\mp\zombies\_zm_weapons::get_weapon_cost(currentweapon))
		return 1;
	return 0;
}

bot_wakeup_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	for ( ;; )
	{
		wait self.bot.think_interval;
		self notify( "wakeup" );
	}
}

bot_damage_think()
{
	self notify( "bot_damage_think" );
	self endon( "bot_damage_think" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, mod, unused1, unused2, unused3, weapon, flags, inflictor );
		self.bot.attacker = attacker;
		self notify( "wakeup", damage, attacker, direction );
	}
}

bot_give_ammo()
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );
	for(;;)
	{
		primary_weapons = self GetWeaponsListPrimaries();
		j=0;
		while(j<primary_weapons.size)
		{
			self GiveMaxAmmo(primary_weapons[ j ]);
			j++;
		}
		wait 1;
	}
}

onspawn()
{
	self endon("disconnect");
	level endon("end_game");
	while(1)
	{
		self waittill("spawned_player");
		self thread bot_perks();
		self thread bot_spawn();
	}
}

bot_perks()
{
	self endon("disconnect");
	self endon("death");
	wait 1;
	while(1)
	{
		self SetNormalHealth(250);
		self SetmaxHealth(250);
		self SetPerk("specialty_flakjacket");
		self SetPerk("specialty_rof");
		self SetPerk("specialty_fastreload");
		self waittill("player_revived");
	}
}

bot_update_follow_host()
{
	//goal = self GetGoal("wander");
	//if(distance(goal, self.origin) > 100)
	//	return;
	//if(distance(self.origin, get_players[0].origin) > 3000)
	self AddGoal(get_players()[0].origin, 200, 1, "wander");
	//self lookat(get_players()[0].origin);
	//else
	//	self AddGoal()	
}

bot_update_lookat()
{
	path = 0;
	if ( isDefined( self getlookaheaddir() ) )
	{
		path = 1;
	}
	if ( !path && getTime() > self.bot.update_idle_lookat )
	{
		origin = bot_get_look_at();
		if ( !isDefined( origin ) )
		{
			return;
		}
		self lookat( origin + vectorScale( ( 0, 0, 1 ), 16 ) );
		self.bot.update_idle_lookat = getTime() + randomintrange( 1500, 3000 );
	}
	else if ( path && self.bot.update_idle_lookat > 0 )
	{
		self clearlookat();
		self.bot.update_idle_lookat = 0;
	}
}

bot_get_look_at()
{
	enemy = bot_get_closest_enemy( self.origin );
	if ( isDefined( enemy ) )
	{
		node = getvisiblenode( self.origin, enemy.origin );
		if ( isDefined( node ) && distancesquared( self.origin, node.origin ) > 1024 )
		{
			return node.origin;
		}
	}
	spawn = self getgoal( "wander" );
	if ( isDefined( spawn ) )
	{
		node = getvisiblenode( self.origin, spawn );
	}
	if ( isDefined( node ) && distancesquared( self.origin, node.origin ) > 1024 )
	{
		return node.origin;
	}
	return undefined;
}

bot_update_weapon()
{
	weapon = self GetCurrentWeapon();
	primaries = self getweaponslistprimaries();
	foreach ( primary in primaries )
	{
		if ( primary != weapon )
		{
			self switchtoweapon( primary );
			return;
		}
		i++;
	}
}

bot_update_failsafe()
{
	time = getTime();
	if ( ( time - self.spawntime ) < 7500 )
	{
		return;
	}
	if ( time < self.bot.update_failsafe )
	{
		return;
	}
	if ( !self atgoal() && distance2dsquared( self.bot.previous_origin, self.origin ) < 256 )
	{
		nodes = getnodesinradius( self.origin, 512, 0 );
		nodes = array_randomize( nodes );
		nearest = bot_nearest_node( self.origin );
		failsafe = 0;
		if ( isDefined( nearest ) )
		{
			i = 0;
			while ( i < nodes.size )
			{
				if ( !bot_failsafe_node_valid( nearest, nodes[ i ] ) )
				{
					i++;
					continue;
				}
				else
				{
					self botsetfailsafenode( nodes[ i ] );
					wait 0.5;
					self.bot.update_idle_lookat = 0;
					self bot_update_lookat();
					self cancelgoal( "enemy_patrol" );
					self wait_endon( 4, "goal" );
					self botsetfailsafenode();
					self bot_update_lookat();
					failsafe = 1;
					break;
				}
				i++;
			}
		}
		else if ( !failsafe && nodes.size )
		{
			node = random( nodes );
			self botsetfailsafenode( node );
			wait 0.5;
			self.bot.update_idle_lookat = 0;
			self bot_update_lookat();
			self cancelgoal( "enemy_patrol" );
			self wait_endon( 4, "goal" );
			self botsetfailsafenode();
			self bot_update_lookat();
		}
	}
	self.bot.update_failsafe = getTime() + 3500;
	self.bot.previous_origin = self.origin;
}

bot_failsafe_node_valid( nearest, node )
{
	if ( isDefined( node.script_noteworthy ) )
	{
		return 0;
	}
	if ( ( node.origin[ 2 ] - self.origin[ 2 ] ) > 18 )
	{
		return 0;
	}
	if ( nearest == node )
	{
		return 0;
	}
	if ( !nodesvisible( nearest, node ) )
	{
		return 0;
	}
	if ( isDefined( level.spawn_all ) && level.spawn_all.size > 0 )
	{
		spawns = arraysort( level.spawn_all, node.origin );
	}
	else if ( isDefined( level.spawnpoints ) && level.spawnpoints.size > 0 )
	{
		spawns = arraysort( level.spawnpoints, node.origin );
	}
	else if ( isDefined( level.spawn_start ) && level.spawn_start.size > 0 )
	{
		spawns = arraycombine( level.spawn_start[ "allies" ], level.spawn_start[ "axis" ], 1, 0 );
		spawns = arraysort( spawns, node.origin );
	}
	else
	{
		return 0;
	}
	goal = bot_nearest_node( spawns[ 0 ].origin );
	if ( isDefined( goal ) && findpath( node.origin, goal.origin, undefined, 0, 1 ) )
	{
		return 1;
	}
	return 0;
}

bot_nearest_node( origin )
{
	node = getnearestnode( origin );
	if ( isDefined( node ) )
	{
		return node;
	}
	nodes = getnodesinradiussorted( origin, 256, 0, 256 );
	if ( nodes.size )
	{
		return nodes[ 0 ];
	}
	return undefined;
}

bot_combat_think( damage, attacker, direction )
{
	self allowattack( 0 );
	self pressads( 0 );
	for ( ;; )
	{
		if ( !bot_can_do_combat() )
		{
			return;
		}
		if(self atgoal("flee"))
			self cancelgoal("flee");
		//FLEE CODE. IF ZOMBIE IS CLOSE TO BOT, BOT WILL TRY TO FIND A PLACE TO RUN AWAY
		//LOOKING FOR ANOTHER ALTERNATIVE IF DOORS ARE CLOSED AND THE BOT CAN NOT REACH SAID PATH.
		if(Distance(self.origin, self.bot.threat.position) <= 75 || isdefined(damage))
		{
			nodes = getnodesinradiussorted( self.origin, 1024, 256, 512 );
			nearest = bot_nearest_node(self.origin);
			if ( isDefined( nearest ) && !self hasgoal( "flee" ) )
			{
				foreach ( node in nodes )
				{
					if ( !nodesvisible( nearest, node ) && FindPath(self.origin, node.origin, undefined, 0, 1) )
					{
						self addgoal( node.origin, 24, 4, "flee" );
						break;
					}
				}
			}
		}
		if(self GetCurrentWeapon() == "none")
			return;
		sight = self bot_best_enemy();
		if(!isdefined(self.bot.threat.entity))
			return;
		if ( threat_dead() )
		{
			self bot_combat_dead();
			return;
		}
		//ADD OTHER COMBAT TASKS HERE.
		self bot_combat_main();
		self bot_pickup_powerup();
		if(is_true(level.using_bot_revive_logic))
		{
			self bot_revive_teammates();
		}
		wait 0.05; //fu difficulty
	}
}

bot_combat_main() //checked partially changed to match cerberus output changed at own discretion
{
	weapon = self getcurrentweapon();
	currentammo = self getweaponammoclip( weapon ) + self getweaponammostock( weapon );
	if ( !currentammo )
	{
		return;
	}
	time = getTime();
	if ( !self bot_should_hip_fire() && self.bot.threat.dot > 0.96 )
	{
		ads = 1;
	}
	if ( ads )
	{
		self pressads( 1 );
	}
	else
	{
		self pressads( 0 );
	}
	frames = 4;
	if ( time >= self.bot.threat.time_aim_correct )
	{
		self.bot.threat.time_aim_correct += self.bot.threat.time_aim_interval;
		frac = ( time - self.bot.threat.time_first_sight ) / 100;
		frac = clamp( frac, 0, 1 );
		if ( !threat_is_player() )
		{
			frac = 1;
		}
		self.bot.threat.aim_target = self bot_update_aim( frames );
		self.bot.threat.position = self.bot.threat.entity.origin;
		self bot_update_lookat( self.bot.threat.aim_target, frac );
	}
	if ( self bot_on_target( self.bot.threat.entity.origin, 30 ) )
	{
		self allowattack( 1 );
	}
	else
	{
		self allowattack( 0 );
	}
	if ( is_true( self.stingerlockstarted ) )
	{
		self allowattack( self.stingerlockfinalized );
		return;
	}
}

bot_combat_dead( damage ) //checked matches cerberus output
{
	wait 0.1;
	self allowattack( 0 );
	wait_endon( 0.25, "damage" );
	self bot_clear_enemy();
}

bot_should_hip_fire() //checked matches cerberus output
{
	enemy = self.bot.threat.entity;
	weapon = self getcurrentweapon();
	if ( weapon == "none" )
	{
		return 0;
	}
	if ( weaponisdualwield( weapon ) )
	{
		return 1;
	}
	class = weaponclass( weapon );
	if ( isplayer( enemy ) && class == "spread" )
	{
		return 1;
	}
	distsq = distancesquared( self.origin, enemy.origin );
	distcheck = 0;
	switch( class )
	{
		case "mg":
			distcheck = 250;
			break;
		case "smg":
			distcheck = 350;
			break;
		case "spread":
			distcheck = 400;
			break;
		case "pistol":
			distcheck = 200;
			break;
		case "rocketlauncher":
			distcheck = 0;
			break;
		case "rifle":
		default:
			distcheck = 300;
			break;
	}
	if ( isweaponscopeoverlay( weapon ) )
	{
		distcheck = 500;
	}
	return distsq < ( distcheck * distcheck );
}

bot_patrol_near_enemy( damage, attacker, direction ) //checked matches cerberus output
{
	if ( isDefined( attacker ) )
	{
		self bot_lookat_entity( attacker );
	}
	if ( !isDefined( attacker ) )
	{
		attacker = self bot_get_closest_enemy( self.origin );
	}
	if ( !isDefined( attacker ) )
	{
		return;
	}
	node = bot_nearest_node( attacker.origin );
	if ( !isDefined( node ) )
	{
		nodes = getnodesinradiussorted( attacker.origin, 1024, 0, 512, "Path", 8 );
		if ( nodes.size )
		{
			node = nodes[ 0 ];
		}
	}
	if ( isDefined( node ) )
	{
		if ( isDefined( damage ) )
		{
			self addgoal( node, 24, 4, "enemy_patrol" );
			return;
		}
		else
		{
			self addgoal( node, 24, 2, "enemy_patrol" );
		}
	}
}

bot_lookat_entity( entity ) //checked matches cerberus output
{
	if ( isplayer( entity ) && entity getstance() != "prone" )
	{
		if ( distancesquared( self.origin, entity.origin ) < 65536 )
		{
			origin = entity getcentroid() + vectorScale( ( 0, 0, 1 ), 10 );
			self lookat( origin );
			return;
		}
	}
	offset = target_getoffset( entity );
	if ( isDefined( offset ) )
	{
		self lookat( entity.origin + offset );
	}
	else
	{
		self lookat( entity getcentroid() );
	}
}

bot_update_lookat( origin, frac ) //checked matches cerberus output
{
	angles = vectorToAngles( origin - self.origin );
	right = anglesToRight( angles );
	error = bot_get_aim_error() * ( 1 - frac );
	if ( cointoss() )
	{
		error *= -1;
	}
	height = origin[ 2 ] - self.bot.threat.entity.origin[ 2 ];
	height *= 1 - frac;
	if ( cointoss() )
	{
		height *= -1;
	}
	end = origin + ( right * error );
	end += ( 0, 0, height );
	red = 1 - frac;
	green = frac;
	self lookat( end );
}

bot_update_aim( frames ) //checked matches cerberus output
{
	ent = self.bot.threat.entity;
	prediction = self predictposition( ent, frames );
	if ( !threat_is_player() )
	{
		height = ent getcentroid()[ 2 ] - prediction[ 2 ];
		return prediction + ( 0, 0, height );
	}
	height = ent getplayerviewheight();
	torso = prediction + ( 0, 0, height / 1.6 );
	return torso;
}

bot_on_target( aim_target, radius ) //checked matches cerberus output
{
	angles = self getplayerangles();
	forward = anglesToForward( angles );
	origin = self getplayercamerapos();
	len = distance( aim_target, origin );
	end = origin + ( forward * len );
	if ( distance2dsquared( aim_target, end ) < ( radius * radius ) )
	{
		return 1;
	}
	return 0;
}

bot_get_aim_error() //checked changed at own discretion
{
	return 1;
}

bot_has_lmg() //checked changed at own discretion
{
	if ( bot_has_weapon_class( "mg" ) )
	{
		return 1;
	}
	return 0;
}

bot_has_weapon_class( class ) //checked changed at own discretion
{
	if ( self isreloading() )
	{
		return 0;
	}
	weapon = self getcurrentweapon();
	if ( weapon == "none" )
	{
		return 0;
	}
	if ( weaponclass( weapon ) == class )
	{
		return 1;
	}
	return 0;
}

bot_can_reload() //checked changed to match cerberus output
{
	weapon = self getcurrentweapon();
	if ( weapon == "none" )
	{
		return 0;
	}
	if ( !self getweaponammostock( weapon ) )
	{
		return 0;
	}
	if ( self isreloading() || self isswitchingweapons() || self isthrowinggrenade() )
	{
		return 0;
	}
	return 1;
}

bot_best_enemy() //checked partially changed to match cerberus output did not change while loop to foreach see github for more info
{
	enemies = getaispeciesarray( level.zombie_team, "all" );
	enemies = arraysort( enemies, self.origin );
	i = 0;
	while ( i < enemies.size )
	{
		if ( threat_should_ignore( enemies[ i ] ) )
		{
			i++;
			continue;
		}
		if ( self botsighttracepassed( enemies[ i ] ) )
		{
			self.bot.threat.entity = enemies[ i ];
			self.bot.threat.time_first_sight = getTime();
			self.bot.threat.time_recent_sight = getTime();
			self.bot.threat.dot = bot_dot_product( enemies[ i ].origin );
			self.bot.threat.position = enemies[ i ].origin;
			return 1;
		}
		i++;
	}
	return 0;
}

bot_weapon_ammo_frac() //checked matches cerberus output
{
	if ( self isreloading() || self isswitchingweapons() )
	{
		return 0;
	}
	weapon = self getcurrentweapon();
	if ( weapon == "none" )
	{
		return 1;
	}
	total = weaponclipsize( weapon );
	if ( total <= 0 )
	{
		return 1;
	}
	current = self getweaponammoclip( weapon );
	return current / total;
}

bot_select_weapon() //checked partially changed to match cerberus output did not change while loop to foreach see github for more info
{
	if ( self isthrowinggrenade() || self isswitchingweapons() || self isreloading() )
	{
		return;
	}
	if ( !self isonground() )
	{
		return;
	}
	ent = self.bot.threat.entity;
	if ( !isDefined( ent ) )
	{
		return;
	}
	primaries = self getweaponslistprimaries();
	weapon = self getcurrentweapon();
	stock = self getweaponammostock( weapon );
	clip = self getweaponammoclip( weapon );
	if ( weapon == "none" )
	{
		return;
	}
	if ( weapon == "fhj18_mp" && !target_istarget( ent ) )
	{
		foreach ( primary in primaries )
		{
			if ( primary != weapon )
			{
				self switchtoweapon( primary );
				return;
			}
		}
		return;
	}
	if ( !clip )
	{
		if ( stock )
		{
			if ( weaponhasattachment( weapon, "fastreload" ) )
			{
				return;
			}
		}
		i = 0;
		while ( i < primaries.size )
		{
			if ( primaries[ i ] == weapon || primaries[ i ] == "fhj18_mp" )
			{
				i++;
				continue;
			}
			if ( self getweaponammoclip( primaries[ i ] ) )
			{
				self switchtoweapon( primaries[ i ] );
				return;
			}
			i++;
		}
		if ( self bot_has_lmg() )
		{
			i = 0;
			while ( i < primaries.size )
			{
				if ( primaries[ i ] == weapon || primaries[ i ] == "fhj18_mp" )
				{
					i++;
					continue;
				}
				else
				{
					self switchtoweapon( primaries[ i ] );
					return;
				}
				i++;
			}
		}
	}
}

bot_can_do_combat() //checked matches cerberus output
{
	if ( self ismantling() || self isonladder() )
	{
		return 0;
	}
	return 1;
}

bot_dot_product( origin ) //checked matches cerberus output
{
	angles = self getplayerangles();
	forward = anglesToForward( angles );
	delta = origin - self getplayercamerapos();
	delta = vectornormalize( delta );
	dot = vectordot( forward, delta );
	return dot;
}

threat_should_ignore( entity ) //checked matches cerberus output
{
	return 0;
}

bot_clear_enemy() //checked matches cerberus output
{
	self clearlookat();
	self.bot.threat.entity = undefined;
}

bot_has_enemy() //checked changed at own discretion
{
	if ( isDefined( self.bot.threat.entity ) )
	{
		return 1;
	}
	return 0;
}

threat_dead() //checked changed at own discretion
{
	if ( self bot_has_enemy() )
	{
		ent = self.bot.threat.entity;
		if ( !isalive( ent ) )
		{
			return 1;
		}
		return 0;
	}
	return 0;
}

threat_is_player() //checked changed at own discretion
{
	ent = self.bot.threat.entity;
	if ( isDefined( ent ) && isplayer( ent ) )
	{
		return 1;
	}
	return 0;
}
