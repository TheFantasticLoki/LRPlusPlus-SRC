//Decompiled with SeriousHD-'s GSC Decompiler
#include maps/mp/zm_alcatraz_grief_cellblock;
#include maps/mp/zm_alcatraz_weap_quest;
#include maps/mp/zombies/_zm_weap_tomahawk;
#include maps/mp/zombies/_zm_weap_blundersplat;
#include maps/mp/zombies/_zm_magicbox_prison;
#include maps/mp/zm_prison_ffotd;
#include maps/mp/zm_prison_fx;
#include maps/mp/zm_alcatraz_gamemodes;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_spawnlogic;
#include maps/mp/animscripts/traverse/shared;
#include maps/mp/animscripts/utility;
#include maps/mp/zombies/_load;
#include maps/mp/_createfx;
#include maps/mp/_music;
#include maps/mp/_busing;
#include maps/mp/_script_gen;
#include maps/mp/gametypes_zm/_globallogic_audio;
#include maps/mp/gametypes_zm/_tweakables;
#include maps/mp/_challenges;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/_demo;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/gametypes_zm/_globallogic_utils;
#include maps/mp/gametypes_zm/_spectating;
#include maps/mp/gametypes_zm/_globallogic_spawn;
#include maps/mp/gametypes_zm/_globallogic_ui;
#include maps/mp/gametypes_zm/_hostmigration;
#include maps/mp/gametypes_zm/_globallogic_score;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_ai_faller;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_pers_upgrades;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/animscripts/zm_run;
#include maps/mp/animscripts/zm_death;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/animscripts/zm_shared;
#include maps/mp/animscripts/zm_utility;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_net;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/_visionset_mgr;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_server_throttle;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/zombies/_zm_audio_announcer;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_ai_dogs;
#include codescripts/character;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zm_transit_buildables;
#include maps/mp/zm_transit;
#include maps/mp/zombies/_zm_magicbox_lock;
#include maps/mp/zombies/_zm_afterlife;
#include maps/mp/zombies/_zm_ai_brutus;
#include maps/mp/zm_alcatraz_craftables;
#include maps/mp/zombies/_zm_craftables;
#include maps/mp/zm_alcatraz_utility;
#include maps/mp/zm_alcatraz_travel;
#include maps/mp/zm_alcatraz_traps;
#include maps/mp/zm_prison;
#include maps/mp/zm_alcatraz_sq;
#include maps/mp/zm_prison_sq_bg;
#include maps/mp/zm_prison_spoon;
#include maps/mp/zm_prison_achievement;
#include maps/mp/gametypes_zm/_hud;
init()
{
	level.map_set = getdvarintdefault( "CUSTOM_MAP", "none" );
	if( level.map_set == 2 || level.map_set == 1 )
	{
		if( getdvar( "mapname" ) == "zm_prison" )
		{
			level.rotation = getdvarintdefault( "Map_rotation", 0 );
			level.challenge_mode = getdvarintdefault( "Brutus_Mode", 0 );
			level.pap_weapons_box = getdvarintdefault( "Pap_box", 0 );
			level.custom_perks_enabled = getdvarintdefault( "Custom_perks", 0 );
			level.custom_power_ups = getdvarintdefault( "Custom_powerups", 0 );
			level.soulbox_active = 0;
			level.soulbox1_active = 0;
			level.soulbox2_active = 0;
			level.shared_box = 0;
			level.tomahawk_challenge = 0;
			level.perk_machine_challenge = 0;
			level.challenge_ended = 0;
			if( !(level.rotation) )
			{
				if( level.map_set == 1 )
				{
					level.map_location = "bridge";
				}
				else
				{
					if( level.map_set == 2 )
					{
						level.map_location = "rooftop";
					}
				}
			}
			else
			{
				map_rotation();
				level.map_location = getdvar( "customMap" );
			}
			register_zombie_death_event_callback( ::custom_death_callback );
			if( IsDefined( level.player_damage_callbacks[ 0] ) )
			{
				level.first_player_damage_callback = level.player_damage_callbacks[ 0];
				level.player_damage_callbacks[0] = ::damage_callback;
			}
			else
			{
				register_player_damage_callback( ::damage_callback );
			}
			if( IsDefined( level._zombiemode_powerup_grab ) )
			{
				level.original_zombiemode_powerup_grab = level._zombiemode_powerup_grab;
			}
			level._zombiemode_powerup_grab = ::custom_powerup_grab;
			level thread onplayerconnect();
			level thread drawzombiescounter();
			level turn_power_on_and_open_doors();
			level.player_out_of_playable_area_monitor = 0;
			level.afterlife_laststand_override = ::custom_afterlife;
			level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
			level._effect["uzi"] = loadfx( "maps/zombie/fx_zmb_wall_buy_uzi" );
			level._effect["thompson"] = loadfx( "maps/zombie/fx_zmb_wall_buy_thompson" );
			level._effect["ug"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_tomahawk_pickup_ug" );
			if( level.custom_power_ups )
			{
				include_zombie_powerup( "unlimited_ammo" );
				add_zombie_powerup( "unlimited_ammo", "T6_WPN_AR_GALIL_WORLD", &"ZOMBIE_POWERUP_UNLIMITED_AMMO", ::func_should_always_drop, 0, 0, 0 );
				powerup_set_can_pick_up_in_last_stand( "unlimited_ammo", 1 );
				include_zombie_powerup( "zombie_cash" );
				add_zombie_powerup( "zombie_cash", "bottle_whisky_01", &"ZOMBIE_POWERUP_ZOMBIE_CASH", ::func_should_always_drop, 1, 0, 0 );
				powerup_set_can_pick_up_in_last_stand( "zombie_cash", 1 );
			}
			precachemodels = array( "collision_clip_32x32x128", "p6_zm_al_vending_pap_on", "p6_zm_al_door_security_win_r", "p6_zm_al_acid_trap_tank", "zombie_firesale", "collision_player_wall_512x512x10", "collision_physics_512x512x10", "collision_player_wall_256x256x10", "p6_zm_al_skull_afterlife" );
			foreach( model in precachemodels )
			{
				precachemodel( model );
			}
			precacheshaders = array( "specialty_additionalprimaryweapon_zombies", "menu_mp_lobby_icon_customgamemode", "specialty_divetonuke_zombies", "zombies_rank_1", "zombies_rank_3", "zombies_rank_2", "zombies_rank_4", "zombies_rank_5", "menu_lobby_icon_facebook", "menu_mp_weapons_1911", "hud_icon_colt", "waypoint_revive", "hud_grenadeicon", "damage_feedback", "menu_lobby_icon_twitter", "specialty_doubletap_zombies" );
			foreach( shader in precacheshaders )
			{
				precacheshader( shader );
			}
			set_zombie_var( "zombie_powerup_fire_sale_on", 0 );
			set_zombie_var( "zombie_powerup_fire_sale_time", 30 );
			if( level.challenge_mode )
			{
				level thread brutus_challenge();
			}
			init_wall_fx();
			init_custom_map();
			thread box_init();
			thread powerups();
			thread remove();
			if( level.map_location == "bridge" )
			{
				thread tomahawk_challenge();
				if( level.custom_perks_enabled )
				{
					thread perk_machine_challenge();
				}
			}
		}
	}

}

remove()
{
	if( level.map_location == "rooftop" )
	{
		delete_plane_trigger = undefined;
		delete_plane_trigger = "plane_craftable_trigger";
		delete_plane_trigger1 = getentarray( delete_plane_trigger, "targetname" );
		delete_plane_trigger1[ 0] delete();
		triggers = getentarray( "zombie_door", "targetname" );
		foreach( trig in triggers )
		{
			trig notify( "trigger" );
			trig door_opened( 0 );
		}
		doors = getentarray( "pf3687_auto2556", "targetname" );
		foreach( door in doors )
		{
			door delete();
		}
		boxes = getentarray( "pf3687_auto2563", "targetname" );
		foreach( box in boxes )
		{
			box delete();
		}
	}
	if( level.map_location == "bridge" )
	{
		flag_wait( "initial_blackscreen_passed" );
		i = 1;
		while( i < 5 )
		{
			str_trigger_targetname += i;
			t_electric_chair = getent( str_trigger_targetname, "targetname" );
			t_electric_chair delete();
			i++;
		}
	}

}

brutus_challenge()
{
	level.zombie_vars["zombie_spawn_delay"] = 0.1;
	level.zombie_vars["zombie_intermission_time"] = 0.1;
	flag_wait( "initial_blackscreen_passed" );
	timer();
	level thread brutus_spawn_check();

}

timer()
{
	level.timer = createserverfontstring( "hudsmall", 1.8 );
	level.timer setpoint( "MIDDLE", "TOP" );
	i = 15;
	while( i > -1 )
	{
		level.timer.label = &"Brutus Challenge start in ^1";
		level.timer setvalue( i );
		wait 1;
		i++;
	}
	level.timer destroy();

}

powerups()
{
	level endon( "end_game" );
	while( level.round_number < 16 )
	{
		level waittill( "between_round_over" );
		if( !(included1)included1 && level.custom_power_ups )
		{
			include_zombie_powerup( "firesales" );
			add_zombie_powerup( "firesales", "zombie_firesale", &"ZOMBIE_POWERUP_FIRESALES", ::func_should_always_drop, 0, 0, 0 );
			powerup_set_can_pick_up_in_last_stand( "firesales", 1 );
			included1 = 1;
		}
		if( !(included2)included2 && level.custom_power_ups )
		{
			include_zombie_powerup( "death_machine" );
			add_zombie_powerup( "death_machine", "t6_wpn_minigun_world", &"ZOMBIE_POWERUP_DEATH_MACHINE", ::func_should_always_drop, 1, 0, 0 );
			powerup_set_can_pick_up_in_last_stand( "death_machine", 1 );
			included2 = 1;
		}
		if( !(included3)included3 )
		{
			if( !(level.pap_weapons_box)level.pap_weapons_box )
			{
				include_zombie_powerup( "pap_box" );
				add_zombie_powerup( "pap_box", "p6_anim_zm_al_magic_box_lock_red", &"ZOMBIE_POWERUP_PAP_BOX", ::func_should_always_drop, 0, 0, 0 );
				powerup_set_can_pick_up_in_last_stand( "pap_box", 1 );
			}
			add_limited_weapon( "blundergat_zm", 1 );
			level.zombie_weapons[ "blundergat_zm"].is_in_box = 1;
			iprintln( "^1Blundergat ^7added to mystery box!" );
			included3 = 1;
		}
	}

}

add_limited_weapon( weapon_name, amount )
{
	if( !(IsDefined( level.limited_weapons )) )
	{
		level.limited_weapons = [];
	}
	level.limited_weapons[weapon_name] = amount;

}

brutus_spawn_check()
{
	level endon( "bridge_empty" );
	n_round_on_area = 1;
	n_desired_spawn_count = 0;
	n_spawn_cap = 25;
	level.n_bridge_brutuses_killed = 0;
	if( level.map_location == "bridge" )
	{
		if( IsDefined( level.last_brutus_on_bridge_custom_func ) )
		{
			level thread [[  ]]();
		}
		else
		{
			level thread last_brutus_on_bridge();
		}
		if( IsDefined( level.brutus_despawn_manager_custom_func ) )
		{
			level thread [[  ]]();
		}
		else
		{
			if( !(level.tomahawk_challenge) )
			{
				level thread brutus_despawn_manager();
			}
		}
	}
	while( 1 )
	{
		level.brutus_last_spawn_round = 0;
		n_desired_spawn_count = int( min( n_round_on_area, n_spawn_cap ) );
		n_brutuses_on_area_count = get_brutus_count();
		n_spawns_needed -= n_brutuses_on_area_count;
		i = n_spawns_needed;
		while( i > 0 )
		{
			if( level.map_location == "rooftop" )
			{
				ai = brutus_spawn_in_zone( "zone_roof", 1 );
				ai thread killed();
			}
			if( level.map_location == "bridge" )
			{
				ai = brutus_spawn_in_zone( "zone_golden_gate_bridge", 1 );
				if( IsDefined( ai ) )
				{
					ai.is_bridge_brutus = 1;
					if( level.n_bridge_brutuses_killed == 0 )
					{
						ai thread suppress_brutus_bridge_powerups();
					}
				}
			}
			wait randomfloatrange( 1, 4 );
			i++;
		}
		level waittill( "start_of_round" );
		n_round_on_area++;
	}

}

get_brutus_count()
{
	n_touching_count = 0;
	if( level.map_location == "bridge" )
	{
		e_gg_zone = getent( "zone_golden_gate_bridge", "targetname" );
	}
	if( level.map_location == "rooftop" )
	{
		e_gg_zone = getent( "zone_roof", "targetname" );
	}
	zombies = getaispeciesarray( "axis", "all" );
	i = 0;
	while( i < zombies.size )
	{
		if( zombies[ i].is_brutus && IsDefined( zombies[ i].is_brutus ) )
		{
			brutus = zombies[ i];
			if( brutus istouching( e_gg_zone ) )
			{
				n_touching_count++;
			}
		}
		i++;
	}
	return n_touching_count;

}

onplayerconnect()
{
	for(;;)
	{
	level waittill( "connected", player );
	player thread onplayerspawned();
	}

}

onplayerspawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self waittill( "spawned_player" );
	self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
	self.perk_reminder = 0;
	self.perk_count = 0;
	self.num_perks = 0;
	self.death_machine = 0;
	self thread set_afterlife_lives();
	self thread removeperkshader();
	self thread perkboughtcheck();
	self thread damagehitmarker();
	self spawnpoint();
	if( level.challenge_mode )
	{
		self.score = 1500;
	}
	for(;;)
	{
	self waittill( "spawned_player" );
	self thread spawnpoint();
	if( level.challenge_mode )
	{
		if( self.score < 1500 )
		{
			self.score = 1500;
		}
	}
	}

}

