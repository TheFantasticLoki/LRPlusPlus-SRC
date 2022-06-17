//Decompiled with SeriousHD-'s GSC Decompiler
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
init()
{
	map_location = getdvarintdefault( "CUSTOM_MAP", "none" );
	if( map_location == 2 )
	{
		if( getdvar( "g_gametype" ) == "zclassic" && getdvar( "mapname" ) == "zm_transit" )
		{
			thread checkforcurrentbox();
			add_zombie_hint( "default_shared_box", "Hold ^3&&1^7 for weapon" );
			precachemodels = array( "p6_zm_keys", "p_glo_cinder_block", "t5_foliage_tree_burnt03", "p_rus_door_white_window_plain_left", "zombie_vending_tombstone_on", "zm_collision_perks1", "p6_anim_zm_buildable_pap_on", "collision_player_wall_512x512x10", "collision_physics_512x512x10", "collision_player_wall_256x256x10", "collision_geo_256x256x10_standard", "zombie_teddybear", "zombie_z_money_icon", "collision_clip_32x32x128" );
			foreach( model in precachemodels )
			{
				precachemodel( model );
			}
			level.custom_vending_precaching = ::default_vending_precaching;
			level.player_out_of_playable_area_monitor = 0;
			level.perk_purchase_limit = 20;
			level thread onplayerconnect();
			setdvars();
			thread init_custom_map();
			level.pers_upgrades_keys = [];
			level.pers_upgrades = [];
			level thread teleport_avogadro();
			level thread entityremover();
			level thread stopbus();
			level thread pap_door();
		}
	}

}

