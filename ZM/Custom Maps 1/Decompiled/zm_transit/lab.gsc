//Decompiled with SeriousHD-'s GSC Decompiler
#include codescripts/struct;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/_zm_transit_bus;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_score;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weap_cymbal_monkey;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_weap_claymore;
#include maps/mp/zombies/_zm_ai_avogadro;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_devgui;
#include maps/mp/zombies/_zm_weap_jetgun;
#include maps/mp/zombies/_zm_weap_thundergun;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_ai_screecher;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zm_transit_bus;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/zombies/_zm_weap_jetgun;
#include maps/mp/gametypes_zm/_rank;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/_utility;
#include maps/mp/gametypes_zm/_zm_gametype;
init()
{
	map = getdvarintdefault( "CUSTOM_MAP", "none" );
	if( map == 5 )
	{
		if( getdvar( "g_gametype" ) == "zclassic" && getdvar( "mapname" ) == "zm_transit" )
		{
			precachemodels = array( "collision_player_256x256x10", "p_rus_rb_lab_portable_curtain", "p_rus_animal_cage_medium_01", "zm_collision_perks1", "collision_player_64x64x10", "collision_player_512x512x10", "p_glo_bucket_metal", "t6_wpn_zmb_perk_bottle_revive_world", "p_rus_crate_metal_2", "zombie_teddybear", "p_rus_crate_metal_1", "p_zom_barrel_02", "p6_zm_core_reactor_floor_tile_a4_labs", "p6_zm_core_reactor_floor_tile_b5_labs", "p6_zm_core_reactor_floor_tile_b1_labs", "p6_zm_core_reactor_floor_tile_a1_labs", "static_peleliu_filecabinet_metal", "p_lights_lantern_hang_on_corn", "p6_zm_door_tearin_wood01", "p_cub_door_wood_frame01", "p_jun_metal_shelves_town", "p_jun_metal_shelves_cornfield", "p_glo_bookshelf_wide_d", "p6_zm_church_column_tall", "p_glo_sandbags_green_lego_mdl", "p6_zm_tunnel_pillar_1", "afr_barrel_biohazard_white_rust", "p6_zm_rocks_small_cluster_01", "zm_collision_perks1", "p6_anim_zm_buildable_pap_on", "collision_wall_512x512x10_standard", "collision_player_wall_512x512x10", "t5_foliage_tree_burnt03", "veh_t6_civ_bus_zombie", "t6_wpn_zmb_perk_bottle_revive_view", "zombie_z_money_icon", "pb_pole_telephone_bulb", "p_glo_street_light02", "p_glo_street_light02_on_light", "p_glo_street_light01_fx_shell", "t6_wpn_zmb_perk_bottle_marathon_world", "t6_wpn_zmb_perk_bottle_sleight_world", "t6_wpn_zmb_perk_bottle_jugg_world", "t6_wpn_zmb_perk_bottle_doubletap_world", "p_zom_clock_hourhand", "veh_t6_civ_60s_coupe_dead", "c_zom_player_zombie_fb", "p6_anim_zm_buildable_turbine", "veh_t6_civ_microbus_dead" );
			foreach( model in precachemodels )
			{
				precachemodel( model );
			}
			level thread onplayerconnect();
			setdvar( "scr_screecher_ignore_player", 1 );
			flag_wait( "start_zombie_round_logic" );
			level.pers_upgrades_keys = [];
			level.pers_upgrades = [];
			thread custom_map();
			box_init();
			level thread zone_and_spawners();
			level thread delete_corpses();
			level thread zombie_speed();
		}
	}

}

zombie_speed()
{
	while( level.round_number < 3 )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( !(IsDefined( zombie.run_set )) )
			{
				zombie set_zombie_run_cycle( "run" );
				zombie.run_set = 1;
			}
		}
		wait 1;
	}

}

delete_corpses()
{
	wait 10;
	for(;;)
	{
	foreach( corpse in getcorpsearray() )
	{
		corpse delete();
		wait 0.05;
	}
	wait 2;
	}

}

onplayerconnect()
{
	for(;;)
	{
	if( level.player_out_of_playable_area_monitor && IsDefined( level.player_out_of_playable_area_monitor ) )
	{
		level.player_out_of_playable_area_monitor = 0;
	}
	if( level.player_too_many_weapons_monitor && IsDefined( level.player_too_many_weapons_monitor ) )
	{
		level.player_too_many_weapons_monitor = 0;
	}
	level waittill( "connected", player );
	player thread onplayerspawned();
	}

}

onplayerspawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	player = getplayers();
	spawnpoints = array( ( 2011, -624, -303.875 ), ( 2020, -660, -303.875 ), ( 1970, -565, -303.875 ), ( 2050, -610, -303.875 ) );
	for(;;)
	{
	self waittill( "spawned_player" );
	if( self == player[ 0] )
	{
		self setorigin( ( 2011, -170, -303.875 ) );
	}
	wait 1;
	i = randomintrange( 0, spawnpoints.size );
	self setorigin( spawnpoints[ i] );
	if( self.initial_spawn == 1 )
	{
		self.initial_spawn = 0;
		flag_wait( "start_zombie_round_logic" );
		wait 5;
		self iprintln( "The ^1Laboratory ^7- One Window Challenge" );
	}
	}

}

butcket_of_perks( model, origin, angles, sound, name, cost, perk )
{
	bottle1 = spawn( "script_model", origin + ( 3, 3, 0 ) );
	bottle1.angles = ( 0, 90, 0 );
	bottle1 setmodel( model );
	bottle2 = spawn( "script_model", origin - ( 3, 3, 0 ) );
	bottle2.angles = ( 0, 90, 0 );
	bottle2 setmodel( model );
	bottle3 = spawn( "script_model", origin + ( ( 0, 3, 0 ) - ( 3, 0, 0 ) ) );
	bottle3.angles = ( 0, 90, 0 );
	bottle3 setmodel( model );
	bottle4 = spawn( "script_model", origin + ( ( 3, 0, 0 ) - ( 0, 3, 0 ) ) );
	bottle4.angles = ( 0, 90, 0 );
	bottle4 setmodel( model );
	trigger = spawn( "trigger_radius", origin + ( 20, 0, 0 ), 0, 5, 5 );
	trigger setcursorhint( "HINT_NOICON" );
	trigger sethintstring( "Hold ^3&&1^7 for " + ( name + ( " [Cost: " + ( cost + "]" ) ) ) );
	for(;;)
	{
	trigger waittill( "trigger", player );
	if( player.score >= cost && !(player hasperk( perk ))player hasperk( perk ) && player usebuttonpressed() )
	{
		player playsound( "zmb_cha_ching" );
		player.score = player.score - cost;
		player playsound( sound );
		player thread dogiveperk( perk );
		wait 4;
	}
	else
	{
		if( player.score < cost && player usebuttonpressed() )
		{
			player create_and_play_dialog( "general", "perk_deny", undefined, 0 );
		}
	}
	wait 0.1;
	}

}

butcket_of_perks_revive( model, origin, angles, sound )
{
	level.solo_revives = 0;
	bottle1 = spawn( "script_model", origin + ( 3, 3, 0 ) );
	bottle1.angles = ( 0, 90, 0 );
	bottle1 setmodel( model );
	bottle2 = spawn( "script_model", origin - ( 3, 3, 0 ) );
	bottle2.angles = ( 0, 90, 0 );
	bottle2 setmodel( model );
	bottle3 = spawn( "script_model", origin + ( ( 0, 3, 0 ) - ( 3, 0, 0 ) ) );
	bottle3.angles = ( 0, 90, 0 );
	bottle3 setmodel( model );
	bottle4 = spawn( "script_model", origin + ( ( 3, 0, 0 ) - ( 0, 3, 0 ) ) );
	bottle4.angles = ( 0, 90, 0 );
	bottle4 setmodel( model );
	trigger = spawn( "trigger_radius", origin + ( 20, 0, 0 ), 0, 5, 5 );
	trigger setcursorhint( "HINT_NOICON" );
	for(;;)
	{
	if( get_players().size > 1 )
	{
		trigger sethintstring( "Hold ^3&&1^7 for Revive [Cost: 1500]" );
		cost = 1500;
		level.solo_revives = 0;
	}
	else
	{
		trigger sethintstring( "Hold ^3&&1^7 for Revive [Cost: 500]" );
		cost = 500;
	}
	trigger waittill( "trigger", player );
	if( player can_buy() && player.score >= cost && player usebuttonpressed() )
	{
		if( level.solo_revives < 3 && !(player hasperk( "specialty_quickrevive" )) )
		{
			if( get_players().size < 2 )
			{
				level.solo_revives++;
			}
			player thread dogiveperk( "specialty_quickrevive" );
			player playsound( "zmb_cha_ching" );
			player.score = player.score - cost;
			player playsound( "mus_perks_revive_sting" );
			wait 3;
		}
		else
		{
			if( !(player hasperk( "specialty_quickrevive" ))player hasperk( "specialty_quickrevive" ) )
			{
				player iprintln( "you have already bought 3 quick revives." );
				player create_and_play_dialog( "general", "oh_shit" );
				wait 3;
			}
		}
	}
	else
	{
		if( player.score < cost && player usebuttonpressed() )
		{
			player create_and_play_dialog( "general", "perk_deny", undefined, 0 );
		}
	}
	wait 0.1;
	}

}