set_afterlife_lives()
{
	self endon( "disconnect" );
	for(;;)
	{
	if( self.downs >= 1 && level.challenge_mode )
	{
		if( self.lives > 0 )
		{
			self.lives = 0;
		}
	}
	if( self.lives > 1 )
	{
		self.lives = 1;
	}
	if( level.map_location == "bridge" )
	{
		flag_set( "zombie_drop_powerups" );
	}
	wait 0.05;
	}

}

drawzombiescounter()
{
	flag_wait( "initial_blackscreen_passed" );
	level.zombiescounter = createserverfontstring( "hudsmall", 1.9 );
	level.zombiescounter setpoint( "RIGHT", "TOP", 315, "RIGHT" );
	level.brutuscounter = createserverfontstring( "hudsmall", 1.9 );
	level.brutuscounter setpoint( "RIGHT", "TOP", 315, 20 );
	while( 1 )
	{
		enemies += level.zombie_total;
		level.zombiescounter.label = &"Zombies: ^1";
		level.zombiescounter setvalue( enemies );
		if( level.tomahawk_challenge || level.challenge_mode )
		{
			brutus = level.brutus_count;
			level.brutuscounter.label = &"Brutus: ^1";
			level.brutuscounter setvalue( brutus );
		}
		wait 0.05;
	}

}

damagehitmarker()
{
	self thread startwaiting();
	self.hitmarker = newdamageindicatorhudelem( self );
	self.hitmarker.horzalign = "center";
	self.hitmarker.vertalign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setshader( "damage_feedback", 24, 48 );

}

startwaiting()
{
	while( 1 )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( !(IsDefined( zombie.waitingfordamage )) )
			{
				zombie thread hitmark();
			}
		}
		wait 0.25;
	}

}

hitmark()
{
	self endon( "killed" );
	self.waitingfordamage = 1;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		attacker.hitmarker.alpha = 0;
		if( isplayer( attacker ) )
		{
			if( isalive( self ) )
			{
				attacker.hitmarker.color = ( 1, 1, 1 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
			}
			else
			{
				attacker.hitmarker.color = ( 1, 0, 0 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
				self notify( "killed" );
			}
		}
	}

}

spawnpoint()
{
	player = level.players;
	if( level.map_location == "rooftop" )
	{
		if( player[ 0] == self )
		{
			player[ 0] setorigin( ( 2708, 9596, 1714 ) );
		}
		if( player[ 1] == self )
		{
			player[ 1] setorigin( ( 2875, 9596, 1706 ) );
		}
		if( player[ 2] == self )
		{
			player[ 2] setorigin( ( 3125.5, 9461.5, 1706 ) );
		}
		if( player[ 3] == self )
		{
			player[ 3] setorigin( ( 3408, 9512.5, 1706 ) );
		}
		if( player[ 4] == self )
		{
			player[ 4] setorigin( ( 3421, 9803.5, 1706 ) );
		}
		if( player[ 5] == self )
		{
			player[ 5] setorigin( ( 3168, 9807, 1706 ) );
		}
		if( player[ 6] == self )
		{
			player[ 6] setorigin( ( 2900, 9731.5, 1706 ) );
		}
		if( player[ 7] == self )
		{
			player[ 7] setorigin( ( 2589, 9731.5, 1706 ) );
		}
	}
	if( level.map_location == "bridge" )
	{
		if( player[ 0] == self )
		{
			player[ 0] setorigin( ( -972.2, -3392.697, -8447.875 ) );
		}
		if( player[ 1] == self )
		{
			player[ 1] setorigin( ( -890.2, -3853.697, -8447.875 ) );
		}
		if( player[ 2] == self )
		{
			player[ 2] setorigin( ( -1214.2, -3625.697, -8447.875 ) );
		}
		if( player[ 3] == self )
		{
			player[ 3] setorigin( ( -1069.2, -3413.697, -8447.875 ) );
		}
		if( player[ 4] == self )
		{
			player[ 4] setorigin( ( -519, -3486.5, -8447.875 ) );
		}
		if( player[ 5] == self )
		{
			player[ 5] setorigin( ( -1144, -3304, -8447.875 ) );
		}
		if( player[ 6] == self )
		{
			player[ 6] setorigin( ( -1418, -3860.5, -8447.875 ) );
		}
		if( player[ 7] == self )
		{
			player[ 7] setorigin( ( -1111, -3789.5, -8447.875 ) );
		}
	}

}

perk_fx( fx )
{
	playfxontag( level._effect[ fx], self, "tag_origin" );

}

init_custom_map()
{
	if( level.map_location == "bridge" )
	{
		thread acid_bench( ( -697.2, -3307.697, -8447.875 ), ( 0, -90, 0 ) );
		thread shield_bench( ( -817.2, -3307.697, -8447.875 ), ( 0, -90, 0 ) );
		flag_set( "activate_player_zone_bridge" );
		perk_system( "script_model", ( -470.28, -3318, -8447.88 ), "p6_zm_al_vending_jugg_on", ( 0, 0, 0 ), "original", "mus_perks_jugganog_sting", "Jugger-Nog", 2500, "jugger_light", "specialty_armorvest" );
		perk_system( "script_model", ( -367, -3910, -8447.88 ), "p6_zm_al_vending_sleight_on", ( 0, -90, 0 ), "original", "mus_perks_speed_sting", "Speed Cola", 3000, "sleight_light", "specialty_fastreload" );
		perk_system( "script_model", ( -1525.8, -3685, -8447.88 ), "p6_zm_al_vending_doubletap2_on", ( 0, 180, 0 ), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 2000, "doubletap_light", "specialty_rof" );
		perk_system( "script_model", ( -1640, -3887, -8447.88 ), "p6_zm_al_vending_ads_on", ( 0, 180, 0 ), "original", "mus_perks_jugganog_sting", "Deadshot", 1500, "deadshot_light", "specialty_deadshot" );
		perk_system( "script_model", ( -1256.28, -3215, -8447.88 ), "p6_zm_al_vending_nuke_on", ( 0, 0, 0 ), "custom", "mus_perks_jugganog_sting", "PhD Flopper", 2000, "jugger_light", "PHD_FLOPPER" );
		perk_system( "script_model", ( -714, -3643, -8447.88 ), "p6_zm_al_vending_three_gun_on", ( 0, 0, 0 ), "custom", "mus_perks_stamin_sting", "Mule Kick", 4000, "additionalprimaryweapon_light", "MULE" );
		perk_system( "script_model", ( -919.2, -3932.697, -8447.875 ), "p6_zm_vending_electric_cherry_on", ( 0, 180, 0 ), "original", "mus_perks_jugganog_sting", "Electric Cherry", 2500, "jugger_light", "specialty_grenadepulldeath" );
		if( level.custom_perks_enabled )
		{
			perk_system( "script_model", ( -1918.8, -3327.9, -8447.88 ), "p6_zm_al_vending_jugg_on", ( 0, 45, 0 ), "random", "mus_perks_speed_sting", "Random Perk", 1500, "sleight_light" );
		}
		wallweapons( "uzi_zm", ( -669.641, -3976.5, -8395 ), ( 0, -45, 0 ), 1500, 750 );
		wallweapons( "thompson_zm", ( -1922, -3865.5, -8415 ), ( 0, -110, 35 ), 1500, 750 );
	}
	if( level.map_location == "rooftop" )
	{
		thread shield_bench( ( 3438.2, 10040.7, 1704.875 ), ( 0, -90, 0 ) );
		thread acid_bench( ( 2985.2, 10033.7, 1704.875 ), ( 0, -90, 0 ) );
		perk_system( "script_model", ( 2665.2, 9569.697, 1704.875 ), "p6_zm_vending_electric_cherry_on", ( 0, -90, 0 ), "original", "mus_perks_jugganog_sting", "Electric Cherry", 2500, "jugger_light", "specialty_grenadepulldeath" );
		perk_system( "script_model", ( 2243.28, 9390, 1704.88 ), "p6_zm_al_vending_nuke_on", ( 0, 180, 0 ), "custom", "mus_perks_jugganog_sting", "PhD Flopper", 2000, "jugger_light", "PHD_FLOPPER" );
		perk_system( "script_model", ( 3135, 9880, 1704.88 ), "p6_zm_al_vending_sleight_on", ( 0, -90, 0 ), "original", "mus_perks_speed_sting", "Speed Cola", 3000, "sleight_light", "specialty_fastreload" );
		perk_system( "script_model", ( 3763, 9625, 1704.88 ), "p6_zm_al_vending_jugg_on", ( 0, 90, 0 ), "original", "mus_perks_jugganog_sting", "Jugger-Nog", 2500, "jugger_light", "specialty_armorvest" );
		perk_system( "script_model", ( 3220.8, 9354, 1704.88 ), "p6_zm_al_vending_doubletap2_on", ( 0, 90, 0 ), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 2000, "doubletap_light", "specialty_rof" );
		perk_system( "script_model", ( 3564, 9662, 1704.88 ), "p6_zm_al_vending_three_gun_on", ( 0, -90, 0 ), "custom", "mus_perks_stamin_sting", "Mule Kick", 4000, "doubletap_light", "MULE" );
		if( level.custom_perks_enabled )
		{
			perk_system( "script_model", ( 2488.8, 9754.9, 1704.88 ), "p6_zm_al_vending_jugg_on", ( 0, 90, 0 ), "random", "mus_perks_speed_sting", "Random Perk", 1500, "sleight_light" );
		}
		perk_system( "script_model", ( 4057, 9440, 1528 ), "p6_zm_al_vending_pap_on", ( 0, 180, 0 ), "pap", "zmb_perks_packa_upgrade", "Pack-A-Punch", 5000 );
		noncollision( "script_model", ( 3969, 9630, 1430 ), "collision_player_wall_512x512x10", ( 0, -90, 0 ), "collisionwall" );
		noncollision( "script_model", ( 3969, 9658, 1527.5 ), "p6_zm_al_door_security_win_r", ( 0, -90, 0 ), "door" );
		wallweapons( "uzi_zm", ( 3078.041, 9342.5, 1760.88 ), ( 0, 40, 0 ), 1500, 750 );
	}

}

init_wall_fx()
{
	if( level.map_location == "bridge" )
	{
		thread playchalkfx( "uzi", ( -670.641, -3976.5, -8395 ), ( 0, 5, 0 ) );
		thread playchalkfx( "thompson", ( -1922, -3865.5, -8415 ), ( 0, -60, 35 ) );
	}
	if( level.map_location == "rooftop" )
	{
		thread playchalkfx( "uzi", ( 3078, 9343.5, 1761.5 ), ( 0, 90, 0 ) );
	}

}

playchalkfx( effect, origin, angles )
{
	fx = spawnfx( level._effect[ effect], origin, anglestoforward( angles ), anglestoup( angles ) );
	triggerfx( fx );
	level waittill( "connected", player );
	fx delete();

}

noncollision( script, pos, model, angles, type )
{
	noncol = spawn( "script_model", pos );
	noncol setmodel( model );
	noncol.angles = angles;

}

perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk )
{
	col = spawn( script, pos );
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
	col thread buy_system( perk, sound, name, cost, type );

}