setdvars()
{
	setdvar( "magic_chest_movable", "0" );
	setdvar( "ui_errorMessage", "^9Thank you for playing this Custom Survival Map 
^9More Mods -> https://github.com/whydoesanyonecare" );
	setdvar( "scr_screecher_ignore_player", 1 );
	setdvar( "ui_errorTitle", "^1Diner" );

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
	self waittill( "spawned_player" );
	level thread ongameendedhint( self );
	self spawnpoint();
	flag_wait( "start_zombie_round_logic" );
	wait 4;
	self iprintln( "The ^1Diner ^7- Survival" );
	wait 5;
	self iprintln( "Find and shoot teddy bears." );
	for(;;)
	{
	self waittill( "spawned_player" );
	self spawnpoint();
	if( self.score < 2500 )
	{
		self.score = 2500;
	}
	}

}

key_locations()
{
	flag_wait( "initial_blackscreen_passed" );
	locations = [];
	locations[0] = ( -5642.48, -7884.87, 35.125 );
	locations[1] = ( -5047.64, -7827.24, -25.106 );
	locations[2] = ( -6446.36, -7759.36, 20.125 );
	origin = locations[ randomintrange( 0, 3 )];
	keys_trigger = spawn( "trigger_radius", origin, 1, 25, 25 );
	keys_trigger setcursorhint( "HINT_NOICON" );
	keys_trigger sethintstring( "Press ^3&&1^7 to pick up keys" );
	keys = spawn( "script_model", origin );
	keys setmodel( "p6_zm_keys" );
	if( origin == ( -5642.48, -7884.87, 35.125 ) )
	{
		keys.angles = ( 89, 0, 0 );
	}
	else
	{
		if( origin == ( -5047.64, -7827.24, -25.106 ) )
		{
			keys.angles = ( 0, 66, -74 );
		}
		else
		{
			keys.angles = ( -91, 0, 0 );
		}
	}
	for(;;)
	{
	keys_trigger waittill( "trigger", player );
	if( player usebuttonpressed() )
	{
		player playsound( "zmb_cha_ching" );
		level.keys_found = 1;
		keys delete();
		keys_trigger delete();
		iprintln( "^1" + ( player.name + "^7 Found Keys." ) );
		break;
	}
	wait 0.1;
	}

}

pap_door()
{
	level.keys_found = 0;
	thread key_locations();
	flag_set( "power_on" );
	level setclientfield( "zombie_power_on", 1 );
	zombie_doors = getentarray( "zombie_door", "targetname" );
	foreach( door in zombie_doors )
	{
		if( door.script_noteworthy == "electric_door" && IsDefined( door.script_noteworthy ) )
		{
			door trigger_off();
		}
		else
		{
			if( door.script_noteworthy == "local_electric_door" && IsDefined( door.script_noteworthy ) )
			{
				door trigger_off();
			}
		}
	}
	flag_wait( "initial_blackscreen_passed" );
	packa_trigger = spawn( "trigger_radius", ( -3780, -7329, -58.875 ), 1, 45, 30 );
	packa_trigger setcursorhint( "HINT_NOICON" );
	for(;;)
	{
	if( !(level.keys_found) )
	{
		packa_trigger sethintstring( "Keys Required." );
	}
	else
	{
		packa_trigger sethintstring( "Press ^3&&1^7 to unlock the door." );
	}
	packa_trigger waittill( "trigger", player );
	if( level.keys_found && player usebuttonpressed() )
	{
		level.local_doors_stay_open = 1;
		level.power_local_doors_globally = 1;
		packa_trigger delete();
		break;
	}
	wait 0.1;
	}
	zombie_doors = getentarray( "zombie_door", "targetname" );
	foreach( door in zombie_doors )
	{
		if( door.script_noteworthy == "electric_door" && IsDefined( door.script_noteworthy ) )
		{
			door notify( "power_on" );
		}
		else
		{
			if( door.script_noteworthy == "local_electric_door" && IsDefined( door.script_noteworthy ) )
			{
				door notify( "local_power_on" );
			}
		}
	}

}

playchalkfx( effect, origin, angles )
{
	for(;;)
	{
	fx = spawnfx( level._effect[ effect], origin, anglestoforward( angles ), anglestoup( angles ) );
	triggerfx( fx );
	level waittill( "connected", player );
	fx delete();
	}

}

spawnpoint()
{
	player = level.players;
	if( player[ 0] == self )
	{
		player[ 0] setorigin( ( -4963.28, -7402, -62.5062 ) );
	}
	if( player[ 1] == self )
	{
		player[ 1] setorigin( ( -4993.28, -7402, -62.5062 ) );
	}
	if( player[ 2] == self )
	{
		player[ 2] setorigin( ( -4933.28, -7402, -62.5062 ) );
	}
	if( player[ 3] == self )
	{
		player[ 3] setorigin( ( -4903.28, -7402, -62.5062 ) );
	}
	if( player[ 4] == self )
	{
		player[ 4] setorigin( ( -4973.28, -7402, -62.5062 ) );
	}
	if( player[ 5] == self )
	{
		player[ 5] setorigin( ( -5024.28, -7402, -62.5062 ) );
	}
	if( player[ 6] == self )
	{
		player[ 6] setorigin( ( -5044.28, -7402, -62.5062 ) );
	}
	if( player[ 7] == self )
	{
		player[ 7] setorigin( ( -4950.28, -7402, -62.5062 ) );
	}

}

init_custom_map()
{
	flag_wait( "start_zombie_round_logic" );
	noncollision( "script_model", ( -3890.1, -6650, -59.5062 ), "collision_player_wall_512x512x10", ( 0, 270, 0 ), "wall" );
	noncollision( "script_model", ( -6315.28, -7000, -50.5062 ), "collision_player_wall_512x512x10", ( 0, 270, 0 ), "wall2" );
	noncollision( "script_model", ( -6415.28, -6850, 5.5062 ), "veh_t6_civ_movingtrk_cab_dead", ( 0, 280, 0 ), "truck" );
	noncollision( "script_model", ( -3870.1, -7050, -50.5062 ), "t5_foliage_tree_burnt03", ( -75, 270, 0 ), "tree" );
	noncollision( "script_model", ( -3885.1, -6900, -50.5062 ), "collision_player_wall_512x512x10", ( 0, 270, 0 ), "wall3" );
	perk_system( "script_model", ( -3810.1, -7220, -59.5062 ), "zombie_vending_tombstone_on", ( 0, 270, 0 ), "original", "mus_perks_tombstone_sting", "Tombstone", 2000, "tombstone_light", "specialty_scavenger" );
	perk_system( "script_model", ( -4590.28, -7539, -62.5062 ), "zombie_vending_jugg_on", ( 0, 270, 0 ), "original", "mus_perks_jugganog_sting", "Jugger-Nog", 2500, "jugger_light", "specialty_armorvest" );
	perk_system( "script_model", ( -4173.1, -7750.29, -62.5062 ), "zombie_vending_doubletap2_on", ( 0, 270, 0 ), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 2000, "doubletap_light", "specialty_rof" );
	perk_system( "script_model", ( -6500.28, -7930, 0.5062 ), "zombie_vending_marathon_on", ( 0, 90, 0 ), "original", "mus_perks_stamin_sting", "Stamin-Up", 2000, "marathon_light", "specialty_longersprint" );
	perk_system( "script_model", ( -3545.1, -7220, -59.5062 ), "p6_anim_zm_buildable_pap_on", ( 0, 315, 0 ), "pap", "zmb_perks_packa_upgrade", "Pack-A-Punch", 5000 );
	perk_system( "script_model", ( -5050.28, -7788, -62.5062 ), "zombie_vending_revive_on", ( 0, 180, 0 ), "revive" );
	level._effect["wall_claymore"] = loadfx( "maps/zombie/fx_zmb_wall_buy_claymore" );
	level._effect["wall_m14"] = loadfx( "maps/zombie/fx_zmb_wall_buy_m14" );
	thread wallweaponmonitorbox( ( -5150.28, -7808, -20.162 ), ( 90, 95, 0 ), "claymore_zm", 1500 );
	thread wallweaponmonitorbox( ( -5438.5, -7781, -30.002 ), ( 0, 270, 0 ), "m14_zm", 500, 250 );
	thread playchalkfx( "wall_claymore", ( -5150.28, -7808, -24.892 ), ( 0, 0, 0 ) );
	thread playchalkfx( "wall_m14", ( -5439.01, -7781, -30.5062 ), ( 0, 270, 0 ) );
	shootable( ( -4690.28, -7282, -63.5062 ), ( 0, 180, 0 ) );
	shootable( ( -5305.28, -6550, -35.5062 ), ( 0, -35, 0 ) );
	shootable( ( -5371.28, -7379, 300 ), ( 0, 80, 0 ) );
	shootable( ( -4180.28, -7904, -12 ), ( 0, 180, 0 ) );
	shootable( ( -6248.28, -7748, 148 ), ( 0, 0, 0 ) );
	shootable( ( -5582.28, -5334, 79.125 ), ( 0, 20, 0 ) );
	shootable( ( -4268.28, -6250, -41.1398 ), ( 0, 90, 0 ) );
	shootable( ( -3732.28, -7473, -58.875 ), ( 0, 60, 0 ) );
	shootable( ( -6338.28, -7590, 221.915 ), ( 0, 60, 0 ) );
	shootable( ( -3810.28, -7443, 98.915 ), ( 0, 180, 0 ) );

}

perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk )
{
	col = spawn( script, pos );
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
	if( type != "revive" )
	{
		col thread buy_system( perk, sound, name, cost, type );
	}
	if( type != "revive" && type != "pap" )
	{
		col thread play_fx( fx );
	}
	if( type == "revive" )
	{
		col thread perksquickr();
		col thread play_fx( "revive_light" );
	}

}