can_buy()
{
	if( self.is_drinking > 0 && IsDefined( self.is_drinking ) )
	{
		return 0;
	}
	if( self isswitchingweapons() )
	{
		return 0;
	}
	if( self player_is_in_laststand() )
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

custom_map()
{
	newmodel = spawn( "script_model", ( 2145, -226, -303.875 ) );
	newmodel.angles = ( -90, 90, 0 );
	newmodel setmodel( "p6_zm_core_reactor_floor_tile_a1_labs" );
	newmodel = spawn( "script_model", ( 1925, -226, -303.875 ) );
	newmodel.angles = ( -90, 90, 0 );
	newmodel setmodel( "p6_zm_core_reactor_floor_tile_a1_labs" );
	newmodel = spawn( "script_model", ( 1869.44, -223, -58.875 ) );
	newmodel.angles = ( 0, -180, -90 );
	newmodel setmodel( "p6_zm_bank_vault_floor_hatch" );
	newmodel = spawn( "script_model", ( 2302, -530, -323.875 ) );
	newmodel.angles = ( -90, 90, 0 );
	newmodel setmodel( "p6_zm_core_reactor_floor_tile_a1_labs" );
	newmodel = spawn( "script_model", ( 2318, -675, -323.875 ) );
	newmodel.angles = ( -90, 0, 0 );
	newmodel setmodel( "p6_zm_core_reactor_floor_tile_a1_labs" );
	newmodel = spawn( "script_model", ( 1918, -450.338, -303.875 ) );
	newmodel.angles = ( -90, 0, 0 );
	newmodel setmodel( "collision_player_512x512x10" );
	newmodel = spawn( "script_model", ( 2290, -675, -303.875 ) );
	newmodel.angles = ( -90, 0, 0 );
	newmodel setmodel( "collision_player_512x512x10" );
	newmodel = spawn( "script_model", ( 1931.33, -490.877, -250.875 ) );
	newmodel.angles = ( 90, 90, 0 );
	newmodel setmodel( "collision_player_64x64x10" );
	newmodel = spawn( "script_model", ( 2095.13, -508.394, -250.875 ) );
	newmodel.angles = ( 90, 65, 0 );
	newmodel setmodel( "collision_player_64x64x10" );
	newmodel = spawn( "script_model", ( 2009.74, -770, -303.875 ) );
	newmodel.angles = ( -90, 90, 0 );
	newmodel setmodel( "collision_player_512x512x10" );
	newmodel = spawn( "script_model", ( 2063.68, -743.142, -296.725 ) );
	newmodel.angles = ( 0, 90, 0 );
	newmodel setmodel( "zm_collision_perks1" );
	newmodel = spawn( "script_model", ( 2121.71, -685, -303.875 ) );
	newmodel.angles = ( 0, 90, 0 );
	newmodel setmodel( "zm_collision_perks1" );
	newmodel = spawn( "script_model", ( 2100, -390.018, -303.875 ) );
	newmodel.angles = ( 90, 35, 0 );
	newmodel setmodel( "collision_player_256x256x10" );
	newmodel = spawn( "script_model", ( 2032.56, -266.191, -303.875 ) );
	newmodel.angles = ( 0, 90, 0 );
	newmodel setmodel( "zm_collision_perks1" );
	newmodel = spawn( "script_model", ( 2009.74, -768.277, -303.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_zom_barrel_02" );
	newmodel = spawn( "script_model", ( 1905.69, -766.673, -303.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_zom_barrel_02" );
	newmodel = spawn( "script_model", ( 1900, -770.673, -265.875 ) );
	newmodel.angles = ( 0, 45, 0 );
	newmodel setmodel( "zombie_teddybear" );
	newmodel = spawn( "script_model", ( 1905, -632.677, -303.875 ) );
	newmodel.angles = ( 0, 90, 0 );
	newmodel setmodel( "p_rus_crate_metal_1" );
	newmodel = spawn( "script_model", ( 1905, -550, -303.875 ) );
	newmodel.angles = ( 0, 90, 0 );
	newmodel setmodel( "p_rus_crate_metal_1" );
	newmodel = spawn( "script_model", ( 1905, -534, -275.875 ) );
	newmodel.angles = ( 0, 60, 0 );
	newmodel setmodel( "p_rus_crate_metal_2" );
	newmodel = spawn( "script_model", ( 2121.68, -458.145, -303.875 ) );
	newmodel.angles = ( 0, 90, 0 );
	newmodel setmodel( "p_rus_crate_metal_1" );
	newmodel = spawn( "script_model", ( 2121.68, -458.145, -275.875 ) );
	newmodel.angles = ( 0, 90, 0 );
	newmodel setmodel( "p_rus_crate_metal_1" );
	newmodel = spawn( "script_model", ( 2028.58, -265.201, -282.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_rus_animal_cage_medium_01" );
	newmodel = spawn( "script_model", ( 2070, -265.201, -282.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_rus_animal_cage_medium_01" );
	newmodel = spawn( "script_model", ( 2112, -265.201, -282.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_rus_animal_cage_medium_01" );
	newmodel = spawn( "script_model", ( 2112, -265.201, -242.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_rus_animal_cage_medium_01" );
	newmodel = spawn( "script_model", ( 2112, -305.201, -282.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_rus_animal_cage_medium_01" );
	newmodel = spawn( "script_model", ( 2111.59, -350.641, -303.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_zom_barrel_02" );
	newmodel = spawn( "script_model", ( 2115.51, -389.83, -303.875 ) );
	newmodel.angles = ( 0, 0, 0 );
	newmodel setmodel( "p_zom_barrel_02" );
	newmodel = spawn( "script_model", ( 2055.98, -347.018, -303.875 ) );
	newmodel.angles = ( 0, 120, 0 );
	newmodel setmodel( "p_rus_rb_lab_portable_curtain" );
	thread butcket_of_perks_revive( "t6_wpn_zmb_perk_bottle_revive_world", ( 1905, -650, -267 ), ( 0, 0, 0 ) );
	thread butcket_of_perks( "t6_wpn_zmb_perk_bottle_sleight_world", ( 1905, -632.5, -267 ), ( 0, 0, 0 ), "mus_perks_speed_sting", "Speed Cola", 3000, "specialty_fastreload" );
	thread butcket_of_perks( "t6_wpn_zmb_perk_bottle_jugg_world", ( 1905, -615, -267 ), ( 0, 0, 0 ), "mus_perks_jugganog_sting", "Jugger-Nog", 2500, "specialty_armorvest" );
	thread butcket_of_perks( "t6_wpn_zmb_perk_bottle_doubletap_world", ( 1905, -565, -267 ), ( 0, 0, 0 ), "mus_perks_doubletap_sting", "Double Tap Root Beer", 2000, "specialty_rof" );
	flag_wait( "initial_blackscreen_passed" );
	turn_power_on_and_open_doors();
	buildbuildable( "pap", 1 );
	wait 1;
	custom_pap_origin = ( 2275, -604, -303.875 );
	custom_pap_angles = ( 0, -90, 0 );
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	i = 0;
	while( i < vending_triggers.size )
	{
		trig = vending_triggers[ i];
		if( trig.script_noteworthy == "specialty_weapupgrade" && IsDefined( trig.script_noteworthy ) )
		{
			trig.machine.origin = custom_pap_origin;
			trig.machine.angles = custom_pap_angles;
			trig.clip.origin = custom_pap_origin;
			trig.clip.angles = custom_pap_angles;
			trig.bump.origin = custom_pap_origin;
			trig.bump.angles = custom_pap_angles;
		}
		i++;
	}
	vending_triggers = getentarray( "specialty_weapupgrade", "script_noteworthy" );
	vending_triggers[ 0].origin = custom_pap_origin;
	vending_triggers[ 0].angles = custom_pap_angles;

}

zone_and_spawners()
{
	stru_barrier_zombie_trigger3 = getstructarray( "pf1764_auto1", "target" );
	stru_barrier_zombie_trigger3[ 0].origin = ( 1958, -200, -270 );
	stru_barrier_zombie_trigger3[ 0].angles = ( 0, -90, 0 );
	barrier_1_trigger3 = getstructarray( "pf1764_auto1", "targetname" );
	barrier_1_trigger3[ 0].origin = ( 1958, -240, -270 );
	barrier_1_trigger3[ 0].angles = ( 0, -90, 0 );
	barrier_13 = getentarray( "pf1764_auto1", "targetname" );
	barrier_13[ 0].origin = ( 1958, -200, -270 );
	barrier_13[ 0].angles = ( 0, -90, 0 );
	move_old = getentarray( "zone_tbu", "targetname" );
	move_old[ 0].origin = ( 2011, 624, 3000.875 );
	moved = getentarray( "zone_amb_cornfield", "targetname" );
	moved[ 0].origin = ( 2011, -624, -303.875 );
	spawners = [];
	spawners[0] = ( 2220.94, -165.611, -303.875 );
	spawners[1] = ( 2181.94, -165.611, -303.875 );
	spawners[2] = ( 1778.26, -169.707, -303.875 );
	spawners[3] = ( 1750.26, -169.707, -303.875 );
	moved2 = getstructarray( "zone_amb_cornfield_spawners", "targetname" );
	i = 0;
	while( i < moved2.size )
	{
		moved2[ i].origin = spawners[ randomintrange( 0, 4 )];
		moved2[ i].script_noteworthy = "spawn_location";
		moved2[ i].script_string = "labs_baricade3";
		moved2[ i].target = "pf1764_auto1";
		i++;
	}
	for(;;)
	{
	zombie = getaiarray( level.zombie_team );
	i = 0;
	while( i < zombie.size )
	{
		if( !(zombie[ i].done)zombie[ i].done )
		{
			zombie[ i] setgoalpos( ( 1958, -200, -275 ) );
			if( distance( zombie[ i].origin, ( 1955, -275, -303.875 ) ) <= 50 )
			{
				zombie[ i].done = 1;
			}
		}
		i++;
	}
	wait 1;
	}
	wait 1;
	return;
	if(  && distance( zombie[ i].origin, ( 2011, -170, -303.875 ) ) <= 200 / UNDEFINED_LOCAL_VARIABLE thread () * _ERROR_UNDEFINED )
	{
		return 1 / 0;
	}

}

box_init()
{
	setdvar( "magic_chest_movable", "0" );
	level.zombie_weapons[ "m16_zm"].is_in_box = 1;
	level.zombie_weapons[ "870mcs_zm"].is_in_box = 1;
	level.zombie_weapons[ "rottweil72_zm"].is_in_box = 1;
	level.zombie_weapons[ "mp5k_zm"].is_in_box = 1;
	level.zombie_weapons[ "ak74u_zm"].is_in_box = 1;
	level.zombie_weapons[ "emp_grenade_zm"].is_in_box = 0;
	collision = spawn( "script_model", ( 1928, -715, -303.875 ) );
	collision.angles = ( 0, -45, 0 );
	collision setmodel( "collision_wall_256x256x10_standard" );
	new_boxes = [];
	new_boxes[5]["name"] = "start_chest";
	new_boxes[5]["origin"] = ( 1935, -745, -303.875 );
	new_boxes[5]["angles"] = ( 0, -45, 0 );
	foreach( new_box in new_boxes )
	{
		i = 0;
		while( i < level.chests.size )
		{
			if( level.chests[ i].script_noteworthy == new_box[ "name"] )
			{
				level.chests[ i].origin = new_box[ "origin"];
				level.chests[ i].angles = new_box[ "angles"];
				level.chests[ i].zbarrier.origin = new_box[ "origin"];
				level.chests[ i].zbarrier.angles = new_box[ "angles"];
				level.chests[ i].pandora_light.origin = new_box[ "origin"];
				level.chests[ i].pandora_light.angles += vector_scale( ( -1, 0, -1 ), 90 );
				level.chests[ i].unitrigger_stub.origin += anglestoright( new_box[ "angles"] ) * -22.5;
				level.chests[ i].unitrigger_stub.angles = new_box[ "angles"];
				level.chests[ i] thread show_chest();
				level.chests[ i] thread setmebackup();
				break;
			}
			else
			{
				i++;
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		box_rubble = getentarray( new_box[ "name"] + "_rubble", "script_noteworthy" );
		i = 0;
		while( i < box_rubble.size )
		{
			box_rubble[ i].origin = new_box[ "origin"];
			i++;
		}
	}

}

setmebackup()
{
	while( 1 )
	{
		self.zbarrier waittill( "closed" );
		thread register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );
	}

}

buildbuildable( buildable, craft )
{
	if( !(IsDefined( craft )) )
	{
		craft = 0;
	}
	player = get_players()[ 0];
	foreach( stub in level.buildable_stubs )
	{
		if( stub.equipname == buildable || !(IsDefined( buildable )) )
		{
			if( stub.persistent != 3 || IsDefined( buildable ) )
			{
				if( craft )
				{
					stub buildablestub_finish_build( player );
					stub buildablestub_remove();
					stub.model notsolid();
					stub.model show();
				}
				i = 0;
				foreach( piece in stub.buildablezone.pieces )
				{
					piece piece_unspawn();
					if( i > 0 && !(craft) )
					{
						stub.buildablezone buildable_set_piece_built( piece );
					}
					i++;
				}
			}
		}
	}

}