buy_system( perk, sound, name, cost, type )
{
	self endon( "game_ended" );
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(player.machine_is_in_use) )
			{
				if( distance( self.origin, player.origin ) <= 70 )
				{
					if( level.map_location == "bridge" )
					{
						if( !(level.perk_machine_challenge)level.perk_machine_challenge )
						{
							player thread spawnhint( self.origin, 45, 30, "HINT_ACTIVATE", "Complete Perk Machine Challenge first." );
						}
						else
						{
							player thread spawnhint( self.origin, 45, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + ( name + ( " [Cost: " + ( cost + "]" ) ) ) );
						}
					}
					else
					{
						player thread spawnhint( self.origin, 45, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + ( name + ( " [Cost: " + ( cost + "]" ) ) ) );
					}
					if( !(player player_is_in_laststand())player player_is_in_laststand() && player.score >= cost && !(player hasperk( perk ))player hasperk( perk ) && !(player hascustomperk( perk ))player hascustomperk( perk ) && player usebuttonpressed() )
					{
						player.machine_is_in_use = 1;
						player playsound( "zmb_cha_ching" );
						player.score = player.score - cost;
						player playsound( sound );
						if( type == "original" )
						{
							player thread dogiveperk( perk );
						}
						else
						{
							player thread drawshader_and_shadermove( perk, 1, 1 );
						}
						wait 4;
						player.machine_is_in_use = 0;
					}
					currgun = player getcurrentweapon();
					if( !(player player_is_in_laststand())player player_is_in_laststand() && player.score >= cost && can_upgrade_weapon( currgun ) && !(is_weapon_upgraded( currgun ))is_weapon_upgraded( currgun ) )
					{
						player.machine_is_in_use = 1;
						player playsound( "zmb_cha_ching" );
						player.score = player.score - cost;
						player playsound( sound );
						player takeweapon( currgun );
						gun = player get_upgrade_weapon( currgun, 0 );
						player giveweapon( player get_upgrade_weapon( currgun, 0 ), 0, player get_pack_a_punch_weapon_options( gun ) );
						player switchtoweapon( gun );
						playfx( loadfx( "maps/zombie/fx_zombie_packapunch" ), ( 4057, 9440, 1536 ), anglestoforward( ( 0, 270, 55 ) ) );
						wait 3;
						player.machine_is_in_use = 0;
					}
					if( level.map_location == "bridge" )
					{
						if( !(player player_is_in_laststand())player player_is_in_laststand() && player.score >= cost && player can_buy_weapon() && player usebuttonpressed() && !(player.num_perks > 9)player.num_perks > 9 )
						{
							level.machine_is_in_use = 1;
							player playsound( "zmb_cha_ching" );
							player.score = player.score - cost;
							player playsound( "mus_perks_doubletap_sting" );
							player thread give_random_perk();
							wait 4;
							player.machine_is_in_use = 0;
						}
					}
					if( level.map_location == "rooftop" )
					{
						if( !(player player_is_in_laststand())player player_is_in_laststand() && player.score >= cost && player can_buy_weapon() && player usebuttonpressed() && !(player.num_perks > 9) )
						{
							level.machine_is_in_use = 1;
							player playsound( "zmb_cha_ching" );
							player.score = player.score - cost;
							player playsound( "mus_perks_doubletap_sting" );
							player thread give_random_perk();
							wait 4;
							player.machine_is_in_use = 0;
						}
					}
					if( player.score >= cost && player usebuttonpressed() && player.num_perks > 9 && type == "random" && level.perk_machine_challenge )
					{
						player iprintln( "you have all perks." );
						wait 3;
					}
					else
					{
						if( player.score < cost && player usebuttonpressed() )
						{
							player create_and_play_dialog( "general", "perk_deny", undefined, 0 );
						}
					}
				}
			}
		}
		wait 0.1;
	}

}

play_fx( fx )
{
	playfxontag( level._effect[ fx], self, "tag_origin" );

}

hascustomperk( perk )
{
	i = 0;
	while( i < self.perkarray.size )
	{
		if( self.perkarray[ i].name == perk )
		{
			return 1;
		}
		i++;
	}
	return 0;

}

removeperkshader()
{
	for(;;)
	{
	self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
	self.num_perks = 0;
	self.perk_reminder = 0;
	self.perk_count = 0;
	self.dying_wish_on_cooldown = 0;
	self removeallcustomshader();
	self.perkarray = [];
	self notify( "stopcustomperk" );
	self.bleedout_time = 30;
	self.ignore_lava_damage = 0;
	}

}

removeallcustomshader()
{
	i = 0;
	while( i < self.perkarray.size )
	{
		self.perkarray[ i] destroy();
		i++;
	}

}

perkboughtcheck()
{
	self endon( "death" );
	self endon( "disconnect" );
	for(;;)
	{
	self.perk_reminder = self.num_perks;
	self waittill( "perk_acquired" );
	n = 1;
	if( !(self.num_perks > self.perk_reminder) )
	{
		n -= self.perk_reminder;
		self.num_perks += n;
	}
	self.perk_reminder = self.num_perks;
	self.perk_count = self.perk_count + n;
	self drawshader_and_shadermove( "none", 0, 0 );
	}

}

drawshader( shader, width, height, color, alpha, sort, foreground )
{
	if( !(IsDefined( self.perks_active )) )
	{
		self.perks_active = [];
	}
	hud = create_simple_hud( self );
	hud setshader( shader, width, height );
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.foreground = foreground;
	hud.hidewheninmenu = 1;
	hud.horzalign = "user_left";
	hud.vertalign = "user_center";
	hud.x += self.perks_active.size * 30;
	hud.y = 146.5;
	return hud;

}

drawshader_and_shadermove( perk, custom, print )
{
	if( custom )
	{
		self allowprone( 0 );
		self allowsprint( 0 );
		self disableoffhandweapons();
		self disableweaponcycling();
		weapona = self getcurrentweapon();
		weaponb = "zombie_perk_bottle_deadshot";
		self giveweapon( weaponb );
		self switchtoweapon( weaponb );
		self waittill( "weapon_change_complete" );
		self enableoffhandweapons();
		self enableweaponcycling();
		self takeweapon( weaponb );
		self switchtoweapon( weapona );
		self playerexert( "burp" );
		self setblur( 4, 0.1 );
		wait 0.1;
		self setblur( 0, 0.1 );
		self allowprone( 1 );
		self allowsprint( 1 );
	}
	i = 0;
	while( i < self.perkarray.size )
	{
		self.perkarray[ i].x = self.perkarray[ i].x + 30;
		i++;
	}
	if( perk == "MULE" )
	{
		self.perk1front = self drawshader( "specialty_additionalprimaryweapon_zombies", 24, 24, ( 1, 1, 1 ), 100, 0, 1 );
		self.perk1front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk1front;
		self.num_perks++;
		if( print )
		{
			self iprintln( "^9Mule Kick" );
			wait 0.2;
			self iprintln( "This Perk enables additional primary weapon slot for player. " );
		}
	}
	if( perk == "PHD_FLOPPER" )
	{
		self.perk2front = self drawshader( "specialty_divetonuke_zombies", 24, 24, ( 1, 1, 1 ), 100, 0, 1 );
		self.perk2front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk2front;
		self.num_perks++;
		if( print )
		{
			self iprintln( "^9PhD Flopper" );
			wait 0.2;
			self iprintln( "This Perk removes explosion and fall damage also player creates explosion when dive to prone." );
		}
	}
	if( perk == "Ethereal_Razor" )
	{
		self.perk4back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 200, 0, 0 ), 100, 0, 0 );
		self.perk4front = self drawshader( "zombies_rank_4", 24, 23, ( 1, 1, 1 ), 100, 0, 1 );
		self.perk4front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk4front;
		self.perk4back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk4back;
		self.num_perks++;
		if( print )
		{
			self iprintln( "^9Ethereal Razor" );
			wait 0.2;
			self iprintln( "This Perk deals extra damage when player using melee attacks and restores a small amount of health." );
		}
	}
	if( perk == "Ammo_Regen" )
	{
		self.perk5back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 0, 0, 0 ), 100, 0, 0 );
		self.perk5front = self drawshader( "menu_mp_lobby_icon_customgamemode", 24, 23, ( 1, 1, 1 ), 100, 0, 1 );
		self.perk5front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk5front;
		self.perk5back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk5back;
		self.num_perks++;
		self thread ammoregen();
		self thread grenadesregen();
		if( print )
		{
			self iprintln( "^9Ammo Regen" );
			wait 0.2;
			self iprintln( "This Perk will slowly regenerades players ammonation and grenades." );
		}
	}
	if( perk == "Dying_Wish" )
	{
		self.perk6back = self drawshader( "specialty_doubletap_zombies", 24, 24, ( 200, 0, 0 ), 100, 0, 0 );
		self.perk6front = self drawshader( "zombies_rank_5", 24, 23, ( 1, 1, 1 ), 100, 0, 1 );
		self.perk6front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk6front;
		self.perk6back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk6back;
		self.num_perks++;
		self thread dying_wish_checker();
		if( print )
		{
			self iprintln( "^9Dying Wish" );
			wait 0.2;
			self iprintln( "This Perk allow player to go berserker mode for 9 seconds instead of laststand." );
			wait 0.1;
			self iprintln( " (cooldown 5mins and it's increased 30sec every time perk is used. - max 10mins) " );
		}
	}

}

damage_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	if( self hascustomperk( "PHD_FLOPPER" ) )
	{
		if( smeansofdeath == "MOD_FALLING" )
		{
			if( self.divetoprone == 1 && IsDefined( self.divetoprone ) )
			{
				radiusdamage( self.origin, 300, 5000, 1000, self, "MOD_GRENADE_SPLASH" );
				playfx( loadfx( "explosions/fx_default_explosion" ), self.origin, anglestoforward( ( 0, 45, 55 ) ) );
				self playsound( "zmb_phdflop_explo" );
			}
			return 0;
		}
		if( !(smeansofdeath == "MOD_UNKNOWN")smeansofdeath == "MOD_UNKNOWN" && eattacker == self || smeansofdeath == "MOD_GRENADE_SPLASH" )
		{
			return 0;
		}
	}
	if( self hascustomperk( "Dying_Wish" ) && !(self.dying_wish_on_cooldown)self.dying_wish_on_cooldown )
	{
		self notify( "dying_wish_charge" );
		self thread dying_wish_effect();
		return 0;
	}
	if( IsDefined( level.first_player_damage_callback ) )
	{
		return [[  ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	}
	return idamage;

}

custom_get_player_weapon_limit( player )
{
	weapon_limit = 2;
	if( player hascustomperk( "MULE" ) )
	{
		weapon_limit = 3;
	}
	if( self.death_machine )
	{
		weapon_limit = weapon_limit + 1;
	}
	else
	{
		weapons = self getweaponslistprimaries();
		if( weapons.size > weapon_limit )
		{
			self takeweapon( weapons[ 2] );
		}
	}
	return weapon_limit;

}

start_er()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	self endon( "stopcustomperk" );
	if( self ismeleeing() && self hascustomperk( "Ethereal_Razor" ) )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( distance( self.origin, zombie.origin ) <= 100 )
			{
				if( self is_insta_kill_active() )
				{
					zombie dodamage( zombie.health + 666, ( 0, 0, 0 ) );
				}
				zombie dodamage( 600, ( 0, 0, 0 ) );
				if( zombie.health <= 0 )
				{
					self add_to_player_score( 100 );
					self.kills++;
				}
				else
				{
					self add_to_player_score( 10 );
				}
			}
		}
		self.health = self.health + 10;
		if( self.health > self.maxhealth )
		{
			self.health = self.maxhealth;
		}
		while( self ismeleeing() )
		{
			wait 0.1;
		}
	}
	wait 0.05;
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