buy_system( perk, sound, name, cost, type )
{
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(player.machine_is_in_use) )
			{
				if( distance( self.origin, player.origin ) <= 70 )
				{
					player thread spawnhint( self.origin, 35, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + ( name + ( " [Cost: " + ( cost + "]" ) ) ) );
					if( !(player player_is_in_laststand())player player_is_in_laststand() && player.score >= cost && !(player hasperk( perk ))player hasperk( perk ) )
					{
						player.machine_is_in_use = 1;
						player playsound( "zmb_cha_ching" );
						player.score = player.score - cost;
						player playsound( sound );
						player thread dogiveperk( perk );
						wait 3;
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
						player giveweapon( player get_upgrade_weapon( currgun, 0 ), 0, player custom_get_pack_a_punch_weapon_options( gun ) );
						player switchtoweapon( gun );
						playfx( loadfx( "maps/zombie/fx_zombie_packapunch" ), ( -3545.1, -7220, -48.5062 ), anglestoforward( ( 0, 45, 55 ) ) );
						wait 3;
						player.machine_is_in_use = 0;
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

perksquickr()
{
	level.solo_revives = 0;
	level.max_solo_revives = 3;
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( !(player.machine_is_in_use) )
			{
				if( distance( self.origin, player.origin ) <= 60 )
				{
					if( get_players().size > 1 )
					{
						player thread spawnhint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 1500]" );
						level.solo_revives = 0;
					}
					else
					{
						player thread spawnhint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for Revive [Cost: 500]" );
					}
					if( !(player player_is_in_laststand())player player_is_in_laststand() && !(level.solo_revives >= level.max_solo_revives)level.solo_revives >= level.max_solo_revives )
					{
						if( player.score >= 1500 && get_players().size > 1 || player.score >= 500 && get_players().size == 1 )
						{
							player.machine_is_in_use = 1;
							if( get_players().size > 1 )
							{
								player.score = player.score - 1500;
							}
							if( get_players().size == 1 )
							{
								level.solo_revives++;
								player.score = player.score - 500;
							}
							player playsound( "zmb_cha_ching" );
							player playsound( "mus_perks_revive_sting" );
							player thread dogiveperk( "specialty_quickrevive" );
							wait 4;
							player.machine_is_in_use = 0;
						}
						else
						{
							if( player.score < 500 && get_players().size == 1 )
							{
								player create_and_play_dialog( "general", "perk_deny", undefined, 0 );
							}
							if( player.score < 1500 && get_players().size > 1 )
							{
								player create_and_play_dialog( "general", "perk_deny", undefined, 0 );
							}
						}
					}
				}
			}
		}
		wait 0.01;
	}

}