dying_wish_checker()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	self endon( "stopcustomperk" );
	self.dying_wish_uses = 0;
	for(;;)
	{
	self.dying_wish_on_cooldown = 0;
	self.perk6back.alpha = 1;
	self.perk6front.alpha = 1;
	self waittill( "dying_wish_charge" );
	self.perk6back.alpha = 0.3;
	self.perk6front.alpha = 0.4;
	self.dying_wish_uses++;
	self.dying_wish_on_cooldown = 1;
	delay += self.dying_wish_uses * 30;
	if( delay >= 600 )
	{
		delay = 600;
	}
	wait delay;
	}

}

dying_wish_effect()
{
	self thread power_up_hud( 0, 0, 0, "Dying Wish saved you!" );
	self enableinvulnerability();
	self.ignoreme = 1;
	self useservervisionset( 1 );
	self setvisionsetforplayer( "zombie_death", 0 );
	wait 9;
	self.health = 1;
	self disableinvulnerability();
	self.ignoreme = 0;
	self useservervisionset( 0 );
	self setvisionsetforplayer( "remote_mortar_enhanced", 0 );

}

ammoregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
	if( self getcurrentweapon() == "blundersplat_upgraded_zm" || self getcurrentweapon() == "blundersplat_zm" || self getcurrentweapon() == "blundergat_upgraded_zm" || self getcurrentweapon() == "blundergat_zm" )
	{
		stockcount = self getweaponammostock( self getcurrentweapon() );
		self setweaponammostock( self getcurrentweapon(), stockcount + 1 );
		wait 6;
	}
	if( !(self getcurrentweapon() == "blundersplat_upgraded_zm")self getcurrentweapon() == "blundersplat_upgraded_zm" || !(self getcurrentweapon() == "blundersplat_zm")self getcurrentweapon() == "blundersplat_zm" || !(self getcurrentweapon() == "blundergat_upgraded_zm") )
	{
		stockcount = self getweaponammostock( self getcurrentweapon() );
		self setweaponammostock( self getcurrentweapon(), stockcount + 1 );
		wait 2;
	}
	wait 0.1;
	}

}

grenadesregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
	grenades = self get_player_lethal_grenade();
	grenade_count = self getweaponammoclip( grenades );
	if( grenade_count < 4 )
	{
		self setweaponammoclip( grenades, grenade_count + 1 );
	}
	tactical_grenades = self get_player_tactical_grenade();
	tactical_grenade_count = self getweaponammoclip( tactical_grenades );
	if( tactical_grenade_count < 3 )
	{
		self setweaponammoclip( tactical_grenades, tactical_grenade_count + 1 );
	}
	wait 300;
	}

}

give_random_perk()
{
	perks = array();
	if( !(self hascustomperk( "PHD_FLOPPER" )) )
	{
		perks[perks.size] = "PHD_FLOPPER";
	}
	if( !(self hascustomperk( "MULE" )) )
	{
		perks[perks.size] = "MULE";
	}
	if( !(self hascustomperk( "Ethereal_Razor" )) )
	{
		perks[perks.size] = "Ethereal_Razor";
	}
	if( !(self hascustomperk( "Ammo_Regen" )) )
	{
		perks[perks.size] = "Ammo_Regen";
	}
	if( !(self hascustomperk( "Dying_Wish" )) )
	{
		perks[perks.size] = "Dying_Wish";
	}
	if( !(self hasperk( "specialty_armorvest" )) )
	{
		perks[perks.size] = "specialty_armorvest";
	}
	if( !(self hasperk( "specialty_rof" )) )
	{
		perks[perks.size] = "specialty_rof";
	}
	if( !(self hasperk( "specialty_fastreload" )) )
	{
		perks[perks.size] = "specialty_fastreload";
	}
	if( !(self hasperk( "specialty_grenadepulldeath" )) )
	{
		perks[perks.size] = "specialty_grenadepulldeath";
	}
	if( !(self hasperk( "specialty_deadshot" )) )
	{
		perks[perks.size] = "specialty_deadshot";
	}
	if( !(perks.size > 0) )
	{
		self playsoundtoplayer( level.zmb_laugh_alias, self );
		return 0;
	}
	n = array_randomize( perks );
	perk = n[ 0];
	if( perk == "specialty_deadshot" || perk == "specialty_grenadepulldeath" || perk == "specialty_fastreload" || perk == "specialty_rof" || perk == "specialty_armorvest" )
	{
		self dogiveperk( perk );
	}
	else
	{
		self drawshader_and_shadermove( perk, 1, 1 );
	}

}

dogiveperk( perk )
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );
	self endon( "perk_abort_drinking" );
	if( !(self has_perk_paused( perk ))self has_perk_paused( perk ) )
	{
		gun = self perk_give_bottle_begin( perk );
		evt = self waittill_any_return( "fake_death", "death", "player_downed", "weapon_change_complete" );
		if( evt == "weapon_change_complete" )
		{
			self thread wait_give_perk( perk, 1 );
		}
		self perk_give_bottle_end( gun, perk );
		if( self.intermission && IsDefined( self.intermission ) || self player_is_in_laststand() )
		{
		}
		self notify( "burp" );
	}

}

spawnhint( origin, width, height, cursorhint, string )
{
	hint = spawn( "trigger_radius", origin, 1, width, height );
	hint setcursorhint( cursorhint, hint );
	hint sethintstring( string );
	hint setvisibletoall();
	wait 0.2;
	hint delete();

}

box_init()
{
	setdvar( "magic_chest_movable", "0" );
	flag_wait( "initial_blackscreen_passed" );
	add_zombie_hint( "default_shared_box", "Hold ^3&&1^7 for weapon" );
	if( !(IsDefined( level.magic_box_zbarrier_state_func )) )
	{
		level.magic_box_zbarrier_state_func = ::process_magic_box_zbarrier_state;
	}
	if( level.using_locked_magicbox && IsDefined( level.using_locked_magicbox ) )
	{
		init();
	}
	if( level.map_location == "rooftop" && IsDefined( level.map_location ) )
	{
		level.chests = [];
		start_chest = spawnstruct();
		start_chest.origin = ( 2249, 9819.5, 1704.1 );
		start_chest.angles = ( 0, -90, 0 );
		start_chest.script_noteworthy = "start_chest";
		start_chest.zombie_cost = 950;
		level.chests[0] = start_chest;
		level.chests[1] = UNDEFINED_LOCAL[ 3];
		treasure_chest_init( "start_chest" );
	}
	if( level.map_location == "bridge" && IsDefined( level.map_location ) )
	{
		level.chests = [];
		start_chest = spawnstruct();
		start_chest.origin = ( -437, -3658, -8447.88 );
		start_chest.angles = ( 0, 90, 0 );
		start_chest.script_noteworthy = "start_chest";
		if( level.pap_weapons_box )
		{
			start_chest.zombie_cost = 2500;
		}
		else
		{
			start_chest.zombie_cost = 950;
		}
		level.chests[0] = start_chest;
		level.chests[1] = UNDEFINED_LOCAL[ 3];
		treasure_chest_init( "start_chest" );
	}
	if( level.createfx_enabled )
	{
	}
	if( !(IsDefined( level.magic_box_check_equipment )) )
	{
		level.magic_box_check_equipment = ::default_magic_box_check_equipment;
	}
	level thread magicbox_host_migration();
	level.zombie_weapons[ "minigun_alcatraz_zm"].is_in_box = 0;
	level.zombie_weapons[ "blundergat_zm"].is_in_box = 0;

}

treasure_chest_init( start_chest_name )
{
	flag_init( "moving_chest_enabled" );
	flag_init( "moving_chest_now" );
	flag_init( "chest_has_been_used" );
	level.chest_moves = 0;
	level.chest_level = 0;
	if( level.chests.size == 0 )
	{
	}
	i = 0;
	while( i < level.chests.size )
	{
		level.chests[ i].box_hacks = [];
		level.chests[ i].orig_origin = level.chests[ i].origin;
		level.chests[ i] get_chest_pieces();
		if( IsDefined( level.chests[ i].zombie_cost ) )
		{
			level.chests[ i].old_cost = level.chests[ i].zombie_cost;
		}
		else
		{
			level.chests[ i].old_cost = 950;
		}
		i++;
	}
	level.chest_accessed = 0;
	init_starting_chest_location( start_chest_name );
	array_thread( level.chests, ::treasure_chest_think );

}

get_chest_pieces()
{
	self.chest_box = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
	if( self.script_noteworthy == "start_chest" && level.map_location == "rooftop" && IsDefined( level.map_location ) )
	{
		self.chest_box.origin = ( 2249, 9819.5, 1704.1 );
		self.chest_box.angles = ( 0, -90, 0 );
	}
	if( self.script_noteworthy == "start_chest" && level.map_location == "bridge" && IsDefined( level.map_location ) )
	{
		self.chest_box.origin = ( -437, -3658, -8447.88 );
		self.chest_box.angles = ( 0, 90, 0 );
	}
	collision = spawn( "script_model", self.chest_box.origin );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", self.chest_box.origin - ( 0, 32, 0 ) );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", self.chest_box.origin + ( 0, 32, 0 ) );
	collision.angles = self.chest_box.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	self.chest_rubble = [];
	rubble = getentarray( self.script_noteworthy + "_rubble", "script_noteworthy" );
	i = 0;
	while( i < rubble.size )
	{
		if( distancesquared( self.origin, rubble[ i].origin ) < 10000 )
		{
			self.chest_rubble[self.chest_rubble.size] = rubble[ i];
		}
		i++;
	}
	self.zbarrier = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
	if( IsDefined( self.zbarrier ) )
	{
		self.zbarrier zbarrierpieceuseboxriselogic( 3 );
		self.zbarrier zbarrierpieceuseboxriselogic( 4 );
	}
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.origin += anglestoright( self.angles * -22.5 );
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.script_width = 104;
	self.unitrigger_stub.script_height = 50;
	self.unitrigger_stub.script_length = 60;
	self.unitrigger_stub.trigger_target = self;
	unitrigger_force_per_player_triggers( self.unitrigger_stub, 1 );
	self.unitrigger_stub.prompt_and_visibility_func = ::boxtrigger_update_prompt;
	self.zbarrier.owner = self;

}

boxtrigger_update_prompt( player )
{
	can_use = self boxstub_update_prompt( player );
	if( IsDefined( self.hint_string ) )
	{
		if( IsDefined( self.hint_parm1 ) )
		{
			self sethintstring( self.hint_string, self.hint_parm1 );
		}
		else
		{
			self sethintstring( self.hint_string );
		}
	}
	return can_use;

}

boxstub_update_prompt( player )
{
	self setcursorhint( "HINT_NOICON" );
	if( !(self trigger_visible_to_player( player )) )
	{
		if( level.shared_box )
		{
			self setvisibletoplayer( player );
			self.hint_string = get_hint_string( self, "default_shared_box" );
			return 1;
		}
		return 0;
	}
	self.hint_parm1 = undefined;
	if( self.stub.trigger_target.grab_weapon_hint && IsDefined( self.stub.trigger_target.grab_weapon_hint ) )
	{
		if( level.shared_box )
		{
			self.hint_string = get_hint_string( self, "default_shared_box" );
		}
		else
		{
			if( [[  ]]( self.stub.trigger_target.grab_weapon_name ) && IsDefined( level.magic_box_check_equipment ) )
			{
				self.hint_string = "Hold ^3&&1^7 for Equipment ^1or ^7Press ^3[{+melee}]^7 to let teammates pick it up";
			}
			else
			{
				self.hint_string = "Hold ^3&&1^7 for Weapon ^1or ^7Press ^3[{+melee}]^7 to let teammates pick it up";
			}
		}
	}
	else
	{
		if( self.stub.trigger_target.is_locked && IsDefined( self.stub.trigger_target.is_locked ) && level.using_locked_magicbox && IsDefined( level.using_locked_magicbox ) )
		{
			self.hint_string = get_hint_string( self, "locked_magic_box_cost" );
		}
		else
		{
			self.hint_parm1 = self.stub.trigger_target.zombie_cost;
			self.hint_string = get_hint_string( self, "default_treasure_chest" );
		}
	}
	return 1;

}

treasure_chest_think()
{
	self endon( "kill_chest_think" );
	user = undefined;
	user_cost = undefined;
	self.box_rerespun = undefined;
	self.weapon_out = undefined;
	self thread unregister_unitrigger_on_kill_think();
	while( 1 )
	{
		if( !(IsDefined( self.forced_user )) )
		{
			self waittill( "trigger", user );
			if( user == level )
			{
				wait 0.1;
				continue;
			}
			break;
		}
		user = self.forced_user;
		if( user in_revive_trigger() )
		{
			wait 0.1;
			continue;
		}
		if( user.is_drinking > 0 )
		{
			wait 0.1;
			continue;
		}
		if( self.disabled && IsDefined( self.disabled ) )
		{
			wait 0.1;
			continue;
		}
		if( user getcurrentweapon() == "none" )
		{
			wait 0.1;
			continue;
		}
		if( user hasweapon( "minigun_alcatraz_upgraded_zm" ) )
		{
			wait 0.1;
			continue;
		}
		reduced_cost = undefined;
		if( user is_pers_double_points_active() && is_player_valid( user ) )
		{
			reduced_cost = int( self.zombie_cost / 2 );
		}
		if( self.is_locked && IsDefined( self.is_locked ) && level.using_locked_magicbox && IsDefined( level.using_locked_magicbox ) )
		{
			if( user.score >= level.locked_magic_box_cost )
			{
				user minus_to_player_score( level.locked_magic_box_cost );
				self.zbarrier set_magic_box_zbarrier_state( "unlocking" );
				self.unitrigger_stub run_visibility_function_for_all_triggers();
			}
			else
			{
				user create_and_play_dialog( "general", "no_money_box" );
			}
			wait 0.1;
			continue;
			break;
		}
		if( is_player_valid( user ) && IsDefined( self.auto_open ) )
		{
			if( !(IsDefined( self.no_charge )) )
			{
				user minus_to_player_score( self.zombie_cost );
				user_cost = self.zombie_cost;
			}
			else
			{
				user_cost = 0;
			}
			self.chest_user = user;
			break;
		}
		else
		{
			if( user.score >= self.zombie_cost && is_player_valid( user ) )
			{
				user minus_to_player_score( self.zombie_cost );
				user_cost = self.zombie_cost;
				self.chest_user = user;
				break;
			}
			else
			{
				if( user.score >= reduced_cost && IsDefined( reduced_cost ) )
				{
					user minus_to_player_score( reduced_cost );
					user_cost = reduced_cost;
					self.chest_user = user;
					break;
				}
				else
				{
					if( user.score < self.zombie_cost )
					{
						play_sound_at_pos( "no_purchase", self.origin );
						user create_and_play_dialog( "general", "no_money_box" );
						wait 0.1;
						continue;
					}
				}
			}
		}
		wait 0.05;
	}
	flag_set( "chest_has_been_used" );
	bookmark( "zm_player_use_magicbox", gettime(), user );
	user increment_client_stat( "use_magicbox" );
	user increment_player_stat( "use_magicbox" );
	if( IsDefined( level._magic_box_used_vo ) )
	{
		user thread [[  ]]();
	}
	self thread watch_for_emp_close();
	if( level.using_locked_magicbox && IsDefined( level.using_locked_magicbox ) )
	{
		self thread watch_for_lock();
	}
	self._box_open = 1;
	level.box_open = 1;
	self._box_opened_by_fire_sale = 0;
	if( self [[  ]]() && !(IsDefined( self.auto_open ))IsDefined( self.auto_open ) && level.zombie_vars[ "zombie_powerup_fire_sale_on"] )
	{
		self._box_opened_by_fire_sale = 1;
	}
	if( IsDefined( self.chest_lid ) )
	{
		self.chest_lid thread treasure_chest_lid_open();
	}
	if( IsDefined( self.zbarrier ) )
	{
		play_sound_at_pos( "open_chest", self.origin );
		play_sound_at_pos( "music_chest", self.origin );
		self.zbarrier set_magic_box_zbarrier_state( "open" );
	}
	self.timedout = 0;
	self.weapon_out = 1;
	self.zbarrier thread treasure_chest_weapon_spawn( self, user );
	self.zbarrier thread treasure_chest_glowfx();
	thread unregister_unitrigger( self.unitrigger_stub );
	self.zbarrier waittill_any( "randomization_done", "box_hacked_respin" );
	if( IsDefined( user_cost ) && !(self._box_opened_by_fire_sale)self._box_opened_by_fire_sale )
	{
		user add_to_player_score( user_cost, 0 );
	}
	if( !(self._box_opened_by_fire_sale)self._box_opened_by_fire_sale && !(level.zombie_vars[ "zombie_powerup_fire_sale_on"]) )
	{
		self thread treasure_chest_move( self.chest_user );
	}
	else
	{
		self.grab_weapon_hint = 1;
		self.grab_weapon_name = self.zbarrier.weapon_string;
		self.chest_user = user;
		thread register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );
		if( !(is_true( self.zbarrier.closed_by_emp ))is_true( self.zbarrier.closed_by_emp ) )
		{
			self thread treasure_chest_timeout();
		}
		timeout_time = 105;
		grabber = user;
		i = 0;
		while( i < 105 )
		{
			if( distance( self.origin, user.origin ) <= 70 && isplayer( user ) && user meleebuttonpressed() )
			{
				level.magic_box_grab_by_anyone = 1;
				level.shared_box = 1;
				self.unitrigger_stub run_visibility_function_for_all_triggers();
				a = i;
				while( a < 105 )
				{
					foreach( player in level.players )
					{
						if( !(player.is_drinking)player.is_drinking && IsDefined( player.is_drinking ) && distance( self.origin, player.origin ) <= 70 && player getcurrentweapon() != "minigun_alcatraz_upgraded_zm" )
						{
							if( level.pap_weapons_box )
							{
								player thread treasure_chest_give_weapon( player get_upgrade_weapon( self.zbarrier.weapon_string ) );
							}
							else
							{
								player thread treasure_chest_give_weapon( self.zbarrier.weapon_string );
							}
							a = 105;
							break;
						}
						else
						{
							_k504 = GetNextArrayKey( _a504, _k504 );
							?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
						}
					}
					wait 0.1;
					a++;
				}
				break;
			}
			else
			{
				if( !(grabber.is_drinking)grabber.is_drinking && IsDefined( grabber.is_drinking ) && distance( self.origin, grabber.origin ) <= 70 && grabber getcurrentweapon() != "minigun_alcatraz_upgraded_zm" && user == grabber && isplayer( grabber ) )
				{
					if( level.pap_weapons_box )
					{
						grabber thread treasure_chest_give_weapon( grabber get_upgrade_weapon( self.zbarrier.weapon_string ) );
					}
					else
					{
						grabber thread treasure_chest_give_weapon( self.zbarrier.weapon_string );
					}
					break;
				}
				wait 0.1;
				i++;
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		self.weapon_out = undefined;
		self notify( "user_grabbed_weapon" );
		user notify( "user_grabbed_weapon" );
		self.grab_weapon_hint = 0;
		self.zbarrier notify( "weapon_grabbed" );
		if( !(self._box_opened_by_fire_sale)self._box_opened_by_fire_sale )
		{
			level.chest_accessed = level.chest_accessed + 1;
		}
		if( IsDefined( level.pulls_since_last_ray_gun ) && level.chest_moves > 0 )
		{
			level.pulls_since_last_ray_gun = level.pulls_since_last_ray_gun + 1;
		}
		if( IsDefined( level.pulls_since_last_tesla_gun ) )
		{
			level.pulls_since_last_tesla_gun = level.pulls_since_last_tesla_gun + 1;
		}
		thread unregister_unitrigger( self.unitrigger_stub );
		if( IsDefined( self.chest_lid ) )
		{
			self.chest_lid thread treasure_chest_lid_close( self.timedout );
		}
		if( IsDefined( self.zbarrier ) )
		{
			self.zbarrier set_magic_box_zbarrier_state( "close" );
			play_sound_at_pos( "close_chest", self.origin );
			self.zbarrier waittill( "closed" );
			wait 1;
		}
		else
		{
			wait 3;
		}
		if( self == level.chests[ level.chest_index] || self [[  ]]() || level.zombie_vars[ "zombie_powerup_fire_sale_on"] && IsDefined( level.zombie_vars[ "zombie_powerup_fire_sale_on"] ) )
		{
			thread register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );
		}
	}
	self._box_open = 0;
	level.box_open = 0;
	level.shared_box = 0;
	level.magic_box_grab_by_anyone = 0;
	self._box_opened_by_fire_sale = 0;
	self.chest_user = undefined;
	self notify( "chest_accessed" );
	self thread treasure_chest_think();

}

custom_afterlife( b_electric_chair )
{
	if( !(IsDefined( self.activate_afterlife_after_spawn )) )
	{
		self.activate_afterlife_after_spawn = 1;
		self.afterlife = 0;
	}
	self.dontspeak = 1;
	self.health = 1000;
	b_has_electric_cherry = 0;
	if( self hasperk( "specialty_grenadepulldeath" ) )
	{
		b_has_electric_cherry = 1;
	}
	self [[  ]]();
	self afterlife_fake_death();
	if( !(b_electric_chair)b_electric_chair )
	{
		wait 1;
	}
	if( !(b_electric_chair)b_electric_chair && IsDefined( b_electric_chair ) && b_has_electric_cherry )
	{
		self electric_cherry_laststand();
		wait 2;
	}
	self setclientfieldtoplayer( "clientfield_afterlife_audio", 1 );
	if( flag( "afterlife_start_over" ) )
	{
		self clientnotify( "al_t" );
		wait 1;
		self thread fadetoblackforxsec( 0, 1, 0.5, 0.5, "white" );
		wait 0.5;
	}
	self ghost();
	self.e_afterlife_corpse = self afterlife_spawn_corpse();
	self thread afterlife_clean_up_on_disconnect();
	self freezecontrols( 0 );
	if( level.map_location == "rooftop" )
	{
		self custom_afterlife_fake_revive();
	}
	if( level.map_location == "bridge" )
	{
		self afterlife_fake_revive();
	}
	self afterlife_enter();
	self.e_afterlife_corpse setclientfield( "player_corpse_id", self getentitynumber() + 1 );
	wait 0.5;
	self show();
	if( !(self.hostmigrationcontrolsfrozen)self.hostmigrationcontrolsfrozen )
	{
		self freezecontrols( 0 );
	}
	self disableinvulnerability();
	self.e_afterlife_corpse waittill( "player_revived", e_reviver );
	self notify( "player_revived" );
	self seteverhadweaponall( 1 );
	self enableinvulnerability();
	self.afterlife_revived = 1;
	playsoundatposition( "zmb_afterlife_spawn_leave", self.e_afterlife_corpse.origin );
	self afterlife_leave();
	self thread afterlife_revive_invincible();
	self playsound( "zmb_afterlife_revived_gasp" );

}