play_fx( fx )
{
	playfxontag( level._effect[ fx], self, "tag_origin" );

}

noncollision( script, pos, model, angles, type )
{
	noncol = spawn( "script_model", pos );
	noncol setmodel( model );
	noncol.angles = angles;

}

default_vending_precaching()
{
	level._effect["sleight_light"] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect["tombstone_light"] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect["revive_light"] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect["marathon_light"] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
	level._effect["jugger_light"] = loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect["doubletap_light"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect["Pack_a_Punch"] = loadfx( "maps/zombie/fx_zombie_packapunch" );

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

custom_get_pack_a_punch_weapon_options( weapon )
{
	if( !(IsDefined( self.pack_a_punch_weapon_options )) )
	{
		self.pack_a_punch_weapon_options = [];
	}
	if( !(is_weapon_upgraded( weapon )) )
	{
		return self calcweaponoptions( 0, 0, 0, 0, 0 );
	}
	if( IsDefined( self.pack_a_punch_weapon_options[ weapon] ) )
	{
		return self.pack_a_punch_weapon_options[ weapon];
	}
	smiley_face_reticle_index = 1;
	base = get_base_name( weapon );
	if( weapon == "knife_ballistic_zm" || base == "knife_ballistic_upgraded_zm" || weapon == "m1911_zm" || base == "m1911_upgraded_zm" || weapon == "raygun_mark2_zm" || base == "raygun_mark2_upgraded_zm" || weapon == "ray_gun_zm" || base == "ray_gun_upgraded_zm" || weapon == "m32_zm" || base == "m32_upgraded_zm" || weapon == "fiveseven_zm" || base == "fiveseven_upgraded_zm" || weapon == "fivesevendw_zm" || base == "fivesevendw_upgraded_zm" || weapon == "qcw05_zm" || base == "qcw05_upgraded_zm" || weapon == "m16_upgraded_zm" || base == "m16_zm" )
	{
		camo_index = 39;
	}
	else
	{
		camo_index = 44;
	}
	lens_index = randomintrange( 0, 6 );
	reticle_index = randomintrange( 0, 16 );
	reticle_color_index = randomintrange( 0, 6 );
	plain_reticle_index = 16;
	r = randomint( 10 );
	use_plain = r < 3;
	if( base == "saritch_upgraded_zm" )
	{
		reticle_index = smiley_face_reticle_index;
	}
	else
	{
		if( use_plain )
		{
			reticle_index = plain_reticle_index;
		}
	}
	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;
	if( reticle_index == scary_eyes_reticle_index )
	{
		reticle_color_index = purple_reticle_color_index;
	}
	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;
	if( reticle_index == letter_a_reticle_index )
	{
		reticle_color_index = pink_reticle_color_index;
	}
	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;
	if( reticle_index == letter_e_reticle_index )
	{
		reticle_color_index = green_reticle_color_index;
	}
	self.pack_a_punch_weapon_options[weapon] = self calcweaponoptions( camo_index, lens_index, reticle_index, reticle_color_index );
	return self.pack_a_punch_weapon_options[ weapon];

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

ongameendedhint( player )
{
	level waittill( "end_game" );
	hud = player createfontstring( "objective", 2 );
	hud settext( "Thank you for playing." );
	hud.x = 0;
	hud.y = 0;
	UNDEFINED_LOCAL.alignx = "center";
	UNDEFINED_LOCAL.aligny = "center";
	UNDEFINED_LOCAL.horzalign = "fullscreen";
	UNDEFINED_LOCAL.vertalign = "fullscreen";
	hud.color = ( 1, 1, 1 );
	hud.alpha = 1;
	hud.glowcolor = ( 1, 1, 1 );
	hud.glowalpha = 0;
	hud.sort = 5;
	hud.archived = 0;
	hud.foreground = 1;

}

box_init()
{
	if( !(IsDefined( level.roof_open )) )
	{
		level.roof_open = 0;
	}
	setdvar( "magic_chest_movable", "0" );
	level.zombie_weapons[ "m16_zm"].is_in_box = 1;
	level.zombie_weapons[ "870mcs_zm"].is_in_box = 1;
	level.zombie_weapons[ "rottweil72_zm"].is_in_box = 1;
	level.zombie_weapons[ "emp_grenade_zm"].is_in_box = 0;
	collision = spawn( "script_model", ( -5708, -7968, 232 ) );
	collision.angles = ( 0, 0, 0 );
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", ( -5708, -7968, 232 ) - ( 32, 0, 0 ) );
	collision.angles = ( 0, 0, 0 );
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", ( -5708, -7968, 232 ) + ( 32, 0, 0 ) );
	collision.angles = ( 0, 0, 0 );
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	brick1 = spawn( "script_model", ( -5708, -7968, 230 ) + ( 32, 0, 0 ) );
	brick1.angles = ( 0, 280, 0 );
	brick1 setmodel( "p_glo_cinder_block" );
	brick2 = spawn( "script_model", ( -5708, -7968, 230 ) + ( 10, 0, 0 ) );
	brick2.angles = ( 0, 120, 0 );
	brick2 setmodel( "p_glo_cinder_block" );
	brick3 = spawn( "script_model", ( -5708, -7968, 230 ) - ( 11, 0, 0 ) );
	brick3.angles = ( 0, 80, 0 );
	brick3 setmodel( "p_glo_cinder_block" );
	brick4 = spawn( "script_model", ( -5708, -7968, 230 ) - ( 32, 0, 0 ) );
	brick4.angles = ( 0, 120, 0 );
	brick4 setmodel( "p_glo_cinder_block" );
	new_boxes = [];
	new_boxes[5]["name"] = "depot_chest";
	new_boxes[5]["origin"] = ( -5708, -7968, 234 );
	new_boxes[5]["angles"] = ( 0, 0, 0 );
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
				while( !(level.roof_open) )
				{
					wait 1;
				}
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

checkforcurrentbox()
{
	flag_wait( "initial_blackscreen_passed" );
	thread box_init();
	wait 1;
	if( !(IsDefined( level.shared_box )) )
	{
		level.shared_box = 0;
	}
	i = 0;
	while( i < level.chests.size )
	{
		level.chests[ i] thread reset_box();
		if( level.chests[ i].hidden )
		{
			level.chests[ i] get_chest_pieces();
		}
		if( !(level.chests[ i].hidden) )
		{
			level.chests[ i].unitrigger_stub.prompt_and_visibility_func = ::boxtrigger_update_prompt;
		}
		i++;
	}

}

reset_box()
{
	self notify( "kill_chest_think" );
	wait 0.1;
	if( !(self.hidden) )
	{
		self.grab_weapon_hint = 0;
		self thread register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );
		self.unitrigger_stub run_visibility_function_for_all_triggers();
	}
	if( self.script_noteworthy == "depot_chest" )
	{
		self thread upgrade_treasure_chest_think();
	}
	else
	{
		self thread custom_treasure_chest_think();
	}

}

get_chest_pieces()
{
	self.chest_box = getent( self.script_noteworthy + "_zbarrier", "script_noteworthy" );
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
	self.unitrigger_stub.origin += anglestoright( self.angles ) * -22.5;
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.script_width = 104;
	self.unitrigger_stub.script_height = 50;
	self.unitrigger_stub.script_length = 45;
	self.unitrigger_stub.trigger_target = self;
	unitrigger_force_per_player_triggers( self.unitrigger_stub, 1 );
	self.unitrigger_stub.prompt_and_visibility_func = ::boxtrigger_update_prompt;
	self.zbarrier.owner = self;

}

boxtrigger_update_prompt( player )
{
	can_use = self custom_boxstub_update_prompt( player );
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

custom_boxstub_update_prompt( player )
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

custom_treasure_chest_think()
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
			if( distance( self.origin, user.origin ) <= 100 && isplayer( user ) && user meleebuttonpressed() )
			{
				fx_obj = spawn( "script_model", self.origin + ( 0, 0, 35 ) );
				fx_obj setmodel( "tag_origin" );
				fx = playfxontag( level._effect[ "maxis_sparks"], fx_obj, "tag_origin" );
				level.magic_box_grab_by_anyone = 1;
				level.shared_box = 1;
				self.unitrigger_stub run_visibility_function_for_all_triggers();
				a = i;
				while( a < 105 )
				{
					foreach( player in level.players )
					{
						if( !(player.is_drinking)player.is_drinking && IsDefined( player.is_drinking ) && distance( self.origin, player.origin ) <= 100 )
						{
							player thread treasure_chest_give_weapon( self.zbarrier.weapon_string );
							a = 105;
							break;
						}
						else
						{
							_k811 = GetNextArrayKey( _a811, _k811 );
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
				if( !(grabber.is_drinking)grabber.is_drinking && IsDefined( grabber.is_drinking ) && distance( self.origin, grabber.origin ) <= 100 && user == grabber && isplayer( grabber ) )
				{
					grabber thread treasure_chest_give_weapon( self.zbarrier.weapon_string );
					break;
				}
				wait 0.1;
				i++;
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		fx_obj delete();
		fx delete();
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
	self thread custom_treasure_chest_think();

}

upgrade_treasure_chest_think()
{
	self endon( "kill_chest_think" );
	user = undefined;
	user_cost = undefined;
	self.box_rerespun = undefined;
	self.weapon_out = undefined;
	self.zombie_cost = 2500;
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
	fx_obj = spawn( "script_model", ( -5708, -7968, 232 ) + ( 0, 0, 35 ) );
	fx_obj setmodel( "tag_origin" );
	fx = playfxontag( level._effect[ "richtofen_sparks"], fx_obj, "tag_origin" );
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
			if( distance( self.origin, user.origin ) <= 100 && isplayer( user ) && user meleebuttonpressed() )
			{
				fx_obj2 = spawn( "script_model", ( -5708, -7968, 232 ) + ( 0, 0, 35 ) );
				fx_obj2 setmodel( "tag_origin" );
				fx2 = playfxontag( level._effect[ "maxis_sparks"], fx_obj2, "tag_origin" );
				level.magic_box_grab_by_anyone = 1;
				level.shared_box = 1;
				self.unitrigger_stub run_visibility_function_for_all_triggers();
				a = i;
				while( a < 105 )
				{
					foreach( player in level.players )
					{
						if( !(player.is_drinking)player.is_drinking && IsDefined( player.is_drinking ) && distance( self.origin, player.origin ) <= 100 )
						{
							if( !(can_upgrade_weapon( self.zbarrier.weapon_string )) )
							{
								player weapon_give( self.zbarrier.weapon_string, 0 );
							}
							else
							{
								player weapon_give( player get_upgrade_weapon( self.zbarrier.weapon_string, 0 ), 0 );
							}
							a = 105;
							break;
						}
						else
						{
							_k529 = GetNextArrayKey( _a529, _k529 );
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
				if( !(grabber.is_drinking)grabber.is_drinking && IsDefined( grabber.is_drinking ) && distance( self.origin, grabber.origin ) <= 100 && user == grabber && isplayer( grabber ) )
				{
					if( !(can_upgrade_weapon( self.zbarrier.weapon_string )) )
					{
						grabber weapon_give( self.zbarrier.weapon_string, 0 );
					}
					else
					{
						grabber weapon_give( grabber get_upgrade_weapon( self.zbarrier.weapon_string, 0 ), 0 );
					}
					break;
				}
				wait 0.1;
				i++;
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		fx_obj delete();
		fx delete();
		fx_obj2 delete();
		fx2 delete();
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
	self thread upgrade_treasure_chest_think();

}

stopbus()
{
	flag_wait( "initial_blackscreen_passed" );
	level endon( "end_game" );
	while( 1 )
	{
		bus = getent( "the_bus", "targetname" );
		if( IsDefined( bus ) && IsDefined( level.the_bus.ismoving ) )
		{
			bus.disabled_by_emp = 1;
			bus notify( "power_off" );
			bus.pre_disabled_by_emp = 1;
			bus notify( "pre_power_off" );
			bus.ismoving = 0;
			bus.isstopping = 0;
			bus.exceed_chase_speed = 0;
			bus notify( "stopping" );
			bus.targetspeed = 0;
		}
		wait 2;
	}

}

entityremover()
{
	flag_wait( "start_zombie_round_logic" );
	wait 5;
	removebuildable( "dinerhatch" );
	removebuildable( "cattlecatcher" );

}

removebuildable( buildable )
{
	foreach( stub in level.buildable_stubs )
	{
		if( stub.equipname == buildable )
		{
			foreach( piece in stub.buildablezone.pieces )
			{
				piece piece_unspawn();
			}
		}
	}

}

teleport_avogadro()
{
	flag_wait( "initial_blackscreen_passed" );
	foreach( zombie in getaiarray( level.zombie_team ) )
	{
		if( zombie.is_avogadro && IsDefined( zombie.is_avogadro ) )
		{
			zombie delete();
			break;
		}
		else
		{
			_k724 = GetNextArrayKey( _a724, _k724 );
			?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
	}
	wait 0.3;
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

wallweaponmonitorbox( origin, angles, weapon, cost, ammo )
{
	trigger = spawn( "trigger_radius", origin, 0, 35, 80 );
	trigger setcursorhint( "HINT_NOICON" );
	if( weapon == "semtex_bag" )
	{
		name = "frag grenade";
		trigger sethintstring( "Hold ^3&&1^7 to buy " + ( name + ( " [Cost: " + ( cost + "]" ) ) ) );
	}
	else
	{
		if( weapon == "claymore_zm" )
		{
			name = get_weapon_display_name( weapon );
			trigger sethintstring( "Hold ^3&&1^7 to buy " + ( name + ( " [Cost: " + ( cost + "]" ) ) ) );
		}
		else
		{
			name = get_weapon_display_name( weapon );
			if( !(level.legacy) )
			{
				trigger sethintstring( "Hold ^3&&1^7 to buy " + ( name + ( " [Cost: " + ( cost + ( "] Ammo [Cost: " + ( ammo + "] Upgraded Ammo [Cost: 4500]" ) ) ) ) ) );
			}
			else
			{
				trigger sethintstring( "Hold ^3&&1^7 to buy " + ( name + ( " [Cost: " + ( cost + ( "] Ammo [Cost: " + ( ammo + "]" ) ) ) ) ) );
			}
		}
	}
	trigger waittill( "trigger", player );
	if( player can_buy() && player.score >= cost && player usebuttonpressed() )
	{
		grenades = player getweaponammoclip( player get_player_lethal_grenade() );
		if( weapon == "semtex_bag" )
		{
			if( grenades == 4 )
			{
				wait 1;
				continue;
			}
			player.score = player.score - cost;
			player thread weapon_give( "frag_grenade_zm", 0, 1 );
			player playsound( "zmb_cha_ching" );
			if( !(IsDefined( frag_model )) )
			{
				play_sound_at_pos( "weapon_show", origin, player );
				frag_model = spawn( "script_model", origin );
				frag_model.angles = angles;
				frag_model setmodel( weapon );
			}
			wait 2;
			continue;
		}
		if( !(player has_weapon_or_upgrade( weapon )) )
		{
			player.score = player.score - cost;
			player thread weapon_give( weapon, 0, 1 );
			if( !(IsDefined( model )) )
			{
				if( weapon == "ak74u_zm" )
				{
					mag = spawn( "script_model", ( 13663, -1176, -136 ) );
					mag.angles = ( -5, -90, 0 );
					mag setmodel( "t6_attach_mag_galil_world" );
				}
				play_sound_at_pos( "weapon_show", origin, player );
				model = spawn( "script_model", origin );
				model.angles = angles;
				model setmodel( getweaponmodel( weapon ) );
			}
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
	else
	{
		if( player.score < cost && !(player hasweapon( weapon ))player hasweapon( weapon ) )
		{
			player create_and_play_dialog( "general", "no_money_weapon" );
		}
	}
	wait 0.1;
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

weapon_change( weapon, flourish )
{
	self.flourish = 1;
	weap = self getcurrentweapon();
	self thread weapon_give( flourish, 0, 1 );
	self waittill( "weapon_change_complete" );
	self takeweapon( flourish );
	self switchtoweapon( weap );
	self giveweapon( weapon );
	self.flourish = 0;

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

shootable( origin, angles )
{
	shotable = spawn( "script_model", origin );
	shotable setmodel( "zombie_teddybear" );
	shotable.angles = angles;
	shotable.health = 5;
	shotable setcandamage( 1 );
	shotable thread teddys();

}

teddys()
{
	self endon( "shot" );
	level.teddysneeded = 10;
	level.teddyscollected = 0;
	while( 1 )
	{
		self waittill( "damage", idamage, attacker, idflags, vpoint, type, victim, vdir, shitloc, psoffsettime, sweapon );
		if( self.health <= 0 )
		{
			level.teddyscollected++;
			iprintlnbold( "Teddys Shot [" + ( level.teddyscollected + "/10]" ) );
			self delete();
			if( level.teddyscollected >= level.teddysneeded )
			{
				self thread leaderdialog( "boxmove" );
				wait 2;
				iprintlnbold( "^2Rooftop Opened" );
				buildbuildable( "dinerhatch", 1 );
				level.roof_open = 1;
				break;
			}
			else
			{
				self notify( "shot" );
				wait 0.1;
				?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
			}
		}
		wait 0.1;
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
	return;
	_k83 = GetNextArrayKey( _a83, _k83 );
	?;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.

}