custom_afterlife_fake_revive()
{
	level notify( "fake_revive" );
	self notify( "fake_revive" );
	playsoundatposition( "zmb_afterlife_spawn_leave", self.origin );
	if( flag( "afterlife_start_over" ) )
	{
		loc = [];
		loc[0] = ( 3770, 9823, 1704 );
		loc[1] = ( 2891, 9396, 1704 );
		loc[2] = ( 2406, 9528, 1704 );
		spawnpoint = [[  ]]();
		trace_start = spawnpoint.origin;
		trace_end += vector_scale( ( 0, 0, 1 ), 200 );
		respawn_trace = playerphysicstrace( trace_start, trace_end );
		self setorigin( loc[ randomintrange( 0, 3 )] );
		self setplayerangles( spawnpoint.angles );
		playsoundatposition( "zmb_afterlife_spawn_enter", spawnpoint.origin );
	}
	else
	{
		playsoundatposition( "zmb_afterlife_spawn_enter", self.origin );
	}
	self allowstand( 1 );
	self allowcrouch( 0 );
	self allowprone( 0 );
	self.ignoreme = 0;
	self setstance( "stand" );
	self giveweapon( "lightning_hands_zm" );
	self switchtoweapon( "lightning_hands_zm" );
	self.score = 0;
	wait 1;

}

wallweapons( weapon, origin, angles, cost, ammo )
{
	wallweap = spawnentity( "script_model", getweaponmodel( weapon ), origin, angles + ( 0, 50, 0 ) );
	wallweap thread wallweaponmonitor( weapon, cost, ammo );

}

spawnentity( class, model, origin, angle )
{
	entity = spawn( class, origin );
	entity.angles = angle;
	entity setmodel( model );
	return entity;

}

wallweaponmonitor( weapon, cost, ammo )
{
	self endon( "game_ended" );
	name = get_weapon_display_name( weapon );
	self.in_use_weap = 0;
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( distance( self.origin, player.origin ) <= 70 )
			{
				player thread spawnhint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 For Buy " + ( name + ( " [Cost: " + ( cost + ( "] Ammo [Cost: " + ( ammo + "] Upgraded Ammo [Cost: 4500]" ) ) ) ) ) );
				if( !(player player_is_in_laststand())player player_is_in_laststand() )
				{
					if( !(player player_is_in_laststand())player player_is_in_laststand() && player can_buy_weapon() && player.score >= cost )
					{
						player playsound( "zmb_cha_ching" );
						player.score = player.score - cost;
						player thread weapon_give( weapon, 0, 1 );
						wait 3;
					}
					else
					{
						if( player.score >= 4500 && player has_upgrade( weapon ) )
						{
							if( player ammo_give( get_upgrade_weapon( weapon ) ) )
							{
								player.score = player.score - 4500;
								player playsound( "zmb_cha_ching" );
								wait 3;
							}
						}
						else
						{
							if( player.score >= ammo && player hasweapon( weapon ) )
							{
								if( player ammo_give( weapon ) )
								{
									player.score = player.score - ammo;
									player playsound( "zmb_cha_ching" );
									wait 3;
								}
							}
						}
					}
				}
			}
		}
		wait 0.1;
	}

}

custom_powerup_grab( s_powerup, e_player )
{
	if( s_powerup.powerup_name == "zombie_cash" )
	{
		foreach( player in level.players )
		{
			player thread power_up_hud( 0, 0, 0, "Zombie Cash!" );
			player.score = player.score + 100 * randomintrange( -6, 21 );
			if( player.score < 0 )
			{
				player.score = 0;
			}
		}
	}
	if( s_powerup.powerup_name == "unlimited_ammo" )
	{
		level thread unlimited_ammo_powerup();
	}
	if( s_powerup.powerup_name == "death_machine" )
	{
		e_player notify( "Death_Machine" );
		e_player setperk( "specialty_fastweaponswitch" );
		e_player thread death_machine();
	}
	if( s_powerup.powerup_name == "firesales" )
	{
		level thread start_fire_sale();
	}
	if( s_powerup.powerup_name == "pap_box" )
	{
		level notify( "Pap_box_Stop" );
		foreach( player in level.players )
		{
			player thread power_up_hud( 0, 0, "menu_lobby_icon_twitter", "Pack a Punch Guns in Box!" );
		}
		level thread pap_box();
	}
	else
	{
		if( IsDefined( level.original_zombiemode_powerup_grab ) )
		{
			level thread [[  ]]( s_powerup, e_player );
		}
	}

}

start_fire_sale()
{
	if( is_true( level.zombie_vars[ "zombie_powerup_fire_sale_on"] ) && level.zombie_vars[ "zombie_powerup_fire_sale_time"] > 0 )
	{
		level.zombie_vars["zombie_powerup_fire_sale_time"] += 30;
	}
	level notify( "powerup fire sale" );
	level endon( "powerup fire sale" );
	level thread leaderdialog( "fire_sale" );
	level.zombie_vars["zombie_powerup_fire_sale_on"] = 1;
	level thread toggle_fire_sale_on();
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 30;
	while( level.zombie_vars[ "zombie_powerup_fire_sale_time"] > 0 )
	{
		wait 0.05;
		level.zombie_vars["zombie_powerup_fire_sale_time"] -= 0.05;
	}
	level.zombie_vars["zombie_powerup_fire_sale_on"] = 0;
	level notify( "fire_sale_off" );

}

pap_box()
{
	level endon( "Pap_box_Stop" );
	level.pap_weapons_box = 1;
	wait 30;
	while( level.box_open && IsDefined( level.box_open ) )
	{
		wait 0.1;
	}
	wait 0.1;
	level.pap_weapons_box = 0;

}

death_machine()
{
	self endon( "Death_Machine" );
	self.death_machine = 1;
	while( self.afterlife )
	{
		wait 0.1;
	}
	self thread full();
	weap = "minigun_alcatraz_upgraded_zm";
	if( self getweaponslistprimaries().size < custom_get_player_weapon_limit( self ) )
	{
		self giveweapon( weap, 0, self get_pack_a_punch_weapon_options( weap ) );
		self switchtoweapon( weap );
	}
	self thread power_up_hud( 0, "menu_lobby_icon_facebook", 0, "Death Machine!" );
	wait 1.5;
	i = 0;
	while( i < 570 )
	{
		if( self isswitchingweapons() )
		{
			wait 0.1;
			break;
		}
		wait 0.05;
		i++;
	}
	self notify( "Death_Machine_Stop" );
	while( self.afterlife )
	{
		wait 0.1;
	}
	wait 0.1;
	self takeweapon( "minigun_alcatraz_upgraded_zm" );
	self.death_machine = 0;
	self unsetperk( "specialty_fastweaponswitch" );

}

full()
{
	self endon( "Death_Machine_Stop" );
	for(;;)
	{
	if( self getcurrentweapon() == "minigun_alcatraz_upgraded_zm" )
	{
		self setweaponammoclip( self getcurrentweapon(), 999 );
	}
	wait 0.1;
	}

}

unlimited_ammo_powerup( origin, angles )
{
	foreach( player in level.players )
	{
		player notify( "end_unlimited_ammo" );
		player playsound( "zmb_cha_ching" );
		player thread startammo();
		player thread power_up_hud( "hud_icon_colt", 0, 0, "Infinite Ammo!" );
		player thread endammo();
	}

}

power_up_hud( shader, shader2, shader3, text )
{
	self endon( "disconnect" );
	power_up_hud_string = newclienthudelem( self );
	power_up_hud_string.elemtype = "font";
	power_up_hud_string.font = "objective";
	power_up_hud_string.fontscale = 2;
	power_up_hud_string.x = 0;
	power_up_hud_string.y = 0;
	power_up_hud_string.width = 0;
	power_up_hud_string.height = int( level.fontheight * 2 );
	power_up_hud_string.xoffset = 0;
	power_up_hud_string.yoffset = 0;
	power_up_hud_string.children = [];
	power_up_hud_string setparent( level.uiparent );
	power_up_hud_string.hidden = 0;
	power_up_hud_string setpoint( "TOP", undefined, 0, level.zombie_vars[ "zombie_timer_offset"] - level.zombie_vars[ "zombie_timer_offset_interval"] * 2 );
	power_up_hud_string.sort = 0.5;
	power_up_hud_string.alpha = 0;
	power_up_hud_string fadeovertime( 0.5 );
	power_up_hud_string.alpha = 1;
	power_up_hud_string settext( text );
	power_up_hud_string thread string_move();
	if( shader )
	{
		power_up_hud_icon = newclienthudelem( self );
		power_up_hud_icon.horzalign = "center";
		power_up_hud_icon.vertalign = "bottom";
		power_up_hud_icon.x = -75;
		power_up_hud_icon.y = 0;
		power_up_hud_icon.alpha = 1;
		power_up_hud_icon.hidewheninmenu = 1;
		power_up_hud_icon setshader( shader, 30, 30 );
		self thread power_up_hud_icon_blink( power_up_hud_icon );
		self thread destroy_power_up_icon_hud( power_up_hud_icon );
	}
	if( shader2 )
	{
		power_up_hud2_icon = newclienthudelem( self );
		power_up_hud2_icon.horzalign = "center";
		power_up_hud2_icon.vertalign = "bottom";
		power_up_hud2_icon.x = -110;
		power_up_hud2_icon.y = 0;
		power_up_hud2_icon.alpha = 1;
		power_up_hud2_icon.hidewheninmenu = 1;
		power_up_hud2_icon setshader( shader2, 30, 30 );
		self thread power_up_hud_icon_blink( power_up_hud2_icon );
		self thread destroy_power_up_icon_hud2( power_up_hud2_icon );
	}
	if( shader3 )
	{
		power_up_hud3_icon = newclienthudelem( self );
		power_up_hud3_icon.horzalign = "center";
		power_up_hud3_icon.vertalign = "bottom";
		power_up_hud3_icon.x = -145;
		power_up_hud3_icon.y = 0;
		power_up_hud3_icon.alpha = 1;
		power_up_hud3_icon.hidewheninmenu = 1;
		power_up_hud3_icon setshader( shader3, 30, 30 );
		self thread power_up_hud_icon_blink( power_up_hud3_icon );
		self thread destroy_power_up_icon_hud3( power_up_hud3_icon );
	}

}

string_move()
{
	wait 0.5;
	self fadeovertime( 1.5 );
	self moveovertime( 1.5 );
	self.y = 270;
	self.alpha = 0;
	wait 1.5;
	self destroy();

}

power_up_hud_icon_blink( elem )
{
	level endon( "disconnect" );
	self endon( "disconnect" );
	time_left = 30;
	for(;;)
	{
	if( time_left <= 5 )
	{
		time = 0.1;
		break;
	}
	else
	{
		if( time_left <= 10 )
		{
			time = 0.2;
			break;
		}
		wait 0.05;
		time_left = time_left - 0.05;
		continue;
	}
	elem fadeovertime( time );
	elem.alpha = 0;
	wait time;
	elem fadeovertime( time );
	elem.alpha = 1;
	wait time;
	time_left = time_left - time * 2;
	}

}

destroy_power_up_icon_hud( elem )
{
	level endon( "game_ended" );
	self waittill_any_timeout( "disconnect", "end_unlimited_ammo" );
	elem destroy();

}

destroy_power_up_icon_hud2( elem2 )
{
	level endon( "game_ended" );
	self waittill_any_timeout( "disconnect", "Death_Machine_Stop" );
	elem2 destroy();

}

destroy_power_up_icon_hud3( elem3 )
{
	level endon( "game_ended" );
	self waittill_any_timeout( 30, "disconnect" );
	elem3 destroy();

}

endammo()
{
	level endon( "game_ended" );
	self endon( "disonnect" );
	self endon( "end_unlimited_ammo" );
	wait 30;
	self playsound( "zmb_insta_kill" );
	self notify( "end_unlimited_ammo" );

}

startammo()
{
	level endon( "game_ended" );
	self endon( "disonnect" );
	self endon( "end_unlimited_ammo" );
	for(;;)
	{
	wait 0.05;
	weapon = self getcurrentweapon();
	if( weapon != "blundersplat_upgraded_zm" && weapon != "blundersplat_zm" && weapon != "claymore_zm" && weapon != "none" )
	{
		max = weaponmaxammo( weapon );
		if( IsDefined( max ) )
		{
			self setweaponammoclip( weapon, 150 );
			wait 0.02;
		}
	}
	}

}

acid_bench( origin, angles )
{
	bench = spawn( "script_model", origin );
	bench setmodel( "p6_zm_work_bench" );
	bench.angles = angles;
	bench.souls = 0;
	if( level.map_location == "rooftop" )
	{
		col = spawn( "script_model", ( 3012.2, 10035.7, 1720.875 ) );
		col setmodel( "collision_clip_64x64x64" );
		col.angles = angles;
		col2 = spawn( "script_model", ( 2960.2, 10035.7, 1720.875 ) );
		col2 setmodel( "collision_clip_64x64x64" );
		col2.angles = angles;
	}
	if( level.map_location == "bridge" )
	{
		col = spawn( "script_model", ( -705.2, -3285.697, -8415.875 ) );
		col setmodel( "collision_clip_64x64x64" );
		col.angles = angles;
		col2 = spawn( "script_model", ( -680.2, -3285.697, -8415.875 ) );
		col2 setmodel( "collision_clip_64x64x64" );
		col2.angles = angles;
	}
	acidgatmodel = spawn( "script_model", origin + ( 0, 0, 45 ) );
	acidgatmodel setmodel( "p6_anim_zm_al_packasplat" );
	acidgatmodel.angles = angles;
	trigger = spawn( "trigger_radius", origin + ( 0, 0, 32 ), 0, 35, 70 );
	trigger.targetname = "acid_gat_trigger";
	trigger.angles = angles;
	trigger setcursorhint( "HINT_NOICON" );
	if( level.map_location == "bridge" )
	{
		trigger sethintstring( "Complete Acidgat Challenge first." );
		thread acid_challenge();
		level waittill( "acid_challenge_completed" );
	}
	wait 2;
	trigger sethintstring( "Hold ^3&&1^7 to convert Blundergat into Acidgat [Cost: 5000]" );
	trigger waittill( "trigger", player );
	if( player usebuttonpressed() )
	{
		weap = player getcurrentweapon();
		while( weap == "blundergat_upgraded_zm" || weap == "blundergat_zm" )
		{
			player playsound( "zmb_cha_ching" );
			player.score = player.score - 5000;
			if( weap == "blundergat_zm" )
			{
				player takeweapon( "blundergat_zm" );
			}
			else
			{
				if( weap == "blundergat_upgraded_zm" )
				{
					player takeweapon( "blundergat_upgraded_zm" );
				}
			}
			trigger sethintstring( "Converting..." );
			wait 5;
			trigger sethintstring( "Hold ^3&&1^7 for Acidgat" );
			if( distance( player.origin, trigger.origin ) < 65 && player usebuttonpressed() )
			{
				if( weap == "blundergat_zm" )
				{
					player giveweapon( "blundersplat_zm" );
					player switchtoweapon( "blundersplat_zm" );
					break;
				}
				else
				{
					if( weap == "blundergat_upgraded_zm" )
					{
						player giveweapon( "blundersplat_upgraded_zm" );
						player switchtoweapon( "blundersplat_upgraded_zm" );
						break;
					}
				}
			}
			wait 0.1;
		}
	}
	wait 0.1;
	trigger sethintstring( "Hold ^3&&1^7 to convert Blundergat into Acidgat [Cost: 5000]" );
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

shield_bench( origin, angles )
{
	bench = spawn( "script_model", origin );
	bench setmodel( "p6_zm_work_bench" );
	bench.angles = angles;
	bench.souls = 0;
	if( level.map_location == "bridge" )
	{
		col = spawn( "script_model", ( -825.2, -3285.697, -8415.875 ) );
		col setmodel( "collision_clip_64x64x64" );
		col.angles = angles;
		col2 = spawn( "script_model", ( -800.2, -3285.697, -8415.875 ) );
		col2 setmodel( "collision_clip_64x64x64" );
		col2.angles = angles;
	}
	if( level.map_location == "rooftop" )
	{
		col = spawn( "script_model", ( 3442.2, 10053.7, 1724.875 ) );
		col setmodel( "collision_clip_64x64x64" );
		col.angles = angles;
		col2 = spawn( "script_model", ( 3408.2, 10053.7, -8435.875 ) );
		col2 setmodel( "collision_clip_64x64x64" );
		col2.angles = angles;
	}
	shieldmodel = spawn( "script_model", origin + ( 0, 0, 70 ) );
	shieldmodel setmodel( getweaponmodel( "alcatraz_shield_zm" ) );
	shieldmodel.angles = angles;
	trigger = spawn( "trigger_radius", origin + ( 0, 0, 32 ), 0, 35, 70 );
	trigger.targetname = "Shield_trigger";
	trigger.angles = angles;
	trigger setcursorhint( "HINT_NOICON" );
	if( level.map_location == "bridge" )
	{
		trigger sethintstring( "Complete Shield challenge First." );
		thread shield_challenge();
		level waittill( "shield_challenge_completed" );
	}
	wait 2;
	trigger sethintstring( "Hold ^3&&1^7 to Buy Shield [Cost: 1500]" );
	for(;;)
	{
	trigger waittill( "trigger", player );
	if( player usebuttonpressed() )
	{
		if( player.score >= 1500 && !(player hasweapon( "alcatraz_shield_zm" )) )
		{
			player playsound( "zmb_cha_ching" );
			player.score = player.score - 1500;
			player treasure_chest_give_weapon( "alcatraz_shield_zm" );
		}
	}
	wait 0.1;
	}

}

can_buy_weapon()
{
	if( self getcurrentweapon() == "minigun_alcatraz_upgraded_zm" )
	{
		return 0;
	}
	if( self.is_drinking > 0 && IsDefined( self.is_drinking ) )
	{
		return 0;
	}
	if( self hacker_active() )
	{
		return 0;
	}
	if( self isswitchingweapons() )
	{
		return 0;
	}
	current_weapon = self getcurrentweapon();
	if( is_equipment_that_blocks_purchase( current_weapon ) || is_placeable_mine( current_weapon ) )
	{
		return 0;
	}
	if( self in_revive_trigger() )
	{
		return 0;
	}
	if( current_weapon == "none" )
	{
		return 0;
	}
	return 1;

}

shield_challenge()
{
	acid = spawn( "script_model", ( -1990, -3705, -8377 ) );
	acid setmodel( "t6_wpn_zmb_shield_dlc2_shackles" );
	acid.angles = ( 0, 90, 0 );
	trigger = spawn( "trigger_radius", ( -1930, -3705, -8407 ) + ( 0, 0, 32 ), 0, 35, 30 );
	trigger.targetname = "challenge_1_trigger";
	trigger.angles = ( 0, 0, 0 );
	trigger setcursorhint( "HINT_NOICON" );
	while( level.round_number < 5 )
	{
		trigger sethintstring( "This Challenge is not ready come back round^3 5" );
		level waittill( "between_round_over" );
	}
	trigger sethintstring( "Hold ^3&&1^7 to Start Shield Challenge" );
	trigger waittill( "trigger", player );
	if( !(level.challenge_started)level.challenge_started && !(player.afterlife) )
	{
		level.challenge_started = 1;
		fx = spawnfx( level._effect[ "ug"], ( -2000, -3705, -8357 ) );
		triggerfx( fx );
		trigger sethintstring( " " );
		iprintln( "Shield Challenge started" );
		wait 2;
		iprintln( "^1Challenge^7: Get 50 headshots" );
		break;
	}
	else
	{
		if( level.challenge_started && player usebuttonpressed() )
		{
			trigger sethintstring( "Complete current Challenge first." );
			wait 2;
			trigger sethintstring( "Hold ^3&&1^7 to Start Shield Challenge" );
		}
		wait 0.1;
		?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
	}
	trigger sethintstring( "Shield Challenge in Progress." );
	level.challenge_headshots = 0;
	level.headshot = createserverfontstring( "hudsmall", 1.2 );
	level.headshot setpoint( "MIDDLE", "TOP", -300 );
	while( 1 )
	{
		headshots -= level.challenge_headshots;
		level.headshot.label = &"Headshots Left: ^1";
		level.headshot setvalue( headshots );
		if( level.challenge_headshots == 50 )
		{
			iprintln( "Shield Challenge Completed!" );
			level notify( "shield_challenge_completed" );
			level.headshot destroy();
			break;
		}
		wait 0.1;
	}
	level.challenge_started = 0;
	fx delete();
	playfx( loadfx( "maps/zombie_alcatraz/fx_alcatraz_tomahawk_pickup" ), ( -1990, -3705, -8357 ), anglestoforward( ( 0, 0, 0 ) ) );
	trigger sethintstring( "Shield Challenge Completed." );

}

acid_challenge()
{
	acid = spawn( "script_model", ( -1990, -3625, -8377 ) );
	acid setmodel( "p6_zm_al_packasplat_iv" );
	acid.angles = ( 0, 0, 0 );
	trigger = spawn( "trigger_radius", ( -1924, -3625, -8407 ) + ( 0, 0, 32 ), 0, 35, 30 );
	trigger.targetname = "challenge_2_trigger";
	trigger.angles = ( 0, 0, 0 );
	trigger setcursorhint( "HINT_NOICON" );
	while( level.round_number < 15 )
	{
		trigger sethintstring( "This Challenge is not ready come back round^3 15" );
		level waittill( "between_round_over" );
	}
	trigger sethintstring( "Hold ^3&&1^7 to Start Acid Gat Challenge" );
	trigger waittill( "trigger", player );
	if( !(level.challenge_started)level.challenge_started && !(player.afterlife) )
	{
		level.challenge_started = 1;
		fx = spawnfx( level._effect[ "ug"], ( -2000, -3625, -8357 ) );
		triggerfx( fx );
		trigger sethintstring( " " );
		iprintln( "Acid Gat Challenge started" );
		wait 2;
		soul_box( "p6_zm_al_acid_trap_tank" );
		wait 1;
		iprintln( "^1Challenge^7: Fill all acid tanks with souls." );
		break;
	}
	else
	{
		if( level.challenge_started && player usebuttonpressed() )
		{
			trigger sethintstring( "Complete current Challenge first." );
			wait 2;
			trigger sethintstring( "Hold ^3&&1^7 to Start Acid Gat Challenge" );
		}
		wait 0.1;
		?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
	}
	trigger sethintstring( "Acid Gat Challenge in Progress." );
	while( 1 )
	{
		if( !(level.soulbox2_active)level.soulbox2_active && !(level.soulbox1_active) )
		{
			level notify( "acid_challenge_completed" );
			break;
		}
		else
		{
			wait 1;
			?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
	}
	level.challenge_started = 0;
	iprintln( "Acid Gat Challenge Completed!" );
	fx delete();
	playfx( loadfx( "maps/zombie_alcatraz/fx_alcatraz_tomahawk_pickup" ), ( -1990, -3625, -8357 ), anglestoforward( ( 0, 0, 0 ) ) );
	trigger sethintstring( "Acid Gat Challenge Completed." );

}

tomahawk_challenge()
{
	flag_wait( "initial_blackscreen_passed" );
	tomahawk = spawn( "script_model", ( -2000, -3545, -8357 ) );
	tomahawk setmodel( getweaponmodel( "bouncing_tomahawk_zm" ) );
	tomahawk.angles = ( 0, 90, 0 );
	trigger = spawn( "trigger_radius", ( -1930, -3545, -8407 ) + ( 0, 0, 32 ), 0, 35, 30 );
	trigger.targetname = "challenge_3_trigger";
	trigger.angles = ( 0, 0, 0 );
	trigger setcursorhint( "HINT_NOICON" );
	while( level.round_number < 7 )
	{
		trigger sethintstring( "This Challenge is not ready come back round^3 7" );
		level waittill( "between_round_over" );
	}
	trigger sethintstring( "Hold ^3&&1^7 to Start Tomahawk Challenge" );
	trigger waittill( "trigger", player );
	if( !(level.challenge_started)level.challenge_started && !(player.afterlife) )
	{
		level.challenge_started = 1;
		fx = spawnfx( level._effect[ "ug"], ( -2000, -3545, -8357 ) );
		triggerfx( fx );
		trigger sethintstring( " " );
		iprintln( "Tomahawk Challenge started" );
		wait 1;
		iprintln( "^1Challenge^7: Kill all Brutuses!" );
		wait 3;
		player thread challenge_brutus();
		break;
	}
	else
	{
		if( level.challenge_started && player usebuttonpressed() )
		{
			trigger sethintstring( "Complete current Challenge first." );
			wait 2;
			trigger sethintstring( "Hold ^3&&1^7 to Start Tomahawk Challenge" );
		}
		wait 0.1;
		?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
	}
	trigger sethintstring( "Tomahawk Challenge in Progress." );
	level waittill( "tomahawk_challenge_completed" );
	iprintln( "Tomahawk Challenge Completed!" );
	level.challenge_started = 0;
	fx delete();
	playfx( loadfx( "maps/zombie_alcatraz/fx_alcatraz_tomahawk_pickup" ), ( -2000, -3545, -8357 ), anglestoforward( ( 0, 0, 0 ) ) );
	trigger sethintstring( "Hold ^3&&1^7 for Tomahawk" );
	trigger waittill( "trigger", player );
	if( player usebuttonpressed() )
	{
		trigger sethintstring( " " );
		if( !(player hasweapon( "bouncing_tomahawk_zm" )) )
		{
			player giveweapon( "bouncing_tomahawk_zm" );
			wait 2;
		}
		else
		{
			trigger sethintstring( "You already have Tomahawk!" );
			wait 2;
		}
	}
	trigger sethintstring( "Hold ^3&&1^7 for Tomahawk" );
	wait 0.1;
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

perk_machine_challenge()
{
	number = [];
	number[0] = "x";
	number[1] = "z";
	acid = spawn( "script_model", ( -2000, -3468, -8377 ) );
	acid setmodel( "p6_anim_zm_al_magic_box_lock" );
	acid.angles = ( 0, 90, 0 );
	trigger = spawn( "trigger_radius", ( -1930, -3465, -8407 ) + ( 0, 0, 32 ), 0, 35, 30 );
	trigger.targetname = "challenge_4_trigger";
	trigger.angles = ( 0, 0, 0 );
	trigger setcursorhint( "HINT_NOICON" );
	while( level.round_number < 2 )
	{
		trigger sethintstring( "This Challenge is not ready come back round^3 2" );
		level waittill( "between_round_over" );
	}
	trigger sethintstring( "Hold ^3&&1^7 to Start Perk Machine Challenge" );
	trigger waittill( "trigger", player );
	if( !(level.challenge_started)level.challenge_started && !(player.afterlife) )
	{
		level.challenge_started = 1;
		fx = spawnfx( level._effect[ "ug"], ( -2000, -3470, -8357 ) );
		triggerfx( fx );
		trigger sethintstring( " " );
		iprintln( "Perk Machine Challenge started" );
		skull_number = number[ randomintrange( 0, 2 )];
		thread shotables( skull_number );
		wait 2;
		break;
	}
	else
	{
		if( level.challenge_started && player usebuttonpressed() )
		{
			trigger sethintstring( "Complete current Challenge first." );
			wait 2;
			trigger sethintstring( "Hold ^3&&1^7 to Start Perk Machine Challenge" );
		}
		wait 0.1;
		?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
	}
	foreach( player in level.players )
	{
		player playsoundtoplayer( "zmb_easteregg_face", player );
		wth_elem = newclienthudelem( player );
		wth_elem.horzalign = "fullscreen";
		wth_elem.vertalign = "fullscreen";
		wth_elem.sort = 1000;
		wth_elem.foreground = 0;
		wth_elem setshader( "zm_al_wth_zombie", 640, 480 );
		wth_elem.hidewheninmenu = 1;
		j_time = 0;
		while( j_time < 15 )
		{
			j_time++;
			wait 0.05;
		}
		wth_elem destroy();
	}
	trigger sethintstring( "Perk Machine Challenge in Progress." );
	wait 1;
	iprintln( "^1Challenge^7: Find and Shoot 5 blue skulls" );
	while( level.skullscollected < level.skullsneeded )
	{
		wait 1;
	}
	level.challenge_started = 0;
	level.perk_machine_challenge = 1;
	fx delete();
	playfx( loadfx( "maps/zombie_alcatraz/fx_alcatraz_tomahawk_pickup" ), ( -1990, -3468, -8357 ), anglestoforward( ( 0, 0, 0 ) ) );
	trigger sethintstring( "Perk Machine Challenge Completed." );

}

challenge_brutus()
{
	level.brutuses_killed = 0;
	level.tomahawk_challenge = 1;
	i = 7;
	while( i > 0 )
	{
		ai = brutus_spawn_in_zone( "zone_golden_gate_bridge", 1 );
		if( IsDefined( ai ) )
		{
			ai thread killed();
		}
		wait randomfloatrange( 4, 6 );
		i++;
	}
	while( level.brutuses_killed < 7 )
	{
		wait 1;
	}
	level notify( "tomahawk_challenge_completed" );
	level.tomahawk_challenge = 0;
	level.brutuscounter destroy();

}

killed()
{
	self.not_interruptable = 0;
	self waittill( "death" );
	level.brutuses_killed++;
	self delete();

}

souls( box )
{
	source_pos = self gettagorigin( "j_head" );
	target_pos += ( 0, 0, 20 );
	soul = spawn( "script_model", source_pos );
	soul setmodel( "tag_origin" );
	wait 0.1;
	fx = playfxontag( level._effect[ "souls"], soul, "tag_origin" );
	soul moveto( target_pos, 1 );
	soul waittill( "movedone" );
	soul delete();

}

soul_box( model )
{
	level._effect["souls"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_tomahawk_pickup_ug" );
	level.soulbox_active = 1;
	level.soulbox1_active = 1;
	level.soulbox2_active = 1;
	level.souls_needed = 50;
	level.soulbox_souls = 0;
	level.soulbox1_souls = 0;
	level.soulbox2_souls = 0;
	level.soulbox = spawnentity( "script_model", model, ( -890.2, -3853.697, -8447.875 ), ( 0, 0, 0 ) );
	level.soulbox1 = spawnentity( "script_model", model, ( -549.2, -3468.697, -8447.875 ), ( 0, 0, 0 ) );
	level.soulbox2 = spawnentity( "script_model", model, ( -1785.2, -3683.697, -8447.875 ), ( 0, 0, 0 ) );

}

custom_death_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	power_up = [];
	power_up[0] = "nuke";
	power_up[1] = "insta_kill";
	power_up[2] = "double_points";
	power_up[3] = "full_ammo";
	power_up[4] = "unlimited_ammo";
	power_up[5] = "firesales";
	if( isplayer( self.attacker ) && IsDefined( self.attacker ) && IsDefined( self.damageweapon ) && IsDefined( self.damagemod ) && IsDefined( self.damagelocation ) && IsDefined( self ) )
	{
		if( is_headshot( self.damageweapon, self.damagelocation, self.damagemod ) )
		{
			level.challenge_headshots++;
		}
	}
	if( level.soulbox_active )
	{
		if( distance( level.soulbox.origin, self.origin ) <= 300 )
		{
			self souls( level.soulbox.origin );
			playfx( loadfx( "misc/fx_zombie_powerup_solo_grab" ), level.soulbox.origin );
			level.soulbox_souls++;
			if( level.souls_needed <= level.soulbox_souls )
			{
				level thread specific_powerup_drop( power_up[ randomintrange( 0, 6 )], level.soulbox.origin );
				level.soulbox delete();
				level.soulbox_active = 0;
				ai = brutus_spawn_in_zone( "zone_golden_gate_bridge", 1 );
				ai thread killed();
			}
		}
	}
	if( level.soulbox1_active )
	{
		if( distance( level.soulbox1.origin, self.origin ) <= 300 )
		{
			self souls( level.soulbox1.origin );
			playfx( loadfx( "misc/fx_zombie_powerup_solo_grab" ), level.soulbox1.origin );
			level.soulbox1_souls++;
			if( level.souls_needed <= level.soulbox1_souls )
			{
				level thread specific_powerup_drop( power_up[ randomintrange( 0, 6 )], level.soulbox1.origin );
				level.soulbox1 delete();
				level.soulbox1_active = 0;
				ai = brutus_spawn_in_zone( "zone_golden_gate_bridge", 1 );
				ai thread killed();
			}
		}
	}
	if( level.soulbox2_active )
	{
		if( distance( level.soulbox2.origin, self.origin ) <= 250 )
		{
			self souls( level.soulbox2.origin );
			playfx( loadfx( "misc/fx_zombie_powerup_solo_grab" ), level.soulbox2.origin );
			level.soulbox2_souls++;
			if( level.souls_needed <= level.soulbox2_souls )
			{
				level thread specific_powerup_drop( power_up[ randomintrange( 0, 6 )], level.soulbox2.origin );
				level.soulbox2 delete();
				level.soulbox2_active = 0;
				ai = brutus_spawn_in_zone( "zone_golden_gate_bridge", 1 );
				ai thread killed();
			}
		}
	}

}

shootable( origin, angles )
{
	level.shotable = spawn( "script_model", origin );
	level.shotable setmodel( "p6_zm_al_skull_afterlife" );
	level.shotable.angles = angles;
	level.shotable.health = 5;
	level.shotable setcandamage( 1 );
	level.shotable thread skulls();

}

skulls()
{
	self endon( "shot" );
	level.skullsneeded = 5;
	level.skullscollected = 0;
	while( 1 )
	{
		self waittill( "damage", idamage, attacker, idflags, vpoint, type, victim, vdir, shitloc, psoffsettime, sweapon );
		if( self.health <= 0 )
		{
			level.skullscollected++;
			self playsound( "zmb_cha_ching" );
			self delete();
			if( level.skullscollected >= level.skullsneeded )
			{
				iprintln( "perk machine challenge completed!" );
			}
			self notify( "shot" );
		}
		wait 0.1;
	}

}

shotables( skull_number )
{
	if( skull_number == "x" )
	{
		shootable( ( -1695, -3515.71, -8390.46 ), ( 0, -45, 0 ) );
		shootable( ( -284.369, -3590.65, -7925.88 ), ( 0, -90, 0 ) );
		shootable( ( -1695, -3975.71, -8420.46 ), ( 0, -90, 0 ) );
		shootable( ( -1646, -3160.71, -8340.88 ), ( 0, 0, 0 ) );
		shootable( ( -1287, -3948.71, -8375.46 ), ( 0, -90, 0 ) );
	}
	if( skull_number == "z" )
	{
		shootable( ( -350, -3805.71, -8390.46 ), ( 0, -45, 0 ) );
		shootable( ( -1561, -3402.71, -7925.46 ), ( 0, 90, 0 ) );
		shootable( ( -1926, -3515.71, -8445.46 ), ( 0, 90, 0 ) );
		shootable( ( -1226, -3136.71, -8418.46 ), ( 0, 90, 0 ) );
		shootable( ( -834, -3561.71, -8377.46 ), ( 0, -135, 0 ) );
	}
	level.skulls = createserverfontstring( "hudsmall", 1.2 );
	level.skulls setpoint( "MIDDLE", "TOP", -300 );
	while( level.skullscollected < level.skullsneeded )
	{
		skulls -= level.skullscollected;
		level.skulls setvalue( skulls );
		level.skulls.label = &"Skulls Left ^1";
		wait 0.3;
	}
	level.skulls destroy();

}

map_rotation()
{
	level.maplist = strtok( level.custommaprotation, " " );
	level.custommaprotation = "bridge rooftop";
	level.nextmap = randomint( level.maplist.size );
	level.lastmap = getdvar( "lastMap" );
	if( level.maplist[ level.nextmap] == level.lastmap || level.map_location == level.maplist[ level.nextmap] )
	{
		return map_rotation();
	}
	else
	{
		setdvar( "lastMap", level.maplist[ level.nextmap] );
		setdvar( "customMap", level.maplist[ level.nextmap] );
	}

}

