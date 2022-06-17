#include common_scripts\utility;
#include codescripts\character;
#include maps\mp\_utility;
#include maps\mp\zm_transit_buildables;
#include maps\mp\zm_transit;
#include maps\mp\zm_transit_lava;
#include maps\mp\_createfx;
#include maps\mp\_music;
#include maps\mp\_busing;
#include maps\mp\_script_gen;
#include maps\mp\_challenges;
#include maps\mp\_demo;
#include maps\mp\_visionset_mgr;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\zm_run;
#include maps\mp\animscripts\zm_death;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_tweakables;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_load;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_server_throttle;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_ai_dogs;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_ai_avogadro;

//#namespace forest;

/*
	Name: main
	Namespace: forest
	Checksum: 0x18CFCC0C
	Offset: 0x498B
	Size: 0x42
	Parameters: 0
	Flags: None
*/
main()
{
	load_map = getdvarintdefault("CUSTOM_MAP", "none");
	if(load_map == 4)
	{
		if(GetDvar("mapname") == "zm_transit" && GetDvar("g_gametype") == "zclassic")
		{
			level thread shield();
		}
	}
}

/*
	Name: init
	Namespace: forest
	Checksum: 0xDAF7CBDE
	Offset: 0x49CE
	Size: 0x4C7
	Parameters: 0
	Flags: None
*/
init()
{
	load_map = getdvarintdefault("CUSTOM_MAP", "none");
	if(load_map == 4)
	{
		if(GetDvar("mapname") == "zm_transit" && GetDvar("g_gametype") == "zclassic")
		{
			level.new_spawn_points = array((5250.08, 6876.83, -20.6077), (5220.08, 6836.83, -20.6077), (5210.08, 6856.83, -20.6077), (5270.08, 6896.83, -20.6077), (5225.08, 6835.83, -20.6077), (5200.08, 6830.83, -20.6077), (5215.08, 6876.83, -20.6077), (5230.08, 6856.83, -20.6077), (5346.28, 7019.57, -26.875), (5332.35, 6718.73, -24.8255), (5086.15, 6715.41, -24.1262), (5083.88, 7035.36, -24.875));
			new_spawn_points();
			precacheshaders = array("hud_icon_sticky_grenade", "specialty_doubletap_zombies", "killiconheadshot", "specialty_additionalprimaryweapon_zombies", "menu_mp_lobby_icon_customgamemode", "specialty_divetonuke_zombies", "zombies_rank_1", "zombies_rank_3", "zombies_rank_2", "zombies_rank_4", "zombies_rank_5", "menu_lobby_icon_facebook", "menu_mp_weapons_1911", "hud_icon_colt", "waypoint_revive", "hud_grenadeicon", "damage_feedback", "menu_lobby_icon_twitter", "specialty_doubletap_zombies");
			foreach(shader in precacheshaders)
			{
				precacheshader(shader);
			}
			precachemodel("zombie_vending_jugg_on");
			level._effect["doubletap_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
			level.effect_webfx = loadfx("misc/fx_zombie_powerup_solo_grab");
			level.zombie_last_stand = &laststand;
			register_player_damage_callback(&damage_callback);
			level.get_player_weapon_limit = &custom_get_player_weapon_limit;
			level.openeddoor = 0;
			level.start_weapon = "kard_zm";
			level.custom_pap_validation = thread new_pap_trigger();
			level._poi_override = &turned_zombie;
			include_zombie_powerup("zombie_cash");
			add_zombie_powerup("zombie_cash", "zombie_z_money_icon", &"ZOMBIE_POWERUP_ZOMBIE_CASH", &func_should_always_drop, 1, 0, 0);
			powerup_set_can_pick_up_in_last_stand("zombie_cash", 1);
			include_zombie_powerup("random_perk");
			add_zombie_powerup("random_perk", "t6_wpn_zmb_perk_bottle_sleight_world", &"ZOMBIE_POWERUP_RANDOM_PERK", &func_should_always_drop, 0, 0, 0);
			powerup_set_can_pick_up_in_last_stand("random_perk", 0);
			precachemodels = array("p6_table_bunker_sm", "p_jun_woodbarrel_single", "afr_barrel_biohazard_white_rust", "p6_zm_rocks_small_cluster_01", "zm_collision_perks1", "p6_anim_zm_buildable_pap_on", "collision_wall_512x512x10_standard", "collision_player_wall_512x512x10", "t5_foliage_tree_burnt03", "veh_t6_civ_bus_zombie", "t6_wpn_zmb_perk_bottle_revive_view", "zombie_z_money_icon", "pb_pole_telephone_bulb", "p_glo_street_light02", "p_glo_street_light02_on_light", "p_glo_street_light01_fx_shell", "t6_wpn_zmb_perk_bottle_marathon_world", "t6_wpn_zmb_perk_bottle_sleight_world", "t6_wpn_zmb_perk_bottle_jugg_world", "t6_wpn_zmb_perk_bottle_doubletap_world", "p_zom_clock_hourhand", "veh_t6_civ_60s_coupe_dead", "c_zom_player_zombie_fb", "p6_anim_zm_buildable_turbine", "veh_t6_civ_microbus_dead");
			foreach(model in precachemodels)
			{
				precachemodel(model);
			}
			precacheshader("damage_feedback");
			precacheshader("hud_status_dead");
			thread box_init((5387, 6594, -21.5));
			init_custom_map();
			level setdvars();
			level.custom_vending_precaching = &default_vending_precaching;
			level._effect["jetgun_smoke_cloud"] = loadfx("weapon/thunder_gun/fx_thundergun_smoke_cloud");
			register_zombie_death_event_callback(&custom_death_callback);
			if(isdefined(level._zombiemode_powerup_grab))
			{
				level.original_zombiemode_powerup_grab = level._zombiemode_powerup_grab;
			}
			level._zombiemode_powerup_grab = &custom_powerup_grab;
			level.player_out_of_playable_area_monitor = 0;
			level.perk_purchase_limit = 20;
			level thread barriers_and_spawners();
			level thread move_spawn_locations();
			level thread drawzombiescounter();
			level thread onplayerconnect();
			level thread zombie_speed();
			flag_wait("initial_blackscreen_passed");
			wunderfizzsetup((5022.8, 6592.9, 0), (0, 90, 0));
			level.pers_upgrades_keys = [];
			level.pers_upgrades = [];
			level.original_damagecallback = level.callbackactordamage;
			level.callbackactordamage = &actor_damage_override_wrapper;
			level thread delete_bus_pieces();
		}
	}
}

/*
	Name: new_spawn_points
	Namespace: forest
	Checksum: 0xCD3040BB
	Offset: 0x4E96
	Size: 0x136
	Parameters: 0
	Flags: None
*/
new_spawn_points()
{
	structs = getstructarray("initial_spawn", "script_noteworthy");
	for(i = 0; i < structs.size; i++)
	{
		structs[i].origin = (5250.08, 6876.83, -20.6077);
		structs[i].target = "pf1801_auto2385";
	}
	spawn = getstructarray("initial_spawn_points", "targetname");
	for(i = 0; i < spawn.size; i++)
	{
		spawn[i].origin = level.new_spawn_points[i];
		spawn[i].angles =  0, 0, 0;
	}
	structs = getstructarray("player_respawn_point", "targetname");
	for(i = 0; i < structs.size; i++)
	{
		structs[i].origin = (5250.08, 6876.83, -20.6077);
		structs[i].target = "pf1801_auto2385";
	}
	targetforrespawn = getstructarray("pf1801_auto2385", "targetname");
	for(i = 0; i < targetforrespawn.size; i++)
	{
		targetforrespawn[i].origin = level.new_spawn_points[i];
	}
}

/*
	Name: delete_bus_pieces
	Namespace: forest
	Checksum: 0xC5B5D96
	Offset: 0x4FCE
	Size: 0x2A2
	Parameters: 0
	Flags: None
*/
delete_bus_pieces()
{
	level endon("end_game");
	wait(3);
	if(isdefined(level._bus_pieces_deleted) && level._bus_pieces_deleted)
	{
		return;
	}
	level._bus_pieces_deleted = 1;
	hatch_mantle = getent("hatch_mantle", "targetname");
	if(isdefined(hatch_mantle))
	{
		hatch_mantle delete();
	}
	hatch_clip = getentarray("hatch_clip", "targetname");
	array_thread(hatch_clip, &self_delete);
	plow_clip = getentarray("plow_clip", "targetname");
	array_thread(plow_clip, &self_delete);
	light = getent("busLight2", "targetname");
	if(isdefined(light))
	{
		light delete();
	}
	light = getent("busLight1", "targetname");
	if(isdefined(light))
	{
		light delete();
	}
	blocker = getent("bus_path_blocker", "targetname");
	if(isdefined(blocker))
	{
		blocker delete();
	}
	lights = getentarray("bus_break_lights", "targetname");
	array_thread(lights, &self_delete);
	orgs = getentarray("bus_bounds_origin", "targetname");
	array_thread(orgs, &self_delete);
	door_blocker = getentarray("bus_door_blocker", "targetname");
	array_thread(door_blocker, &self_delete);
	driver = getent("bus_driver_head", "targetname");
	if(isdefined(driver))
	{
		driver delete();
	}
	plow = getent("trigger_plow", "targetname");
	if(isdefined(plow))
	{
		plow delete();
	}
	plow_attach_point = getent("plow_attach_point", "targetname");
	if(isdefined(plow_attach_point))
	{
		plow_attach_point delete();
	}
	bus = getent("the_bus", "targetname");
	if(isdefined(bus))
	{
		bus delete();
	}
	barriers = getzbarrierarray();
	foreach(barrier in barriers)
	{
		if(isdefined(barrier.classname) && issubstr(barrier.classname, "zb_bus"))
		{
			for(x = 0; x < barrier getnumzbarrierpieces(); x++)
			{
				barrier setzbarrierpiecestate(x, "opening");
			}
			barrier hide();
		}
	}
}

/*
	Name: damage_callback
	Namespace: forest
	Checksum: 0xFEDB8633
	Offset: 0x5272
	Size: 0x242
	Parameters: 11
	Flags: None
*/
damage_callback(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if(self hascustomperk("WIDOWS_WINE"))
	{
		if(isdefined(eattacker.is_zombie) && eattacker.is_zombie)
		{
			grenades = self get_player_lethal_grenade();
			grenade_count = self getweaponammoclip(grenades);
			if(grenade_count > 0)
			{
				self setweaponammoclip(grenades, grenade_count - 1);
				foreach(zombie in getaiarray(level.zombie_team))
				{
					if(distance(zombie.origin, self.origin) < 150)
					{
						zombie thread ww_points(self);
						self playsound("zmb_elec_jib_zombie");
					}
				}
			}
		}
	}
	else if(self hascustomperk("PHD_FLOPPER"))
	{
		if(smeansofdeath == "MOD_FALLING")
		{
			if(isdefined(self.divetoprone) && self.divetoprone == 1)
			{
				radiusdamage(self.origin, 300, 5000, 1000, self, "MOD_GRENADE_SPLASH");
				playfx(loadfx("explosions/fx_default_explosion"), self.origin, AnglesToForward((0, 45, 55)));
				self playsound("zmb_phdflop_explo");
			}
			return 0;
		}
		if(smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" || (eattacker == self && !smeansofdeath == "MOD_UNKNOWN"))
		{
			return 0;
		}
	}
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].firework_weapon) && eattacker == players[i].firework_weapon)
		{
			return 0;
		}
	}
	if(isdefined(self.has_cluster) && self.has_cluster && (isdefined(eattacker) && eattacker == self))
	{
		return 0;
	}
	if(idamage > self.health && !self.dying_wish_on_cooldown && self hascustomperk("Dying_Wish"))
	{
		self notify("dying_wish_charge");
		self thread dying_wish_effect();
		return 0;
	}
	if(isdefined(level.first_player_damage_callback))
	{
		return [[level.first_player_damage_callback]](einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
	}
	return idamage;
}

/*
	Name: custom_get_player_weapon_limit
	Namespace: forest
	Checksum: 0xC6603999
	Offset: 0x54B6
	Size: 0x4E
	Parameters: 1
	Flags: None
*/
custom_get_player_weapon_limit(player)
{
	weapon_limit = 2;
	if(player hascustomperk("MULE"))
	{
		weapon_limit = 3;
	}
	else
	{
		weapons = self getweaponslistprimaries();
		if(weapons.size > weapon_limit)
		{
			self takeweapon(weapons[2]);
		}
	}
	return weapon_limit;
}

/*
	Name: zombie_speed
	Namespace: forest
	Checksum: 0xC2866E23
	Offset: 0x5506
	Size: 0x72
	Parameters: 0
	Flags: None
*/
zombie_speed()
{
	level endon("end_game");
	while(level.round_number < 3)
	{
		foreach(zombie in getaiarray(level.zombie_team))
		{
			if(!isdefined(zombie.run_set))
			{
				zombie maps\mp\zombies\_zm_utility::set_zombie_run_cycle("run");
				zombie.run_set = 1;
			}
		}
		wait(1);
	}
}

/*
	Name: move_spawn_locations
	Namespace: forest
	Checksum: 0xEEC74429
	Offset: 0x557A
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
move_spawn_locations()
{
	flag_wait("initial_blackscreen_passed");
	level.zombie_spawn_locations[2].origin = (3848, 5520, -63);
	level.zombie_spawn_locations[14].origin = (4667, 6280, -72);
	level.zombie_spawn_locations[15].origin = (3708, 6098, -63);
	level.zombie_spawn_locations[16].origin = (4766, 5421, -86);
	level.zombie_spawn_locations[17].origin = (3848, 5520, -63);
	level.zombie_spawn_locations[18].origin = (4766, 5421, -86);
	level.zombie_spawn_locations[19].origin = (3848, 5520, -63);
}

/*
	Name: night_mode
	Namespace: forest
	Checksum: 0x11562BBC
	Offset: 0x5632
	Size: 0x16D
	Parameters: 0
	Flags: None
*/
night_mode()
{
	level waittill("connected", player);
	player setclientdvar("r_dof_enable", 0);
	player setclientdvar("r_lodBiasRigid", -1000);
	player setclientdvar("r_lodBiasSkinned", -1000);
	player setclientdvar("r_enablePlayerShadow", 1);
	player setclientdvar("r_skyTransition", 1);
	player setclientdvar("sm_sunquality", 2);
	player setclientdvar("vc_fbm", "0 0 0 0");
	player setclientdvar("vc_fsm", "1 1 1 1");
	player setclientdvar("r_filmUseTweaks", 1);
	player setclientdvar("r_bloomTweaks", 1);
	player setclientdvar("r_exposureTweak", 1);
	player setclientdvar("vc_rgbh", "0.1 0 0.3 0");
	player setclientdvar("vc_yl", "0 0 0.25 0");
	player setclientdvar("vc_yh", "0.02 0 0.1 0");
	player setclientdvar("vc_rgbl", "0.02 0 0.1 0");
	player setclientdvar("r_exposureValue", 3.9);
	player setclientdvar("r_lightTweakSunLight", 1);
	player setclientdvar("r_sky_intensity_factor0", 0);
	level.default_r_exposurevalue = GetDvar("r_exposureValue");
	level.default_r_lighttweaksunlight = GetDvar("r_lightTweakSunLight");
	level.default_r_sky_intensity_factor0 = GetDvar("r_sky_intensity_factor0");
}

/*
	Name: setdvars
	Namespace: forest
	Checksum: 0x549312B8
	Offset: 0x57A0
	Size: 0x31
	Parameters: 0
	Flags: None
*/
setdvars()
{
	setdvar("scr_screecher_ignore_player", 1);
	setdvar("ui_errorMessage", "^9Thank you for playing this Custom Survival Map 
^9More Mods -> https://github.com/whydoesanyonecare");
	setdvar("ui_errorTitle", "^1Forest");
}

/*
	Name: onplayerconnect
	Namespace: forest
	Checksum: 0x3445F9BA
	Offset: 0x57D2
	Size: 0x22
	Parameters: 0
	Flags: None
*/
onplayerconnect()
{
	level endon("end_game");
	for(;;)
	{
		level waittill("connected", player);
		player thread onplayerspawned();
	}
}

/*
	Name: onplayerspawned
	Namespace: forest
	Checksum: 0x3D33EE84
	Offset: 0x57F6
	Size: 0xA4
	Parameters: 0
	Flags: None
*/
onplayerspawned()
{
	self endon("disconnect");
	level endon("end_game");
	self waittill("spawned_player");
	self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
	self.perk_reminder = 0;
	self.perk_count = 0;
	self.num_perks = 0;
	self thread removeperkshader();
	self thread perkboughtcheck();
	flag_wait("start_zombie_round_logic");
	wait(3);
	self iprintln("The ^1Forest^7 - Survival");
	wait(5);
	self setworldfogactivebank(0);
	self iprintln("^1AATs enabled: ^7Weapons can be Pack a Punched Multipletimes.");
	for(;;)
	{
		self waittill("spawned_player");
		wait(1);
		if(self.score < 2500)
		{
			self.score = 2500;
		}
	}
}

/*
	Name: remove_hud
	Namespace: forest
	Checksum: 0xFDF05E7D
	Offset: 0x589C
	Size: 0x15
	Parameters: 0
	Flags: None
*/
remove_hud()
{
	level waittill("vote_start");
	level.zombiescounter destroy();
}

/*
	Name: drawzombiescounter
	Namespace: forest
	Checksum: 0x187F4EC9
	Offset: 0x58B2
	Size: 0x9E
	Parameters: 0
	Flags: None
*/
drawzombiescounter()
{
	level endon("end_game");
	thread remove_hud();
	flag_wait("initial_blackscreen_passed");
	removebuildable("jetgun_zm");
	level.zombiescounter = createserverfontstring("hudsmall", 1.9);
	level.zombiescounter setpoint("RIGHT", "TOP", 315, "RIGHT");
	while(1)
	{
		enemies = get_round_enemy_array().size + level.zombie_total;
		level.zombiescounter.label = &"Zombies: ^1";
		level.zombiescounter setvalue(enemies);
		wait(0.05);
	}
}

/*
	Name: damagehitmarker
	Namespace: forest
	Checksum: 0x4C28AA34
	Offset: 0x5952
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
damagehitmarker()
{
	self thread startwaiting();
	self.hitmarker = newdamageindicatorhudelem(self);
	self.hitmarker.horzalign = "center";
	self.hitmarker.vertalign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setshader("damage_feedback", 24, 48);
}

/*
	Name: startwaiting
	Namespace: forest
	Checksum: 0xD39DA5F4
	Offset: 0x59BE
	Size: 0x6E
	Parameters: 0
	Flags: None
*/
startwaiting()
{
	self endon("disconnect");
	level endon("end_game");
	while(1)
	{
		foreach(zombie in getaiarray(level.zombie_team))
		{
			if(!isdefined(zombie.waitingfordamage))
			{
				zombie thread hitmark();
			}
		}
		wait(0.25);
	}
}

/*
	Name: hitmark
	Namespace: forest
	Checksum: 0x3D867B03
	Offset: 0x5A2E
	Size: 0xDA
	Parameters: 0
	Flags: None
*/
hitmark()
{
	self endon("killed");
	level endon("end_game");
	self.waitingfordamage = 1;
	while(1)
	{
		self waittill("damage", amount, attacker, dir, point, mod);
		attacker.hitmarker.alpha = 0;
		if(isplayer(attacker))
		{
			if(isalive(self))
			{
				attacker.hitmarker.color =  1, 1, 1;
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime(1);
				attacker.hitmarker.alpha = 0;
			}
			else
			{
				attacker.hitmarker.color =  1, 0, 0;
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime(1);
				attacker.hitmarker.alpha = 0;
				self notify("killed");
			}
		}
	}
}

/*
	Name: init_custom_map
	Namespace: forest
	Checksum: 0x8EB5179F
	Offset: 0x5B0A
	Size: 0x3F7
	Parameters: 0
	Flags: None
*/
init_custom_map()
{
	noncollision("script_model", (5116.05, 7088.78, -24.875), "p6_zm_door_tearin_wood01",  0, 0, 0, "wood_door");
	noncollision("script_model", (5116.05, 7088.78, -24.875), "collision_player_wall_512x512x10",  0, 0, 0, "collisionwall1");
	noncollision("script_model", (5116.05, 7088.78, -225.875), "collision_wall_512x512x10_standard",  0, 0, 0, "collisionwall1");
	noncollision("script_model", (5456.65, 6313.14, -65.3518), "collision_player_wall_512x512x10", (0, 110, 0), "collisionwall1");
	noncollision("script_model", (5333.69, 4503.56, -70.0705), "collision_player_wall_512x512x10", (0, 90, 0), "collisionwall2");
	noncollision("script_model", (3735.79, 4160.7, -122.9), "collision_player_wall_512x512x10", (0, -45, 0), "collisionwall3");
	noncollision("script_model", (5400.65, 6513.14, -65.3518), "t5_foliage_tree_burnt03", (-80, 110, 0), "tree");
	noncollision("script_model", (5415.69, 4395.56, -70.0705), "veh_t6_civ_bus_zombie", (0, 90, 0), "bus");
	noncollision("script_model", (3715.79, 4130.7, -122.9), "t5_foliage_tree_burnt03", (-80, -45, 0), "tree2");
	noncollision("script_model", (3800.79, 4040.7, -122.9), "veh_t6_civ_microbus_dead", (0, -45, 0), "minibus");
	thread perk_system((3252.1, 5349.29, -28.8062), "t6_wpn_zmb_perk_bottle_doubletap_world", (0, 90, 0), "original", "mus_perks_doubletap_sting", "Double Tap Root Beer", 2000, "doubletap_light", "specialty_rof");
	thread perk_system((4244.28, 6091, -28.875), "t6_wpn_zmb_perk_bottle_jugg_world", (0, 45, 0), "original", "mus_perks_jugganog_sting", "Jugger-Nog", 2500, "jugger_light", "specialty_armorvest");
	thread perk_system((3837, 4090, -87.52), "t6_wpn_zmb_perk_bottle_marathon_world", (0, 135, 0), "original", "mus_perks_stamin_sting", "Stamin-Up", 2000, "marathon_light", "specialty_longersprint");
	thread perk_system((4909, 5272, -40.5062), "t6_wpn_zmb_perk_bottle_sleight_world", (0, -80, 0), "original", "mus_perks_speed_sting", "Speed Cola", 3000, "sleight_light", "specialty_fastreload");
	thread wallweaponmonitorbox((5390.69, 6946, 21.351), (0, 185, 0), "cymbal_monkey_zm", 4000, 4000, "Cymbal Monkey");
	soul_box("zombie_perk_bottle_tombstone");
	thread door();
	thread quick_revive_bucket((5030, 6854, -3), (0, 90, 0), "t6_wpn_zmb_perk_bottle_revive_world");
	thread fx_stuff();
	thread barrel((3991.66, 5464.1, -63.875));
	thread barrel((3923.48, 4021.08, -125.83));
	thread barrel((5354.15, 3851.59, 41.8002));
	thread barrel((5547.82, 5575, -63.875));
	thread barrel((4280.79, 6262.4, -71.2423));
	thread barrel((4459.9, 5325.89, -63.875));
}

/*
	Name: barrel
	Namespace: forest
	Checksum: 0xE0C1A532
	Offset: 0x5F02
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
barrel(origin)
{
	flag_wait("initial_blackscreen_passed");
	barrel = spawn("script_model", origin);
	barrel.angles =  0, 0, 0;
	barrel setmodel("afr_barrel_biohazard_white_rust");
	collision = spawn("script_model", origin);
	collision.angles =  0, 0, 0;
	collision setmodel("zm_collision_perks1");
	barrel_fire = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_med"), barrel.origin + (10, 0, 30));
	triggerfx(barrel_fire);
}

/*
	Name: fx_stuff
	Namespace: forest
	Checksum: 0x32312AA3
	Offset: 0x5FA2
	Size: 0x645
	Parameters: 0
	Flags: None
*/
fx_stuff()
{
	flag_wait("start_zombie_round_logic");
	fire = [];
	fire[0] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4636.37, 6700.99, -2.64336));
	fire[1] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_med"), (3565, 4385, -40));
	fire[2] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_med"), (3240, 5290, 0));
	fire[3] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (3642.12, 6278.18, -29.8486));
	fire[4] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5558.62, 5640.9, 217.782));
	fire[5] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (3569.65, 6565.66, 400.902));
	fire[6] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (3440.82, 6277.38, 397.861));
	fire[7] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4535.86, 5268.1, 218.012));
	fire[8] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (3721.61, 4146.42, -121.778));
	fire[9] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4906.84, 6700.64, 206.833));
	fire[10] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4240.76, 6245.25, 360.963));
	fire[11] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4245, 6220, 247.714));
	fire[12] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4245, 6220, 100));
	fire[13] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5166.62, 4024.89, 370.9));
	fire[14] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5168.24, 4777.61, 323.712));
	fire[15] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5924.23, 4082.76, 520.865));
	fire[16] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_med"), (5489.1, 6333.27, -12.0661));
	fire[17] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5152.44, 4874.15, 172.778));
	fire[18] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5152.44, 4874.15, 42.778));
	fire[19] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (3050.46, 5189.88, 410.167));
	fire[20] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (2999.71, 5224.48, 308));
	fire[21] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5156.47, 3940.41, 100));
	fire[22] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5156.47, 3940.41, 230));
	fire[23] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4731.14, 4006.45, -31.8227));
	fire[24] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4800.14, 4030.21, 120.8227));
	fire[25] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4820.9, 4000.21, 280));
	fire[26] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_med"), (3789.49, 3682.48, 130.799));
	fire[27] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (5630.73, 5596.27, 54.5972));
	fire[28] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (4540.95, 5278.01, 39.5859));
	fire[29] = spawnfx(loadfx("maps/zombie/fx_zmb_tranzit_fire_lrg"), (1883.36, 3270.75, 374.817));
	for(i = 0; i < fire.size; i++)
	{
		triggerfx(fire[i]);
	}
	streetlamp = loadfx("maps/zombie/fx_zmb_tranzit_light_safety_max");
	lamp_model = spawn("script_model", (4494.32, 4217.23, -107.039));
	lamp_model.angles = (0, 101.41, 0);
	lamp_model setmodel("p_glo_street_light02");
	model = spawn("script_model", (4485, 4267, 63));
	model.angles =  0, 0, 0;
	model setmodel("tag_origin");
	fx = playfxontag(streetlamp, model, "tag_origin");
}

/*
	Name: quick_revive_bucket
	Namespace: forest
	Checksum: 0x464529E0
	Offset: 0x65E8
	Size: 0x2BC
	Parameters: 3
	Flags: None
*/
quick_revive_bucket(origin, angles, model)
{
	level endon("end_game");
	level.solo_revives = 0;
	bucket = spawn("script_model", origin);
	bucket.angles = angles;
	bucket setmodel("p_glo_bucket_metal");
	bottle1 = spawn("script_model", origin + (3, 3, 10));
	bottle1.angles = (4, 90, 0);
	bottle1 setmodel(model);
	bottle2 = spawn("script_model", origin + (0, 0, 12) - (3, 3, 0));
	bottle2.angles = (-10, 90, -4);
	bottle2 setmodel(model);
	bottle3 = spawn("script_model", origin + (0, 3, 11) - (3, 0, 0));
	bottle3.angles = (4, 90, 0);
	bottle3 setmodel(model);
	bottle4 = spawn("script_model", origin + (3, 0, 12) - (0, 3, 0));
	bottle4.angles = (-6, 90, 0);
	bottle4 setmodel(model);
	trigger = spawn("trigger_radius", origin, 0, 30, 30);
	trigger setcursorhint("HINT_NOICON");
	bucket thread play_fx("revive_light");
	while(get_players().size > 1)
	{
		trigger sethintstring("Hold ^3&&1^7 for Revive [Cost: 1500]");
		cost = 1500;
		level.solo_revives = 0;
		continue;
		trigger sethintstring("Hold ^3&&1^7 for Revive [Cost: 500]");
		cost = 500;
		trigger waittill("trigger", player);
		if(player usebuttonpressed() && player.score >= cost && player can_buy())
		{
			if(!player hasperk("specialty_quickrevive") && level.solo_revives < 3)
			{
				if(get_players().size < 2)
				{
					level.solo_revives++;
				}
				player thread dogiveperk("specialty_quickrevive");
				player playsound("zmb_cha_ching");
				player.score = player.score - cost;
				player playsound("mus_perks_revive_sting");
				wait(3);
			}
			else if(level.solo_revives == 3)
			{
				player iprintln("you have already bought 3 quick revives.");
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "oh_shit");
				wait(3);
			}
		}
		else if(player usebuttonpressed() && player.score < cost)
		{
			player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 0);
		}
		wait(0.1);
	}
}

/*
	Name: perk_system
	Namespace: forest
	Checksum: 0xF98D4A9A
	Offset: 0x68A6
	Size: 0x2A2
	Parameters: 9
	Flags: None
*/
perk_system(origin, model, angles, type, sound, name, cost, fx, perk)
{
	level endon("end_game");
	bucket = spawn("script_model", origin);
	bucket.angles = angles;
	bucket setmodel("p_glo_bucket_metal");
	if(type == "original")
	{
		bottle1 = spawn("script_model", origin + (3, 3, 10));
		bottle1.angles = (4, 90, 0);
		bottle1 setmodel(model);
		bottle2 = spawn("script_model", origin + (0, 0, 12) - (3, 3, 0));
		bottle2.angles = (-10, 90, -4);
		bottle2 setmodel(model);
		bottle3 = spawn("script_model", origin + (0, 3, 11) - (3, 0, 0));
		bottle3.angles = (4, 90, 0);
		bottle3 setmodel(model);
		bottle4 = spawn("script_model", origin + (3, 0, 12) - (0, 3, 0));
		bottle4.angles = (-6, 90, 0);
		bottle4 setmodel(model);
		newstump = spawn("script_model", origin - (0, 0, 50));
		newstump.angles = angles;
		newstump setmodel("foliage_red_pine_stump_lg");
	}
	collision = spawn("script_model", origin);
	collision setmodel("zm_collision_perks1");
	collision.angles = angles;
	trigger = spawn("trigger_radius", origin, 0, 35, 40);
	trigger setcursorhint("HINT_NOICON");
	trigger sethintstring("Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]");
	bucket thread play_fx(fx);
	for(;;)
	{
		trigger waittill("trigger", player);
		if(player can_buy() && player usebuttonpressed() && (!player hasperk(perk) && player.score >= cost))
		{
			player playsound("zmb_cha_ching");
			player.score = player.score - cost;
			player playsound(sound);
			player thread dogiveperk(perk);
			wait(4);
		}
		else if(player usebuttonpressed() && player.score < cost)
		{
			player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 0);
		}
		wait(0.1);
	}
}

/*
	Name: play_fx
	Namespace: forest
	Checksum: 0xF265256
	Offset: 0x6B4A
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
play_fx(fx)
{
	playfxontag(level._effect[fx], self, "tag_origin");
}

/*
	Name: noncollision
	Namespace: forest
	Checksum: 0x6806DC67
	Offset: 0x6B66
	Size: 0x35
	Parameters: 5
	Flags: None
*/
noncollision(script, pos, model, angles, type)
{
	noncol = spawn("script_model", pos);
	noncol setmodel(model);
	noncol.angles = angles;
}

/*
	Name: door
	Namespace: forest
	Checksum: 0x6173B97C
	Offset: 0x6B9C
	Size: 0x25B
	Parameters: 0
	Flags: None
*/
door()
{
System.Exception: contains invalid operation code
   at ⁫‮‌‎⁫⁭‎‏‮‭⁭‌⁪‫‬‮​​‍‪‫‎⁫‪⁬‏‪⁭‭‌⁯‍⁭‍⁬⁬⁫‭⁬‮‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: default_vending_precaching
	Namespace: forest
	Checksum: 0xE8B22A9E
	Offset: 0x6DF8
	Size: 0x7A
	Parameters: 0
	Flags: None
*/
default_vending_precaching()
{
	level._effect["sleight_light"] = loadfx("misc/fx_zombie_cola_on");
	level._effect["tombstone_light"] = loadfx("misc/fx_zombie_cola_on");
	level._effect["revive_light"] = loadfx("misc/fx_zombie_cola_revive_on");
	level._effect["marathon_light"] = loadfx("maps/zombie/fx_zmb_cola_staminup_on");
	level._effect["jugger_light"] = loadfx("misc/fx_zombie_cola_jugg_on");
	level._effect["doubletap_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
}

/*
	Name: spawnhint
	Namespace: forest
	Checksum: 0x520729EA
	Offset: 0x6E74
	Size: 0x5D
	Parameters: 5
	Flags: None
*/
spawnhint(origin, width, height, cursorhint, string)
{
	hint = spawn("trigger_radius", origin, 1, width, height);
	hint setcursorhint(cursorhint, hint);
	hint sethintstring(string);
	hint setvisibletoall();
	wait(0.2);
	hint delete();
}

/*
	Name: spawnentity
	Namespace: forest
	Checksum: 0xF005451D
	Offset: 0x6ED2
	Size: 0x36
	Parameters: 4
	Flags: None
*/
spawnentity(class, model, origin, angle)
{
	entity = spawn(class, origin);
	entity.angles = angle;
	entity setmodel(model);
	return entity;
}

/*
	Name: custom_get_pack_a_punch_weapon_options
	Namespace: forest
	Checksum: 0x696B4B55
	Offset: 0x6F0A
	Size: 0x20A
	Parameters: 1
	Flags: None
*/
custom_get_pack_a_punch_weapon_options(weapon)
{
	if(!isdefined(self.pack_a_punch_weapon_options))
	{
		self.pack_a_punch_weapon_options = [];
	}
	if(!is_weapon_upgraded(weapon))
	{
		return self calcweaponoptions(0, 0, 0, 0, 0);
	}
	if(isdefined(self.pack_a_punch_weapon_options[weapon]))
	{
		return self.pack_a_punch_weapon_options[weapon];
	}
	smiley_face_reticle_index = 1;
	base = get_base_name(weapon);
	if(base == "m16_zm" || weapon == "m16_upgraded_zm" || (base == "qcw05_upgraded_zm" || weapon == "qcw05_zm") || (base == "fivesevendw_upgraded_zm" || weapon == "fivesevendw_zm") || (base == "fiveseven_upgraded_zm" || weapon == "fiveseven_zm") || (base == "m32_upgraded_zm" || weapon == "m32_zm") || (base == "ray_gun_upgraded_zm" || weapon == "ray_gun_zm") || (base == "raygun_mark2_upgraded_zm" || weapon == "raygun_mark2_zm") || (base == "m1911_upgraded_zm" || weapon == "m1911_zm") || (base == "knife_ballistic_upgraded_zm" || weapon == "knife_ballistic_zm"))
	{
		camo_index = 39;
	}
	else
	{
		camo_index = 44;
	}
	lens_index = randomintrange(0, 6);
	reticle_index = randomintrange(0, 16);
	reticle_color_index = randomintrange(0, 6);
	plain_reticle_index = 16;
	r = randomint(10);
	use_plain = r < 3;
	if(base == "saritch_upgraded_zm")
	{
		reticle_index = smiley_face_reticle_index;
	}
	else if(use_plain)
	{
		reticle_index = plain_reticle_index;
	}
	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;
	if(reticle_index == scary_eyes_reticle_index)
	{
		reticle_color_index = purple_reticle_color_index;
	}
	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;
	if(reticle_index == letter_a_reticle_index)
	{
		reticle_color_index = pink_reticle_color_index;
	}
	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;
	if(reticle_index == letter_e_reticle_index)
	{
		reticle_color_index = green_reticle_color_index;
	}
	self.pack_a_punch_weapon_options[weapon] = self calcweaponoptions(camo_index, lens_index, reticle_index, reticle_color_index);
	return self.pack_a_punch_weapon_options[weapon];
}

/*
	Name: souls
	Namespace: forest
	Checksum: 0x6CDFB76E
	Offset: 0x7116
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
souls(box)
{
	source_pos = self gettagorigin("j_spineupper");
	target_pos = box;
	soul = spawn("script_model", source_pos);
	soul setmodel("tag_origin");
	wait(0.1);
	fx = playfxontag(level._effect["avogadro_bolt"], soul, "tag_origin");
	soul moveto(target_pos, 0.2);
	soul waittill("movedone");
	soul delete();
}

/*
	Name: soul_box
	Namespace: forest
	Checksum: 0x3B16FC5A
	Offset: 0x71A2
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
soul_box(model)
{
	level.soulbox_active = 1;
	level.souls_needed = 25;
	level.soulbox_souls = 0;
	level.soulbox = spawnentity("script_model", getweaponmodel(model), (5195.03, 6315.05, -19.875),  0, 0, 0);
}

/*
	Name: custom_death_callback
	Namespace: forest
	Checksum: 0x34371884
	Offset: 0x71F2
	Size: 0xAD
	Parameters: 11
	Flags: None
*/
custom_death_callback(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if(level.soulbox_active)
	{
		if(distance(level.soulbox.origin, self.origin) <= 350)
		{
			self souls(level.soulbox.origin);
			playfx(loadfx("misc/fx_zombie_powerup_solo_grab"), level.soulbox.origin);
			level.soulbox_souls++;
			if(level.souls_needed <= level.soulbox_souls)
			{
				level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("random_perk", level.soulbox.origin);
				level.soulbox delete();
				level.soulbox_active = 0;
			}
		}
	}
}

/*
	Name: dogiveperk
	Namespace: forest
	Checksum: 0x73871FC8
	Offset: 0x72A0
	Size: 0xB8
	Parameters: 1
	Flags: None
*/
dogiveperk(perk)
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	self endon("perk_abort_drinking");
	if(!self hasperk(perk) || self maps\mp\zombies\_zm_perks::has_perk_paused(perk))
	{
		gun = self maps\mp\zombies\_zm_perks::perk_give_bottle_begin(perk);
		evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
		if(evt == "weapon_change_complete")
		{
			self thread maps\mp\zombies\_zm_perks::wait_give_perk(perk, 1);
		}
		self maps\mp\zombies\_zm_perks::perk_give_bottle_end(gun, perk);
		if(self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined(self.intermission) && self.intermission)
		{
			return;
		}
		self notify("burp");
	}
}

/*
	Name: give_random_perk
	Namespace: forest
	Checksum: 0xD9E39196
	Offset: 0x735A
	Size: 0x21F
	Parameters: 0
	Flags: None
*/
give_random_perk()
{
	perks = array();
	if(!self hascustomperk("Downers_Delight"))
	{
		perks[perks.size] = "Downers_Delight";
	}
	if(!self hascustomperk("PHD_FLOPPER"))
	{
		perks[perks.size] = "PHD_FLOPPER";
	}
	if(!self hascustomperk("MULE"))
	{
		perks[perks.size] = "MULE";
	}
	if(!self hascustomperk("ELECTRIC_CHERRY"))
	{
		perks[perks.size] = "ELECTRIC_CHERRY";
	}
	if(!self hascustomperk("WIDOWS_WINE"))
	{
		perks[perks.size] = "WIDOWS_WINE";
	}
	if(!self hascustomperk("Ethereal_Razor"))
	{
		perks[perks.size] = "Ethereal_Razor";
	}
	if(!self hascustomperk("Ammo_Regen"))
	{
		perks[perks.size] = "Ammo_Regen";
	}
	if(!self hascustomperk("Dying_Wish"))
	{
		perks[perks.size] = "Dying_Wish";
	}
	if(!self hascustomperk("deadshot"))
	{
		perks[perks.size] = "deadshot";
	}
	if(!self hasperk("specialty_armorvest"))
	{
		perks[perks.size] = "specialty_armorvest";
	}
	if(!self hasperk("specialty_rof"))
	{
		perks[perks.size] = "specialty_rof";
	}
	if(!self hasperk("specialty_fastreload"))
	{
		perks[perks.size] = "specialty_fastreload";
	}
	if(!self hasperk("specialty_longersprint"))
	{
		perks[perks.size] = "specialty_longersprint";
	}
	if(!self hasperk("specialty_quickrevive"))
	{
		perks[perks.size] = "specialty_quickrevive";
	}
	if(!perks.size > 0)
	{
		self playsoundtoplayer(level.zmb_laugh_alias, self);
		return 0;
	}
	n = array_randomize(perks);
	perk = n[0];
	if(perk == "specialty_armorvest" || perk == "specialty_rof" || (perk == "specialty_fastreload" || perk == "specialty_longersprint") || perk == "specialty_quickrevive")
	{
		self maps\mp\zombies\_zm_perks::give_perk(perk, 0);
	}
	else
	{
		self drawshader_and_shadermove(perk, 0, 1);
	}
}

/*
	Name: custom_powerup_grab
	Namespace: forest
	Checksum: 0x4EB1A70B
	Offset: 0x757A
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
custom_powerup_grab(s_powerup, e_player)
{
	if(s_powerup.powerup_name == "zombie_cash")
	{
		e_player thread power_up_hud(0, 0, "Zombie Cash!");
		e_player.score = e_player.score + 500;
	}
	if(s_powerup.powerup_name == "random_perk")
	{
		foreach(player in level.players)
		{
			player thread power_up_hud(0, 0, "Free Perk!");
			player thread give_random_perk();
		}
	}
	else if(isdefined(level.original_zombiemode_powerup_grab))
	{
		level thread [[level.original_zombiemode_powerup_grab]](s_powerup, e_player);
	}
}

/*
	Name: power_up_hud
	Namespace: forest
	Checksum: 0x97E14057
	Offset: 0x7626
	Size: 0x107
	Parameters: 3
	Flags: None
*/
power_up_hud(shader, shader2, text)
{
	self endon("disconnect");
	power_up_hud_string = newclienthudelem(self);
	power_up_hud_string.elemtype = "font";
	power_up_hud_string.font = "objective";
	power_up_hud_string.fontscale = 2;
	power_up_hud_string.x = 0;
	power_up_hud_string.y = 0;
	power_up_hud_string.width = 0;
	power_up_hud_string.height = int(level.fontheight * 2);
	power_up_hud_string.xoffset = 0;
	power_up_hud_string.yoffset = 0;
	power_up_hud_string.children = [];
	power_up_hud_string setparent(level.uiparent);
	power_up_hud_string.hidden = 0;
	power_up_hud_string maps\mp\gametypes_zm\_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - level.zombie_vars["zombie_timer_offset_interval"] * 2);
	power_up_hud_string.sort = 0.5;
	power_up_hud_string.alpha = 0;
	power_up_hud_string fadeovertime(0.5);
	power_up_hud_string.alpha = 1;
	power_up_hud_string settext(text);
	power_up_hud_string thread string_move();
}

/*
	Name: string_move
	Namespace: forest
	Checksum: 0xE8D5978C
	Offset: 0x772E
	Size: 0x47
	Parameters: 0
	Flags: None
*/
string_move()
{
	wait(0.5);
	self fadeovertime(1.5);
	self moveovertime(1.5);
	self.y = 270;
	self.alpha = 0;
	wait(1.5);
	self destroy();
}

/*
	Name: ongameendedhint
	Namespace: forest
	Checksum: 0x3D6F75CD
	Offset: 0x7776
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
ongameendedhint()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at System.Collections.Generic.List`1.get_Item(Int32 index)
   at ⁫‮‌‎⁫⁭‎‏‮‭⁭‌⁪‫‬‮​​‍‪‫‎⁫‪⁬‏‪⁭‭‌⁯‍⁭‍⁬⁬⁫‭⁬‮‮.‮​⁬⁭⁮‍‏‏‫‎‭‫⁮‪‮⁭‮⁬​‌⁯‮⁭‬​‪⁭‍‏‪⁪‎⁭⁭‌⁪‌‭​⁯‮(ScriptOp , ‫⁬⁫⁮⁯‫‪⁫‎‏‮‌‍‫‏⁭​​‪‏‍‍⁫‬⁪‎‮‏‫‫​⁪‪‮‪‏⁭​‫⁫‮ )
   at ⁫‮‌‎⁫⁭‎‏‮‭⁭‌⁪‫‬‮​​‍‪‫‎⁫‪⁬‏‪⁭‭‌⁯‍⁭‍⁬⁬⁫‭⁬‮‮.‭⁭⁫‭⁪‫‭‮‪⁬‏‎‪⁯⁪⁬‪‏‫⁯⁯‭​‫⁯‍‮⁫‪‏⁫⁪‎‏‫‫‪⁬‌⁯‮(‫⁬⁫⁮⁯‫‪⁫‎‏‮‌‍‫‏⁭​​‪‏‍‍⁫‬⁪‎‮‏‫‫​⁪‪‮‪‏⁭​‫⁫‮ , Int32 )
   at ⁫‮‌‎⁫⁭‎‏‮‭⁭‌⁪‫‬‮​​‍‪‫‎⁫‪⁬‏‪⁭‭‌⁯‍⁭‍⁬⁬⁫‭⁬‮‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: box_init
	Namespace: forest
	Checksum: 0x860E1FC2
	Offset: 0x7820
	Size: 0x3B0
	Parameters: 1
	Flags: None
*/
box_init(origin)
{
	setdvar("magic_chest_movable", "0");
	level.zombie_weapons["m16_zm"].is_in_box = 1;
	level.zombie_weapons["870mcs_zm"].is_in_box = 1;
	level.zombie_weapons["rottweil72_zm"].is_in_box = 1;
	level.zombie_weapons["mp5k_zm"].is_in_box = 1;
	level.zombie_weapons["ak74u_zm"].is_in_box = 1;
	level.zombie_weapons["emp_grenade_zm"].is_in_box = 0;
	collision = spawn("script_model", origin);
	collision.angles = (0, 90, 0);
	collision setmodel("collision_player_32x32x128");
	collision disconnectpaths();
	collision = spawn("script_model", origin - (0, 32, 0));
	collision.angles = (0, 90, 0);
	collision setmodel("collision_player_32x32x128");
	collision disconnectpaths();
	collision = spawn("script_model", origin + (0, 32, 0));
	collision.angles = (0, 90, 0);
	collision setmodel("collision_player_32x32x128");
	collision disconnectpaths();
	brick1 = spawn("script_model", origin + (0, 32, 0));
	brick1.angles = (0, 190, 0);
	brick1 setmodel("p_glo_cinder_block");
	brick2 = spawn("script_model", origin + (0, 10, 0));
	brick2.angles = (0, 30, 0);
	brick2 setmodel("p_glo_cinder_block");
	brick3 = spawn("script_model", origin - (0, 11, 0));
	brick3.angles = (0, -10, 0);
	brick3 setmodel("p_glo_cinder_block");
	brick4 = spawn("script_model", origin - (0, 32, 0));
	brick4.angles = (0, 30, 0);
	brick4 setmodel("p_glo_cinder_block");
	new_boxes = [];
	new_boxes[5]["name"] = "start_chest";
	new_boxes[5]["origin"] = origin + (0, 0, 3);
	new_boxes[5]["angles"] = (0, 90, 0);
	foreach(new_box in new_boxes)
	{
		for(i = 0; i < level.chests.size; i++)
		{
			if(level.chests[i].script_noteworthy == new_box["name"])
			{
				level.chests[i].origin = new_box["origin"];
				level.chests[i].angles = new_box["angles"];
				level.chests[i].zbarrier.origin = new_box["origin"];
				level.chests[i].zbarrier.angles = new_box["angles"];
				level.chests[i].pandora_light.origin = new_box["origin"];
				level.chests[i].pandora_light.angles = new_box["angles"] + VectorScale( -1, 0, -1, 90);
				level.chests[i].unitrigger_stub.origin = new_box["origin"] + AnglesToRight(new_box["angles"]) * -22.5;
				level.chests[i].unitrigger_stub.angles = new_box["angles"];
				level.chests[i] thread show_chest();
				level.chests[i] thread setmebackup();
				break;
			}
		}
		box_rubble = getentarray(new_box["name"] + "_rubble", "script_noteworthy");
		for(i = 0; i < box_rubble.size; i++)
		{
			box_rubble[i].origin = new_box["origin"];
		}
	}
}

/*
	Name: setmebackup
	Namespace: forest
	Checksum: 0xA68A2A7F
	Offset: 0x7BD2
	Size: 0x2E
	Parameters: 0
	Flags: None
*/
setmebackup()
{
	level endon("end_game");
	while(1)
	{
		self.zbarrier waittill("closed");
		thread maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &magicbox_unitrigger_think);
	}
}

/*
	Name: wallweaponmonitorbox
	Namespace: forest
	Checksum: 0xACD6F34F
	Offset: 0x7C02
	Size: 0x236
	Parameters: 6
	Flags: None
*/
wallweaponmonitorbox(origin, angles, weapon, cost, ammo, name)
{
	level endon("end_game");
	trigger = spawn("trigger_radius", origin, 0, 35, 80);
	trigger setcursorhint("HINT_NOICON");
	if(isdefined(name))
	{
		model = spawn("script_model", origin);
		model.angles = angles;
		model setmodel(getweaponmodel(weapon));
		trigger sethintstring("Hold ^3&&1^7 to buy " + name + " [Cost: " + cost + "]");
	}
	else
	{
		trigger sethintstring("Hold ^3&&1^7 to buy " + name + " [Cost: " + cost + "] Ammo [Cost: " + ammo + "] Upgraded Ammo [Cost: 4500]");
	}
	for(;;)
	{
		trigger waittill("trigger", player);
		if(player usebuttonpressed() && player.score >= cost && player can_buy())
		{
			grenades = player getweaponammoclip(player get_player_lethal_grenade());
			if(!player has_weapon_or_upgrade(weapon))
			{
				player.score = player.score - cost;
				player thread weapon_give(weapon, 0, 1);
				wait(3);
			}
			else if(player has_upgrade(weapon) && player.score >= 4500)
			{
				if(player ammo_give(get_upgrade_weapon(weapon)))
				{
					player.score = player.score - 4500;
					player playsound("zmb_cha_ching");
					wait(3);
				}
			}
			else if(player hasweapon(weapon) && player.score >= ammo)
			{
				if(player ammo_give(weapon))
				{
					player.score = player.score - ammo;
					player playsound("zmb_cha_ching");
					wait(3);
				}
			}
		}
		else if(player usebuttonpressed() && !player hasweapon(weapon) && player.score < cost)
		{
			player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon");
		}
		wait(0.1);
	}
}

/*
	Name: shield
	Namespace: forest
	Checksum: 0xEDAAC011
	Offset: 0x7E3A
	Size: 0x1E1
	Parameters: 0
	Flags: None
*/
shield()
{
	shieldworkbenchtrigger1 = getentarray("riotshield_zm_buildable_trigger", "targetname");
	shieldworkbenchtrigger1[0].origin = (5229.52, 7037.35, 25.125);
	shieldworkbenchtrigger1[0].angles = (0, 90, 0);
	shieldworkbenchtrigger1[0].script_length = 66;
	wait(1);
	shieldpart1 = getstructarray("riotshield_zm_t6_wpn_zmb_shield_dolly", "targetname");
	shieldpart1[0].origin = (4853.16, 4214.51, -80.1587);
	shieldpart1[0].angles = (-25, -105, 0);
	shieldpart1[1].origin = (4853.16, 4214.51, -80.1587);
	shieldpart1[1].angles = (-25, -105, 0);
	shieldpart1[2].origin = (4853.16, 4214.51, -80.1587);
	shieldpart1[2].angles = (-25, -105, 0);
	shieldpart2 = getstructarray("riotshield_zm_t6_wpn_zmb_shield_door", "targetname");
	shieldpart2[0].origin = (4980.22, 6620.85, -37.1134);
	shieldpart2[0].angles = (-10, -180, 0);
	shieldpart2[1].origin = (4980.22, 6620.85, -37.1134);
	shieldpart2[1].angles = (-10, -180, 0);
	shieldpart2[2].origin = (4980.22, 6620.85, -37.1134);
	shieldpart2[2].angles = (-10, -180, 0);
	shieldmodel1 = getentarray("buildable_riotshield", "targetname");
	shieldmodel1[0].origin = (5220.69, 7060, 30.875);
	shieldmodel1[0].angles = (0, 275, 0);
}

/*
	Name: barriers_and_spawners
	Namespace: forest
	Checksum: 0x82251A4E
	Offset: 0x801C
	Size: 0x3AF
	Parameters: 0
	Flags: None
*/
barriers_and_spawners()
{
System.Exception: contains invalid operation code
   at ⁫‮‌‎⁫⁭‎‏‮‭⁭‌⁪‫‬‮​​‍‪‫‎⁫‪⁬‏‪⁭‭‌⁯‍⁭‍⁬⁬⁫‭⁬‮‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: removebuildable
	Namespace: forest
	Checksum: 0x15B8CB99
	Offset: 0x83CC
	Size: 0x12E
	Parameters: 2
	Flags: None
*/
removebuildable(buildable, after_built)
{
	if(!isdefined(after_built))
	{
		after_built = 0;
	}
	if(after_built)
	{
		foreach(stub in level._unitriggers.trigger_stubs)
		{
			if(isdefined(stub.equipname) && stub.equipname == buildable)
			{
				stub.model hide();
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
				return;
			}
		}
		break;
	}
	foreach(stub in level.buildable_stubs)
	{
		if(!isdefined(buildable) || stub.equipname == buildable)
		{
			if(isdefined(buildable) || stub.persistent != 3)
			{
				stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
				foreach(piece in stub.buildablezone.pieces)
				{
					piece maps\mp\zombies\_zm_buildables::piece_unspawn();
				}
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
				return;
			}
		}
	}
}

/*
	Name: can_buy
	Namespace: forest
	Checksum: 0x646B291A
	Offset: 0x84FC
	Size: 0x81
	Parameters: 0
	Flags: None
*/
can_buy()
{
	if(isdefined(self.is_drinking) && self.is_drinking > 0)
	{
		return 0;
	}
	if(self isswitchingweapons())
	{
		return 0;
	}
	if(self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		return 0;
	}
	current_weapon = self getcurrentweapon();
	if(is_placeable_mine(current_weapon) || is_equipment_that_blocks_purchase(current_weapon))
	{
		return 0;
	}
	if(self in_revive_trigger())
	{
		return 0;
	}
	if(current_weapon == "none")
	{
		return 0;
	}
	return 1;
}

/*
	Name: vector_scal
	Namespace: forest
	Checksum: 0x3960E268
	Offset: 0x857E
	Size: 0x24
	Parameters: 2
	Flags: None
*/
vector_scal(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

/*
	Name: new_pap_trigger
	Namespace: forest
	Checksum: 0x90CFA02E
	Offset: 0x85A4
	Size: 0x4D4
	Parameters: 0
	Flags: None
*/
new_pap_trigger()
{
	level endon("end_game");
	custom_pap_origin = (5313.05, 4600.22, -70.6908);
	custom_pap_angles = (0, -90, 0);
	vending_triggers = getentarray("zombie_vending", "targetname");
	for(i = 0; i < vending_triggers.size; i++)
	{
		trig = vending_triggers[i];
		if(isdefined(trig.script_noteworthy) && trig.script_noteworthy == "specialty_weapupgrade")
		{
			trig.machine.origin = custom_pap_origin;
			trig.machine.angles = custom_pap_angles;
			trig.clip.origin = custom_pap_origin;
			trig.clip.angles = custom_pap_angles;
			trig.bump.origin = custom_pap_origin;
			trig.bump.angles = custom_pap_angles;
		}
	}
	pap_on = spawn("script_model", custom_pap_origin);
	pap_on.angles = custom_pap_angles;
	pap_on setmodel("p6_anim_zm_buildable_pap_on");
	perk_machine = getent("vending_packapunch", "targetname");
	weapon_upgrade_trigger = getentarray("specialty_weapupgrade", "script_noteworthy");
	weapon_upgrade_trigger[0] trigger_off();
	self.perk_machine = perk_machine;
	packa_rollers = spawn("script_origin", perk_machine.origin);
	packa_timer = spawn("script_origin", perk_machine.origin);
	packa_rollers linkto(perk_machine);
	packa_timer linkto(perk_machine);
	if(GetDvar("mapname") == "zm_highrise")
	{
		trigger = spawn("trigger_radius", perk_machine.origin, 1, 60, 80);
		trigger enablelinkto();
		trigger linkto(self.perk_machine);
	}
	else
	{
		trigger = spawn("trigger_radius", perk_machine.origin, 1, 35, 80);
	}
	trigger setcursorhint("HINT_NOICON");
	trigger sethintstring("			Hold ^3&&1^7 for Pack-a-Punch [Cost: 5000] 
 Weapons can be pack a punched multiple times");
	trigger usetriggerrequirelookat();
	for(;;)
	{
		trigger waittill("trigger", player);
		current_weapon = player getcurrentweapon();
		trigger sethintstring("^1This weapon doesn't have alternative ammo types.");
	}
	for(;;)
	{
		if(current_weapon == "saritch_upgraded_zm+dualoptic" || current_weapon == "dualoptic_saritch_upgraded_zm+dualoptic" || current_weapon == "slowgun_upgraded_zm")
		{
		}
		else if(player usebuttonpressed() && player.score >= 5000 && (current_weapon != "riotshield_zm" && player can_buy_weapon()) && (!player.is_drinking && !is_placeable_mine(current_weapon)) && (!is_equipment(current_weapon) && level.revive_tool != current_weapon) && current_weapon != "none")
		{
			player.score = player.score - 5000;
			player thread maps\mp\zombies\_zm_audio::play_jingle_or_stinger("mus_perks_packa_sting");
			trigger setinvisibletoall();
			upgrade_as_attachment = will_upgrade_weapon_as_attachment(current_weapon);
			player.restore_ammo = undefined;
			player.restore_clip = undefined;
			player.restore_stock = undefined;
			player.restore_clip_size = undefined;
			player.restore_max = undefined;
			player.restore_clip = player getweaponammoclip(current_weapon);
			player.restore_clip_size = weaponclipsize(current_weapon);
			player.restore_stock = player getweaponammostock(current_weapon);
			player.restore_max = weaponmaxammo(current_weapon);
			player thread maps\mp\zombies\_zm_perks::do_knuckle_crack();
			wait(0.1);
			player takeweapon(current_weapon);
			current_weapon = player maps\mp\zombies\_zm_weapons::switch_from_alt_weapon(current_weapon);
			self.current_weapon = current_weapon;
			upgrade_name = maps\mp\zombies\_zm_weapons::get_upgrade_weapon(current_weapon, upgrade_as_attachment);
			player third_person_weapon_upgrade(current_weapon, upgrade_name, packa_rollers, perk_machine, self);
			trigger sethintstring(&"ZOMBIE_GET_UPGRADED");
			trigger thread wait_for_pick(player, current_weapon, self.upgrade_name);
			if(isdefined(player))
			{
				trigger setinvisibletoall();
				trigger setvisibletoplayer(player);
			}
			self thread wait_for_timeout(current_weapon, packa_timer, player);
			self waittill_any("pap_timeout", "pap_taken", "pap_player_disconnected");
			self.current_weapon = "";
			if(isdefined(self.worldgun) && isdefined(self.worldgun.worldgundw))
			{
				self.worldgun.worldgundw delete();
			}
			if(isdefined(self.worldgun))
			{
				self.worldgun delete();
			}
			trigger setinvisibletoplayer(player);
			wait(1.5);
			trigger setvisibletoall();
			self.pack_player = undefined;
			flag_clear("pack_machine_in_use");
		}
		trigger sethintstring("			Hold ^3&&1^7 for Pack-a-Punch [Cost: 5000] 
 Weapons can be pack a punched multiple times");
		wait(0.1);
	}
}

/*
	Name: wait_for_pick
	Namespace: forest
	Checksum: 0x841023E0
	Offset: 0x8A7A
	Size: 0x202
	Parameters: 3
	Flags: None
*/
wait_for_pick(player, weapon, upgrade_weapon)
{
	level endon("pap_timeout");
	for(;;)
	{
		self playloopsound("zmb_perks_packa_ticktock");
		self waittill("trigger", user);
		if(user usebuttonpressed() && player == user)
		{
			self stoploopsound(0.05);
			player thread do_player_general_vox("general", "pap_arm2", 15, 100);
			gun = player maps\mp\zombies\_zm_weapons::get_upgrade_weapon(upgrade_weapon, 0);
			if(is_weapon_upgraded(weapon))
			{
				player.restore_ammo = 1;
				if(weapon == "galil_upgraded_zm+reflex" || weapon == "fnfal_upgraded_zm+reflex")
				{
					level thread aats(weapon, player);
				}
				else
				{
					level thread aats(upgrade_weapon, player);
				}
			}
			if(weapon == "galil_upgraded_zm+reflex" || weapon == "fnfal_upgraded_zm+reflex")
			{
				player giveweapon(weapon, 0, player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(weapon));
				player switchtoweapon(weapon);
				x = weapon;
			}
			else
			{
				weapon_limit = get_player_weapon_limit(player);
				player maps\mp\zombies\_zm_weapons::take_fallback_weapon();
				primaries = player getweaponslistprimaries();
				if(isdefined(primaries) && primaries.size >= weapon_limit)
				{
					player maps\mp\zombies\_zm_weapons::weapon_give(upgrade_weapon);
				}
				else
				{
					player giveweapon(upgrade_weapon, 0, player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(upgrade_weapon));
				}
				player switchtoweapon(upgrade_weapon);
				x = upgrade_weapon;
			}
			if(isdefined(player.restore_ammo) && player.restore_ammo)
			{
				new_clip = player.restore_clip + weaponclipsize(x) - player.restore_clip_size;
				new_stock = player.restore_stock + weaponmaxammo(x) - player.restore_max;
				player setweaponammostock(x, new_stock);
				player setweaponammoclip(x, new_clip);
			}
			level notify("pap_taken");
			player notify("pap_taken");
		}
		wait(0.1);
	}
	else
	{
	}
}

/*
	Name: aats
	Namespace: forest
	Checksum: 0xD073189
	Offset: 0x8C7E
	Size: 0x33
	Parameters: 2
	Flags: None
*/
aats(name, player)
{
	self endon("death");
	self endon("pap_timeout");
	self endon("pap_player_disconnected");
	self endon("Pack_A_Punch_off");
	self waittill("pap_taken");
	self thread pick_ammo(name, player);
}

/*
	Name: aat_hud
	Namespace: forest
	Checksum: 0xE6EBE2C9
	Offset: 0x8CB2
	Size: 0xDF
	Parameters: 2
	Flags: None
*/
aat_hud(name, color)
{
	self endon("disconnect");
	self.aat_hud = newclienthudelem(self);
	self.aat_hud.alignx = "right";
	self.aat_hud.aligny = "bottom";
	self.aat_hud.horzalign = "user_right";
	self.aat_hud.vertalign = "user_bottom";
	if(GetDvar("mapname") == "zm_transit" || GetDvar("mapname") == "zm_highrise" || GetDvar("mapname") == "zm_nuked")
	{
		self.aat_hud.x = -85;
		self.aat_hud.y = -22;
	}
	else
	{
		self.aat_hud.x = -95;
		self.aat_hud.y = -80;
	}
	self.aat_hud.fontscale = 1;
	self.aat_hud.alpha = 1;
	self.aat_hud.color = color;
	self.aat_hud.hidewheninmenu = 1;
	self.aat_hud settext(name);
}

/*
	Name: pick_ammo
	Namespace: forest
	Checksum: 0xD4197CDF
	Offset: 0x8D92
	Size: 0x3FB
	Parameters: 2
	Flags: None
*/
pick_ammo(name, player)
{
	player notify("new_aat");
	primaries = player getweaponslistprimaries();
	if(!isdefined(player.active_explosive_bullet))
	{
		player thread explosive_bullet();
	}
	if(!isdefined(player.weaponname))
	{
		player.active_turned = 0;
		player.has_turned = 0;
		player.has_blast_furnace = 0;
		player.has_fireworks = 0;
		player.cooldown = 0;
		player.has_explosive_bullets = 0;
		player.has_thunder_wall = 0;
		player.has_headcutter = 0;
		player.has_cluster = 0;
	}
	if(!isdefined(player.weaponname))
	{
		player.weaponname = "x";
	}
	if(!isdefined(player.last_aat))
	{
		player.last_aat = 0;
	}
	if(!isdefined(player.aat_weapon))
	{
		player.aat_weapon = [];
	}
	if(!isdefined(player.weapon_aats))
	{
		player.weapon_aats = [];
	}
	aat = randomintrange(1, 8);
	if(player.weaponname == name && player.last_aat == aat)
	{
		return pick_ammo(name, player);
	}
	for(i = 0; i < primaries.size; i++)
	{
		if(isdefined(primaries[i]) && name == primaries[i])
		{
			player.weapon_aats[i] = aat;
			player.aat_weapon[i] = name;
		}
	}
	player.last_aat = aat;
	player.weaponname = name;
	player.aat_hud destroy();
	if(aat == 1)
	{
		player aat_hud("Blast Furnace",  1, 0, 0);
		player.has_blast_furnace = 1;
		player.has_fireworks = 0;
		player.has_explosive_bullets = 0;
		player.has_thunder_wall = 0;
		player.has_headcutter = 0;
		player.has_cluster = 0;
		player.has_turned = 0;
	}
	if(aat == 2)
	{
		player aat_hud("Fireworks",  0, 1, 0);
		player.has_fireworks = 1;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
		player.has_thunder_wall = 0;
		player.has_headcutter = 0;
		player.has_cluster = 0;
		player.has_turned = 0;
	}
	if(aat == 3)
	{
		player aat_hud("Explosive",  0, 0, 1);
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 1;
		player.has_thunder_wall = 0;
		player.has_headcutter = 0;
		player.has_cluster = 0;
		player.has_turned = 0;
	}
	if(aat == 4)
	{
		player aat_hud("Headcutter",  1, 0, 1);
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
		player.has_thunder_wall = 0;
		player.has_headcutter = 1;
		player.has_cluster = 0;
		player.has_turned = 0;
	}
	if(aat == 5)
	{
		player aat_hud("Cluster", (0.4, 0.4, 0.2));
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
		player.has_thunder_wall = 0;
		player.has_headcutter = 0;
		player.has_cluster = 1;
		player.has_turned = 0;
	}
	if(aat == 6)
	{
		player aat_hud("Turned", (1, 0.5, 0.5));
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
		player.has_thunder_wall = 0;
		player.has_headcutter = 0;
		player.has_cluster = 1;
		player.has_turned = 0;
	}
	if(aat == 7)
	{
		player aat_hud("Thunder Wall",  0, 1, 1);
		player.has_fireworks = 0;
		player.has_blast_furnace = 0;
		player.has_explosive_bullets = 0;
		player.has_thunder_wall = 1;
		player.has_headcutter = 0;
		player.has_cluster = 0;
		player.has_turned = 0;
	}
	player thread monitor_aat_weapon();
}

/*
	Name: monitor_aat_weapon
	Namespace: forest
	Checksum: 0xF8C7EC1B
	Offset: 0x918E
	Size: 0x37C
	Parameters: 0
	Flags: None
*/
monitor_aat_weapon()
{
	self endon("disconnect");
	level endon("end_game");
	self endon("new_aat");
	for(;;)
	{
		self waittill("weapon_change");
		wait(0.1);
		if(self getcurrentweapon() == "none")
		{
			return monitor_aat_weapon();
		}
		if(isdefined(self.aat_hud))
		{
			self.aat_hud destroy();
		}
		for(i = 0; i < 3; i++)
		{
			if(isdefined(self.aat_weapon[i]) && !self hasweapon(self.aat_weapon[i]))
			{
				self.weapon_aats[i] = undefined;
				self.aat_weapon[i] = undefined;
			}
		}
		wait(0.1);
		for(i = 0; i < 3; i++)
		{
			if(isdefined(self.aat_weapon[i]) && self getcurrentweapon() == self.aat_weapon[i])
			{
				if(self.weapon_aats[i] == 2)
				{
					self.has_fireworks = 1;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 0;
					self aat_hud("Fireworks",  0, 1, 0);
				}
				if(self.weapon_aats[i] == 1)
				{
					self.has_fireworks = 0;
					self.has_blast_furnace = 1;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 0;
					self aat_hud("Blast Furnace",  1, 0, 0);
				}
				if(self.weapon_aats[i] == 3)
				{
					self aat_hud("Explosive",  0, 0, 1);
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 1;
					self.has_thunder_wall = 0;
					self.has_headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 0;
				}
				if(self.weapon_aats[i] == 4)
				{
					self aat_hud("Headcutter",  1, 0, 1);
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_headcutter = 1;
					self.has_cluster = 0;
					self.has_turned = 0;
				}
				if(self.weapon_aats[i] == 5)
				{
					self aat_hud("Cluster", (0.4, 0.4, 0.2));
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_headcutter = 0;
					self.has_cluster = 1;
					self.has_turned = 0;
				}
				if(self.weapon_aats[i] == 6)
				{
					self aat_hud("Turned", (1, 0.5, 0.5));
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 0;
					self.has_headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 1;
				}
				if(self.weapon_aats[i] == 7)
				{
					self aat_hud("Thunder Wall",  0, 1, 1);
					self.has_fireworks = 0;
					self.has_blast_furnace = 0;
					self.has_explosive_bullets = 0;
					self.has_thunder_wall = 1;
					self.has_headcutter = 0;
					self.has_cluster = 0;
					self.has_turned = 0;
				}
			}
		}
		if(self getcurrentweapon() != self.aat_weapon[0] && self getcurrentweapon() != self.aat_weapon[1] && self getcurrentweapon() != self.aat_weapon[2])
		{
			self.has_thunder_wall = 0;
			self.has_fireworks = 0;
			self.has_blast_furnace = 0;
			self.has_explosive_bullets = 0;
			self.has_headcutter = 0;
			self.has_cluster = 0;
			self.has_turned = 0;
		}
	}
}

/*
	Name: actor_damage_override_wrapper
	Namespace: forest
	Checksum: 0xDA8EAB0E
	Offset: 0x950C
	Size: 0x79
	Parameters: 11
	Flags: None
*/
actor_damage_override_wrapper(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	damage_override = self actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	if(self.health - damage_override > 0 || !is_true(self.dont_die_on_me))
	{
		self finishactordamage(inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	}
}

/*
	Name: actor_damage_override
	Namespace: forest
	Checksum: 0xD38E8082
	Offset: 0x9586
	Size: 0x413
	Parameters: 11
	Flags: None
*/
actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if(isdefined(self.is_avogadro) && self.is_avogadro)
	{
		return [[level.original_damagecallback]](inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	}
	if(isdefined(attacker.weaponname))
	{
		if(!isdefined(self.is_turned))
		{
			self.is_turned = 0;
		}
		if(attacker != self && self.is_turned)
		{
			return 0;
		}
		if(isdefined(attacker) && isplayer(attacker) && (!attacker.cooldown && meansofdeath != "MOD_MELEE") && (meansofdeath != "MOD_IMPACT" && weapon != "knife_zm"))
		{
			aat_cooldown_time = randomintrange(10, 16);
			aat_activation = randomintrange(1, 11);
			if(isdefined(self.is_avogadro) && self.is_avogadro || (isdefined(self.is_brutus) && self.is_brutus) || (isdefined(self.is_mechz) && self.is_mechz))
			{
			}
			else
			{
				zombies = getaiarray(level.zombie_team);
				if(meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_GRENADE_SPLASH" || (meansofdeath == "MOD_EXPLOSIVE" || meansofdeath == "MOD_PROJECTILE"))
				{
					if(is_weapon_upgraded(weapon))
					{
					}
					else
					{
						return damage;
					}
				}
				if(self turned_zombie_validation() && attacker.has_turned && !attacker.active_turned)
				{
					turned = aat_activation;
					if(turned == 1)
					{
						attacker.aat_actived = 1;
						attacker thread cool_down(aat_cooldown_time);
						self thread turned(attacker);
						idamage = 1;
						return idamage;
					}
				}
				if(attacker.has_cluster)
				{
					cluster = aat_activation;
					if(cluster == 1)
					{
						attacker.aat_actived = 1;
						attacker thread cool_down(aat_cooldown_time);
						attacker thread cluster(self);
					}
				}
				if(attacker.has_headcutter)
				{
					headcutter = aat_activation;
					if(headcutter == 1)
					{
						attacker.aat_actived = 1;
						attacker thread cool_down(aat_cooldown_time);
						for(i = 0; i < zombies.size; i++)
						{
							if(distance(self.origin, zombies[i].origin) <= 200)
							{
								if(!zombies[i].done)
								{
									zombies[i].done = 1;
									zombies[i] thread headcutter(attacker);
								}
							}
						}
					}
				}
				else if(attacker.has_thunder_wall)
				{
					thunder_wall = aat_activation;
					if(thunder_wall == 1)
					{
						attacker setclientdvar("ragdoll_enable", 1);
						attacker.aat_actived = 1;
						self thread thunderwall(attacker);
						attacker thread cool_down(aat_cooldown_time);
					}
				}
				if(attacker.has_blast_furnace)
				{
					blast_furnace = aat_activation;
					if(blast_furnace == 1)
					{
						attacker.aat_actived = 1;
						attacker thread cool_down(aat_cooldown_time);
						flamefx = loadfx("env/fire/fx_fire_zombie_torso");
						playfxontag(flamefx, self, "j_spinelower");
						flamefx2 = loadfx("env/fire/fx_fire_zombie_md");
						playfxontag(flamefx2, self, "j_spineupper");
						for(i = 0; i < zombies.size; i++)
						{
							if(distance(self.origin, zombies[i].origin) <= 220)
							{
								zombies[i] thread flames_fx();
							}
						}
					}
				}
				else if(attacker.has_fireworks)
				{
					fireworks = aat_activation;
					if(fireworks == 1)
					{
						attacker.aat_actived = 1;
						attacker thread cool_down(aat_cooldown_time);
						origin = self.origin;
						weapon = attacker getcurrentweapon();
						self thread spawn_weapon(origin, weapon, attacker);
						self thread fireworks(origin);
						self dodamage(1, self.origin, attacker, attacker, "none", "MOD_IMPACT");
					}
				}
			}
		}
	}
	return int(damage);
}

/*
	Name: cool_down
	Namespace: forest
	Checksum: 0xC08FF904
	Offset: 0x999A
	Size: 0x15
	Parameters: 1
	Flags: None
*/
cool_down(time)
{
	self.cooldown = 1;
	wait(time);
	self.cooldown = 0;
}

/*
	Name: explosive_bullet
	Namespace: forest
	Checksum: 0xB5EFD3C4
	Offset: 0x99B0
	Size: 0x1D8
	Parameters: 0
	Flags: None
*/
explosive_bullet()
{
	self endon("disconnect");
	level endon("end_game");
	self.active_explosive_bullet = 1;
	for(;;)
	{
		self waittill("weapon_fired");
		explosive = randomintrange(1, 5);
		if(explosive == 1 && self.has_explosive_bullets && !self.cooldown)
		{
			self.aat_actived = 1;
			self thread cool_down(randomintrange(5, 11));
			forward = self gettagorigin("tag_weapon_right");
			end = self thread vector_scal(AnglesToForward(self getplayerangles()), 1000000);
			crosshair_entity = bullettrace(self gettagorigin("tag_weapon_right"), self gettagorigin("tag_weapon_right") + AnglesToForward(self getplayerangles()) * 1000000, 1, self)["entity"];
			crosshair = bullettrace(forward, end, 0, self)["position"];
			magicbullet(self getcurrentweapon(), self gettagorigin("j_shouldertwist_le"), crosshair, self);
			self enableinvulnerability();
			if(isdefined(crosshair_entity))
			{
				crosshair_entity playsound("zmb_phdflop_explo");
				playfx(loadfx("explosions/fx_default_explosion"), crosshair_entity.origin, AnglesToForward((0, 45, 55)));
				radiusdamage(crosshair_entity.origin, 300, 5000, 1000, self);
			}
			else
			{
				crosshair playsound("zmb_phdflop_explo");
				playfx(loadfx("explosions/fx_default_explosion"), crosshair, AnglesToForward((0, 45, 55)));
				radiusdamage(crosshair, 300, 5000, 1000, self);
			}
			wait(0.5);
			self disableinvulnerability();
		}
		wait(0.1);
	}
}

/*
	Name: flames_fx
	Namespace: forest
	Checksum: 0xE589FE31
	Offset: 0x9B8A
	Size: 0x74
	Parameters: 0
	Flags: None
*/
flames_fx()
{
	level endon("end_game");
	for(i = 0; i < 5; i++)
	{
		flamefx = loadfx("env/fire/fx_fire_zombie_torso");
		playfxontag(flamefx, self, "j_spineupper");
		if(i < 3)
		{
			self dodamage(self.health / 2,  0, 0, 0);
		}
		else
		{
			self dodamage(self.maxhealth * 2,  0, 0, 0);
		}
		wait(1);
	}
}

/*
	Name: fireworks
	Namespace: forest
	Checksum: 0x952A64B5
	Offset: 0x9C00
	Size: 0x94
	Parameters: 1
	Flags: None
*/
fireworks(origin)
{
	level endon("end_game");
	for(i = 0; i < 5; i++)
	{
		up_in_air = origin + (0, 0, 65);
		firework = spawn("script_model", origin);
		firework setmodel("tag_origin");
		fx = playfxontag(level._effect["richtofen_sparks"], firework, "tag_origin");
		firework moveto(up_in_air, 1);
		wait(1);
		firework delete();
		fx delete();
	}
}

/*
	Name: spawn_weapon
	Namespace: forest
	Checksum: 0x204F822C
	Offset: 0x9C96
	Size: 0x127
	Parameters: 3
	Flags: None
*/
spawn_weapon(origin, weapon, attacker)
{
	level endon("end_game");
	attacker.firework_weapon = spawnentity("script_model", getweaponmodel(weapon), origin + (0, 0, 45),  0, 0, 0 + (0, 50, 0));
	for(i = 0; i < 100; i++)
	{
		zombies = get_array_of_closest(attacker.firework_weapon.origin, getaiarray(level.zombie_team), undefined, undefined, 300);
		forward = attacker.firework_weapon.origin;
		end = zombies[0] gettagorigin("j_spineupper");
		crosshair = bullettrace(forward, end, 0, self)["position"];
		attacker.firework_weapon.angles = VectorToAngles(end - attacker.firework_weapon.origin);
		if(distance(zombies[0].origin, attacker.firework_weapon.origin) <= 300)
		{
			magicbullet(weapon, attacker.firework_weapon.origin, crosshair, attacker.firework_weapon);
		}
		wait(0.05);
	}
	attacker.firework_weapon delete();
}

/*
	Name: spawnentity
	Namespace: forest
	Checksum: 0xF005451D
	Offset: 0x9DBE
	Size: 0x36
	Parameters: 4
	Flags: None
*/
spawnentity(class, model, origin, angle)
{
	entity = spawn(class, origin);
	entity.angles = angle;
	entity setmodel(model);
	return entity;
}

/*
	Name: thunderwall
	Namespace: forest
	Checksum: 0xC48DF8A
	Offset: 0x9DF6
	Size: 0x160
	Parameters: 1
	Flags: None
*/
thunderwall(attacker)
{
	thunder_wall_blast_pos = self.origin;
	ai_zombies = get_array_of_closest(thunder_wall_blast_pos, getaiarray(level.zombie_team), undefined, undefined, 250);
	if(!isdefined(ai_zombies))
	{
		return;
	}
	flung_zombies = 0;
	max_zombies = undefined;
	max_zombies = randomintrange(5, 25);
	for(i = 0; i < ai_zombies.size; i++)
	{
		if(isdefined(ai_zombies[i].is_avogadro) && ai_zombies[i].is_avogadro || (isdefined(ai_zombies[i].is_brutus) && ai_zombies[i].is_brutus) || (isdefined(ai_zombies[i].is_mechz) && ai_zombies[i].is_mechz))
		{
			continue;
		}
		n_random_x = randomfloatrange(-3, 3);
		n_random_y = randomfloatrange(-3, 3);
		ai_zombies[i] startragdoll(1);
		ai_zombies[i] launchragdoll((0, 0, 150));
		playfxontag(level._effect["jetgun_smoke_cloud"], ai_zombies[i], "J_SpineUpper");
		ai_zombies[i] dodamage(ai_zombies[i].health * 2, ai_zombies[i].origin, attacker, attacker, "none", "MOD_IMPACT");
		flung_zombies++;
		if(flung_zombies >= max_zombies)
		{
			break;
		}
	}
}

/*
	Name: headcutter
	Namespace: forest
	Checksum: 0xF57B468
	Offset: 0x9F58
	Size: 0x48
	Parameters: 1
	Flags: None
*/
headcutter(attacker)
{
	self endon("death");
	level endon("end_game");
	self maps\mp\zombies\_zm_spawner::zombie_head_gib();
	for(;;)
	{
		wait(1);
		damage = 100 * level.round_number;
		self dodamage(damage, self.origin, attacker, attacker, "none", "MOD_IMPACT");
	}
}

/*
	Name: cluster
	Namespace: forest
	Checksum: 0xE9341F30
	Offset: 0x9FA2
	Size: 0xAE
	Parameters: 1
	Flags: None
*/
cluster(zombie)
{
	self endon("disconnect");
	level endon("end_game");
	if(level.round_number < 10)
	{
		amount = randomintrange(1, level.round_number * 2);
	}
	else
	{
		amount = randomintrange(7, level.round_number);
	}
	random_x = randomfloatrange(-3, 3);
	random_y = randomfloatrange(-3, 3);
	for(i = 0; i < amount; i++)
	{
		self magicgrenadetype("frag_grenade_zm", zombie.origin + (random_x, random_y, 10), (random_x, random_y, 0), 2);
		wait(0.1);
	}
}

/*
	Name: turned
	Namespace: forest
	Checksum: 0xE07C0174
	Offset: 0xA052
	Size: 0x277
	Parameters: 1
	Flags: None
*/
turned(attacker)
{
	level endon("end_game");
	self.is_turned = 1;
	attacker.active_turned = 1;
	turned_zombie_kills = 0;
	max_kills = randomintrange(15, 21);
	self thread set_zombie_run_cycle("sprint");
	self.custom_goalradius_override = 1000000;
	turned_icon = newhudelem();
	turned_icon.x = self.origin[0];
	turned_icon.y = self.origin[1];
	turned_icon.z = self.origin[2] + (0, 0, 80);
	turned_icon.color =  0, 1, 0;
	turned_icon.isshown = 1;
	turned_icon.archived = 0;
	turned_icon setshader("hud_status_dead", 4, 4);
	turned_icon setwaypoint(1);
	enemyoverride = [];
	self.team = level.players;
	self.ignore_enemy_count = 1;
	self.ignore_nuke = 1;
	attackanim = "zm_riotshield_melee";
	if(!self.has_legs)
	{
		attackanim = attackanim + "_crawl";
	}
	while(isalive(self))
	{
		turned_icon.x = self.origin[0];
		turned_icon.y = self.origin[1];
		turned_icon.z = self.origin[2] + (0, 0, 80);
		ai_zombies = get_array_of_closest(self.origin, getaiarray(level.zombie_team), undefined, undefined, undefined);
		if(isdefined(ai_zombies[1]))
		{
			enemyoverride[0] = ai_zombies[1].origin;
			enemyoverride[1] = ai_zombies[1];
		}
		else
		{
			enemyoverride[0] = ai_zombies[0].origin;
			enemyoverride[1] = ai_zombies[0];
		}
		self.enemyoverride = enemyoverride;
		if(distance(self.origin, ai_zombies[1].origin) < 40 && isalive(ai_zombies[1]))
		{
			angles = VectorToAngles(ai_zombies[1].origin - self.origin);
			self animscripted(self.origin, angles, attackanim);
			ai_zombies[1] dodamage(ai_zombies[1].maxhealth * 2, ai_zombies[1].origin);
			turned_zombie_kills++;
			if(turned_zombie_kills > max_kills)
			{
				self dodamage(self.maxhealth * 2, self.origin);
			}
			wait(1);
		}
		else
		{
			self stopanimscripted();
		}
		wait(0.05);
	}
	attacker.active_turned = 0;
	self.is_turned = 0;
	turned_icon destroy();
}

/*
	Name: turned_zombie
	Namespace: forest
	Checksum: 0x1EE3C5CE
	Offset: 0xA2CA
	Size: 0x24
	Parameters: 0
	Flags: None
*/
turned_zombie()
{
	if(self.is_turned)
	{
	}
	else
	{
		zombie_poi = self get_zombie_point_of_interest(self.origin);
	}
	return zombie_poi;
}

/*
	Name: turned_zombie_validation
	Namespace: forest
	Checksum: 0xE458E68F
	Offset: 0xA2F0
	Size: 0x65
	Parameters: 0
	Flags: None
*/
turned_zombie_validation()
{
	if(is_true(self.barricade_enter))
	{
		return 0;
	}
	if(is_true(self.is_traversing))
	{
		return 0;
	}
	if(!is_true(self.completed_emerging_into_playable_area))
	{
		return 0;
	}
	if(is_true(self.is_leaping))
	{
		return 0;
	}
	if(is_true(self.is_inert))
	{
		return 0;
	}
	return 1;
}

/*
	Name: is_true
	Namespace: forest
	Checksum: 0x7EE0171F
	Offset: 0xA356
	Size: 0xD
	Parameters: 1
	Flags: None
*/
is_true(check)
{
	return isdefined(check) && check;
}

/*
	Name: wunderfizzperklist
	Namespace: forest
	Checksum: 0x848C6CC
	Offset: 0xA364
	Size: 0x98
	Parameters: 0
	Flags: None
*/
wunderfizzperklist()
{
	perks = [];
	perks[perks.size] = "Downers_Delight";
	perks[perks.size] = "WIDOWS_WINE";
	perks[perks.size] = "Ethereal_Razor";
	perks[perks.size] = "Ammo_Regen";
	perks[perks.size] = "Dying_Wish";
	perks[perks.size] = "MULE";
	perks[perks.size] = "ELECTRIC_CHERRY";
	perks[perks.size] = "PHD_FLOPPER";
	perks[perks.size] = "deadshot";
	perks[perks.size] = "specialty_armorvest";
	perks[perks.size] = "specialty_rof";
	perks[perks.size] = "specialty_fastreload";
	perks[perks.size] = "specialty_longersprint";
	perks[perks.size] = "specialty_quickrevive";
	return perks;
}

/*
	Name: getperkname
	Namespace: forest
	Checksum: 0x55E41133
	Offset: 0xA3FE
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
getperkname(perk)
{
	if(perk == "Downers_Delight")
	{
		return "Downer's Delight";
	}
	if(perk == "Victorious_Tortoise")
	{
		return "Victorious Tortoise";
	}
	if(perk == "WIDOWS_WINE")
	{
		return "Widow's Wine";
	}
	if(perk == "Ethereal_Razor")
	{
		return "Ethereal Razor";
	}
	if(perk == "Ammo_Regen")
	{
		return "Ammo Regen";
	}
	if(perk == "Dying_Wish")
	{
		return "Dying Wish";
	}
	if(perk == "MULE")
	{
		return "Mule Kick";
	}
	if(perk == "ELECTRIC_CHERRY")
	{
		return "Electric Cherry";
	}
	if(perk == "PHD_FLOPPER")
	{
		return "PhD Flopper";
	}
	if(perk == "deadshot")
	{
		return "Deadshot";
	}
	if(perk == "specialty_armorvest")
	{
		return "Juggernog";
	}
	if(perk == "specialty_rof")
	{
		return "Double Tap";
	}
	if(perk == "specialty_longersprint")
	{
		return "Stamin-Up";
	}
	if(perk == "specialty_fastreload")
	{
		return "Speed Cola";
	}
	if(perk == "specialty_additionalprimaryweapon")
	{
		return "Mule Kick";
	}
	if(perk == "specialty_quickrevive")
	{
		return "Quick Revive";
	}
	if(perk == "specialty_grenadepulldeath")
	{
		return "Electric Cherry";
	}
	if(perk == "specialty_flakjacket")
	{
		return "PHD Flopper";
	}
	if(perk == "specialty_deadshot")
	{
		return "Deadshot Daiquiri";
	}
}

/*
	Name: getperkbottlemodel
	Namespace: forest
	Checksum: 0x6FDD7E8C
	Offset: 0xA50E
	Size: 0xE5
	Parameters: 1
	Flags: None
*/
getperkbottlemodel(perk)
{
	if(perk == "Downers_Delight")
	{
		return "t6_wpn_zmb_perk_bottle_jugg_world";
	}
	if(perk == "Victorious_Tortoise")
	{
		return "t6_wpn_zmb_perk_bottle_jugg_world";
	}
	if(perk == "WIDOWS_WINE")
	{
		return "t6_wpn_zmb_perk_bottle_jugg_world";
	}
	if(perk == "Ethereal_Razor")
	{
		return "t6_wpn_zmb_perk_bottle_jugg_world";
	}
	if(perk == "Ammo_Regen")
	{
		return "t6_wpn_zmb_perk_bottle_jugg_world";
	}
	if(perk == "Dying_Wish")
	{
		return "t6_wpn_zmb_perk_bottle_jugg_world";
	}
	if(perk == "specialty_armorvest")
	{
		return "t6_wpn_zmb_perk_bottle_jugg_world";
	}
	if(perk == "specialty_rof")
	{
		return "t6_wpn_zmb_perk_bottle_doubletap_world";
	}
	if(perk == "specialty_longersprint")
	{
		return "t6_wpn_zmb_perk_bottle_marathon_world";
	}
	if(perk == "specialty_fastreload")
	{
		return "t6_wpn_zmb_perk_bottle_sleight_world";
	}
	if(perk == "specialty_flakjacket")
	{
		return "t6_wpn_zmb_perk_bottle_nuke_world";
	}
	if(perk == "specialty_quickrevive")
	{
		return "t6_wpn_zmb_perk_bottle_revive_world";
	}
	if(perk == "specialty_scavenger")
	{
		return "t6_wpn_zmb_perk_bottle_tombstone_world";
	}
	if(perk == "specialty_grenadepulldeath")
	{
		return "t6_wpn_zmb_perk_bottle_cherry_world";
	}
	if(perk == "specialty_additionalprimaryweapon")
	{
		return "t6_wpn_zmb_perk_bottle_mule_kick_world";
	}
	if(perk == "specialty_deadshot")
	{
		return "t6_wpn_zmb_perk_bottle_deadshot_world";
	}
}

/*
	Name: wunderfizzsetup
	Namespace: forest
	Checksum: 0x9651C1D9
	Offset: 0xA5F4
	Size: 0x285
	Parameters: 2
	Flags: None
*/
wunderfizzsetup(origin, angles)
{
	newmodeltable = spawn("script_model", origin - (0, 0, 20));
	newmodeltable.angles = (0, -90, 0);
	newmodeltable setmodel("p6_table_bunker_sm");
	bucket = spawn("script_model", origin);
	bucket.angles = angles;
	bucket setmodel("p_glo_bucket_metal");
	bottle = spawn("script_model", origin + (0, 0, 13));
	bottle.angles = (0, 90, 0);
	bottle setmodel("t6_wpn_zmb_perk_bottle_doubletap_world");
	bottle1 = spawn("script_model", origin + (3, 3, 10));
	bottle1.angles = (4, 90, 0);
	bottle1 setmodel("t6_wpn_zmb_perk_bottle_revive_world");
	bottle2 = spawn("script_model", origin + (0, 0, 12) - (3, 3, 0));
	bottle2.angles = (-10, 90, -4);
	bottle2 setmodel("t6_wpn_zmb_perk_bottle_tombstone_world");
	bottle3 = spawn("script_model", origin + (0, 3, 11) - (3, 0, 0));
	bottle3.angles = (4, 90, 0);
	bottle3 setmodel("t6_wpn_zmb_perk_bottle_jugg_world");
	bottle4 = spawn("script_model", origin + (3, 0, 11) - (0, 3, 0));
	bottle4.angles = (-6, 90, 0);
	bottle4 setmodel("t6_wpn_zmb_perk_bottle_sleight_world");
	collision = spawn("script_model", origin);
	collision setmodel("zm_collision_perks1");
	collision.angles = angles;
	wunderfizzbottle = spawn("script_model", origin);
	wunderfizzbottle setmodel("tag_origin");
	wunderfizzbottle.angles = angles;
	wunderfizzbottle.origin = wunderfizzbottle.origin + VectorScale( 0, 0, 1, 55);
	bucket.bottle = wunderfizzbottle;
	perks = wunderfizzperklist();
	cost = 2000;
	trig = spawn("trigger_radius", origin, 1, 50, 50);
	trig setcursorhint("HINT_NOICON");
	trig sethintstring("Hold ^3&&1^7 to buy Perk-a-Cola [Cost: " + cost + "]");
	bucket thread wunderfizz(origin, angles, cost, perks, trig, wunderfizzbottle, bottle);
	playfxontag(loadfx("misc/fx_zombie_cola_dtap_on"), bucket, "tag_origin");
}

/*
	Name: wunderfizz
	Namespace: forest
	Checksum: 0xD045274A
	Offset: 0xA87A
	Size: 0x342
	Parameters: 7
	Flags: None
*/
wunderfizz(origin, angles, cost, perks, trig, wunderfizzbottle, bottle)
{
	level endon("end_game");
	for(;;)
	{
		trig waittill("trigger", player);
		possibleperklist = player hasallwunderfizzperks(perks);
		if(player usebuttonpressed() && player.score >= cost && (player.num_perks < level.perk_purchase_limit && possibleperklist.size > 0))
		{
			player playsound("zmb_cha_ching");
			fx_obj = spawn("script_model", origin + (0, 0, 10));
			fx_obj setmodel("tag_origin");
			fx = playfxontag(loadfx("maps/zombie/fx_zmb_race_trail_grief"), fx_obj, "TAG_ORIGIN");
			player.score = player.score - cost;
			trig sethintstring(" ");
			self thread perk_bottle_motion();
			wait(0.1);
			bottle setmodel("tag_origin");
			for(rtime = 3; rtime > 0;  = 3)
			{
				modelperk = perks[randomint(perks.size)];
				self.bottle setmodel(getperkbottlemodel(modelperk));
				wait(0.2);
			}
			possibleperklist = player hasallwunderfizzperks(perks);
			modelperk = possibleperklist[randomint(possibleperklist.size)];
			self.bottle setmodel(getperkbottlemodel(modelperk));
			perkname = getperkname(modelperk);
			trig sethintstring("Hold ^3&&1^7 for " + perkname);
			self.bottle setmodel(getperkbottlemodel(modelperk));
			self notify("done_cycling", rtime - 0.2);
			for(rtime = 7; rtime > 0;  = 7)
			{
				if(player usebuttonpressed() && player can_buy() && (!player hascustomperk(modelperk) && !player hasperk(modelperk)) && possibleperklist.size > 0)
				{
					if(!iscustomperk(modelperk))
					{
						player thread dogiveperk(modelperk);
						break;
					}
					else
					{
						player thread drawshader_and_shadermove(modelperk, 1, 1);
						break;
					}
				}
				wait(0.2);
			}
			self.bottle setmodel("tag_origin");
			fx_obj delete();
			fx delete();
			trig sethintstring(" ");
			bottle setmodel("t6_wpn_zmb_perk_bottle_doubletap_world");
			wait(2);
			trig sethintstring("Hold ^3&&1^7 to buy Perk-a-Cola [Cost: " + cost + "]");
		}
		else if(player usebuttonpressed() && player.score >= cost && possibleperklist.size <= 0)
		{
			player iprintln("you have all perks!");
			wait(1);
		}
		else if(player usebuttonpressed() && player.score < cost)
		{
			player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 0);
		}
		wait(0.1);
	}
}

/*
	Name: hasallwunderfizzperks
	Namespace: forest
	Checksum: 0x13929788
	Offset: 0xABBE
	Size: 0x57
	Parameters: 1
	Flags: None
*/
hasallwunderfizzperks(perklist)
{
	possiblelist = [];
	for(i = 0; i < perklist.size; i++)
	{
		if(!self hascustomperk(perklist[i]) && !self hasperk(perklist[i]))
		{
			possiblelist[possiblelist.size] = perklist[i];
		}
	}
	return possiblelist;
}

/*
	Name: hascustomperk
	Namespace: forest
	Checksum: 0x3B0147D
	Offset: 0xAC16
	Size: 0x34
	Parameters: 1
	Flags: None
*/
hascustomperk(perk)
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		if(self.perkarray[i].name == perk)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: perk_bottle_motion
	Namespace: forest
	Checksum: 0xDFD78880
	Offset: 0xAC4C
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
perk_bottle_motion()
{
	putouttime = 3;
	putbacktime = 20;
	self.bottle.origin = self.origin + (0, 0, 15);
	self.bottle.angles = (0, 90, 0);
	self.bottle moveto(self.bottle.origin + (0, 0, 12), putouttime, 1.5);
	self.bottle.angles = self.bottle.angles + (0, 0, 10);
	self.bottle rotateyaw(720, putouttime, 1.5);
	self waittill("done_cycling");
	self.bottle.angles = (0, 90, 0);
	wait(1.5);
	self.bottle moveto(self.bottle.origin - (0, 0, 50), putbacktime, 1);
	self.bottle rotateyaw(90, putbacktime, 1.5);
}

/*
	Name: iscustomperk
	Namespace: forest
	Checksum: 0x63854ADD
	Offset: 0xAD26
	Size: 0x7A
	Parameters: 1
	Flags: None
*/
iscustomperk(perk)
{
	switch(perk)
	{
		case "specialty_armorvest":
		case "specialty_rof":
		case "specialty_fastreload":
		case "specialty_longersprint":
		case "specialty_quickrevive":
		case "specialty_deadshot":
		case "specialty_grenadepulldeath":
		case "specialty_flakjacket":
		case "specialty_additionalprimaryweapon":
		case "specialty_scavenger":
		case "specialty_finalstand":
		{
			return 0;
		}
		case default:
		{
			return 1;
		}
	}
}

/*
	Name: spawnsm
	Namespace: forest
	Checksum: 0xC2E18916
	Offset: 0xADA2
	Size: 0x3A
	Parameters: 3
	Flags: None
*/
spawnsm(origin, model, angles)
{
	ent = spawn("script_model", origin);
	ent setmodel(model);
	if(isdefined(angles))
	{
		ent.angles = angles;
	}
	return ent;
}

/*
	Name: removeperkshader
	Namespace: forest
	Checksum: 0xA089092D
	Offset: 0xADDE
	Size: 0x70
	Parameters: 0
	Flags: None
*/
removeperkshader()
{
	self endon("disconnect");
	level endon("end_game");
	for(;;)
	{
		self waittill_any_return("fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death");
		self.num_perks = 0;
		self.perk_reminder = 0;
		self.perk_count = 0;
		self.dying_wish_on_cooldown = 0;
		self removeallcustomshader();
		self.perkarray = [];
		self notify("stopcustomperk");
		self.bleedout_time = 30;
		self.ignore_lava_damage = 0;
	}
}

/*
	Name: removeallcustomshader
	Namespace: forest
	Checksum: 0xD4AD8056
	Offset: 0xAE50
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
removeallcustomshader()
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		self.perkarray[i] destroy();
	}
}

/*
	Name: perkboughtcheck
	Namespace: forest
	Checksum: 0x8A614771
	Offset: 0xAE7E
	Size: 0x7E
	Parameters: 0
	Flags: None
*/
perkboughtcheck()
{
	self endon("death");
	self endon("disconnect");
	level endon("end_game");
	for(;;)
	{
		self.perk_reminder = self.num_perks;
		self waittill("perk_acquired");
		n = 1;
		if(!self.num_perks > self.perk_reminder)
		{
			n = self.num_perks - self.perk_reminder;
			self.num_perks = self.perk_reminder + n;
		}
		self.perk_reminder = self.num_perks;
		self.perk_count = self.perk_count + n;
		self drawshader_and_shadermove("none", 0, 0);
	}
}

/*
	Name: drawshader
	Namespace: forest
	Checksum: 0xF5C42C1F
	Offset: 0xAEFE
	Size: 0xB0
	Parameters: 7
	Flags: None
*/
drawshader(shader, width, height, color, alpha, sort, foreground)
{
	if(!isdefined(self.perks_active))
	{
		self.perks_active = [];
	}
	hud = create_simple_hud(self);
	hud setshader(shader, width, height);
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.foreground = foreground;
	hud.hidewheninmenu = 1;
	hud.horzalign = "user_left";
	hud.vertalign = "user_center";
	hud.x = 5.5 + self.perks_active.size * 30;
	hud.y = 146.5;
	return hud;
}

/*
	Name: drawshader_and_shadermove
	Namespace: forest
	Checksum: 0xBF051F68
	Offset: 0xAFB0
	Size: 0x7C5
	Parameters: 3
	Flags: None
*/
drawshader_and_shadermove(perk, custom, print)
{
	if(custom)
	{
		self allowprone(0);
		self allowsprint(0);
		self disableoffhandweapons();
		self disableweaponcycling();
		weapona = self getcurrentweapon();
		weaponb = "zombie_perk_bottle_jugg";
		self giveweapon(weaponb);
		self switchtoweapon(weaponb);
		self waittill("weapon_change_complete");
		self enableoffhandweapons();
		self enableweaponcycling();
		self takeweapon(weaponb);
		self switchtoweapon(weapona);
		self maps\mp\zombies\_zm_audio::playerexert("burp");
		self setblur(4, 0.1);
		wait(0.1);
		self setblur(0, 0.1);
		self allowprone(1);
		self allowsprint(1);
	}
	for(i = 0; i < self.perkarray.size; i++)
	{
		self.perkarray[i].x = self.perkarray[i].x + 30;
	}
	if(perk == "Downers_Delight")
	{
		self.perk1back = self drawshader("specialty_doubletap_zombies", 24, 24,  0, 0, 0, 100, 0, 0);
		self.perk1front = self drawshader("waypoint_revive", 23, 23,  0, 1, 1, 100, 0, 1);
		self.perk1front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk1front;
		self.perk1back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk1back;
		self.num_perks++;
		self thread ddown();
		if(print)
		{
			self iprintln("^9Downer's Delight");
			wait(0.2);
			self iprintln("This Perk will increase players bleedout time by 10 seconds and current weapons is used in laststand.");
		}
	}
	if(perk == "MULE")
	{
		self.perk2back = self drawshader("specialty_doubletap_zombies", 24, 24,  0, 0, 0, 100, 0, 0);
		self.perk2front = self drawshader("menu_mp_weapons_1911", 22, 22,  0, 1, 0, 100, 0, 1);
		self.perk2front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk2front;
		self.perk2back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk2back;
		self.num_perks++;
		if(print)
		{
			self iprintln("^9Mule Kick");
			wait(0.2);
			self iprintln("This Perk enables additional primary weapon slot for player. ");
		}
	}
	if(perk == "PHD_FLOPPER")
	{
		self.perk3back = self drawshader("specialty_doubletap_zombies", 24, 24,  0, 0, 0, 100, 0, 0);
		self.perk3front = self drawshader("hud_icon_sticky_grenade", 23, 23,  1, 0, 1, 100, 0, 1);
		self.perk3front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk3front;
		self.perk3back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk3back;
		self.num_perks++;
		if(print)
		{
			self iprintln("^9PhD Flopper");
			wait(0.2);
			self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
		}
	}
	if(perk == "ELECTRIC_CHERRY")
	{
		self.perk5back = self drawshader("specialty_doubletap_zombies", 24, 24, (0, 0, 200), 100, 0, 0);
		self.perk5front = self drawshader("zombies_rank_5", 23, 23,  1, 1, 1, 100, 0, 1);
		self.perk5front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk5front;
		self.perk5back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk5back;
		self.num_perks++;
		self thread start_ec();
		if(print)
		{
			self iprintln("^9Electric Cherry");
			wait(0.2);
			self iprintln("This Perk creates an electric shockwave around the player whenever they reload.");
		}
	}
	if(perk == "WIDOWS_WINE")
	{
		self.perk6back = self drawshader("specialty_doubletap_zombies", 24, 24,  0, 0, 0, 100, 0);
		self.perk6front = self drawshader("zombies_rank_3", 23, 23,  1, 1, 1, 100, 0, 1);
		self.perk6front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk6front;
		self.perk6back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk6back;
		self.num_perks++;
		self takeweapon(self get_player_lethal_grenade());
		self set_player_lethal_grenade("sticky_grenade_zm");
		self giveweapon("sticky_grenade_zm");
		self thread ww_nades();
		if(print)
		{
			self iprintln("^9Widow's Wine");
			wait(0.2);
			self iprintln("This Perk damages zombies around the player when player is hit and grenades are upgraded.");
		}
	}
	if(perk == "Ethereal_Razor")
	{
		self.perk7back = self drawshader("specialty_doubletap_zombies", 24, 24, (200, 0, 0), 100, 0);
		self.perk7front = self drawshader("zombies_rank_4", 23, 23,  1, 1, 1, 100, 0, 1);
		self.perk7front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk7front;
		self.perk7back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk7back;
		self.num_perks++;
		self thread start_er();
		if(print)
		{
			self iprintln("^9Ethereal Razor");
			wait(0.2);
			self iprintln("This Perk deals extra damage when player using melee attacks and restores a small amount of health.");
		}
	}
	if(perk == "Ammo_Regen")
	{
		self.perk8back = self drawshader("specialty_doubletap_zombies", 24, 24,  0, 0, 0, 100, 0);
		self.perk8front = self drawshader("menu_mp_lobby_icon_customgamemode", 23, 23,  1, 1, 1, 100, 0, 1);
		self.perk8front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk8front;
		self.perk8back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk8back;
		self.num_perks++;
		self thread ammoregen();
		self thread grenadesregen();
		if(print)
		{
			self iprintln("^9Ammo Regen");
			wait(0.2);
			self iprintln("This Perk will slowly regenerades players ammonation and grenades.");
		}
	}
	if(perk == "Dying_Wish")
	{
		self.perk10back = self drawshader("specialty_doubletap_zombies", 24, 24, (200, 0, 0), 100, 0);
		self.perk10front = self drawshader("zombies_rank_5", 23, 23,  1, 1, 1, 100, 0, 1);
		self.perk10front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk10front;
		self.perk10back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk10back;
		self.num_perks++;
		self thread dying_wish_checker();
		if(print)
		{
			self iprintln("^9Dying Wish");
			wait(0.2);
			self iprintln("This Perk allow player to go berserker mode for 9 seconds instead of laststand.");
			wait(0.1);
			self iprintln(" (cooldown 5mins and it's increased 30sec every time perk is used. - max 10mins) ");
		}
	}
	if(perk == "deadshot")
	{
		self.perk11back = self drawshader("specialty_doubletap_zombies", 24, 24,  0, 0, 0, 100, 0);
		self.perk11front = self drawshader("killiconheadshot", 23, 23,  1, 1, 1, 100, 0, 1);
		self.perk11front.name = perk;
		self.perkarray[self.perkarray.size] = self.perk11front;
		self.perk11back.name = perk;
		self.perkarray[self.perkarray.size] = self.perk11back;
		self.num_perks++;
		if(print)
		{
			self iprintln("^9Deadshot");
			wait(0.2);
			self iprintln("This Perk aims automatically enemys head instead of body.");
		}
	}
}

/*
	Name: ww_points
	Namespace: forest
	Checksum: 0xC6223962
	Offset: 0xB776
	Size: 0x58
	Parameters: 1
	Flags: None
*/
ww_points(player)
{
	for(i = 0; i < 3; i++)
	{
		self maps\mp\zombies\_zm_utility::set_zombie_run_cycle("walk");
		player maps\mp\zombies\_zm_score::add_to_player_score(10);
		playfxontag(level.effect_webfx, self, "j_spineupper");
		self dodamage(250,  0, 0, 0);
		wait(1);
	}
}

/*
	Name: ww_nade_explosion
	Namespace: forest
	Checksum: 0xFBD57F40
	Offset: 0xB7D0
	Size: 0x89
	Parameters: 0
	Flags: None
*/
ww_nade_explosion()
{
	wait(2);
	if(self object_touching_lava())
	{
		self delete();
		return 0;
	}
	zombies = getaiarray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(distance(zombie.origin, self.origin) < 250)
		{
			zombie thread ww_points(self);
		}
	}
	self delete();
}

/*
	Name: ww_nades
	Namespace: forest
	Checksum: 0x3A7F520D
	Offset: 0xB85A
	Size: 0x66
	Parameters: 0
	Flags: None
*/
ww_nades()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapname);
		if(weapname == "sticky_grenade_zm")
		{
			ww_nade = spawnsm(grenade.origin, "zombie_bomb");
			ww_nade hide();
			ww_nade linkto(grenade);
			ww_nade thread ww_nade_explosion();
		}
	}
}

/*
	Name: laststand
	Namespace: forest
	Checksum: 0xF6E349C6
	Offset: 0xB8C2
	Size: 0x53
	Parameters: 0
	Flags: None
*/
laststand()
{
	if(self hascustomperk("Downers_Delight"))
	{
		self.customlaststandweapon = self getcurrentweapon();
		self switchtoweapon(self.customlaststandweapon);
		self setweaponammoclip(self.customlaststandweapon, 150);
		self.bleedout_time = 40;
	}
	else
	{
		self maps\mp\zombies\_zm::last_stand_pistol_swap();
	}
}

/*
	Name: ddown
	Namespace: forest
	Checksum: 0xD772A97C
	Offset: 0xB916
	Size: 0x66
	Parameters: 0
	Flags: None
*/
ddown()
{
	self endon("disconnect");
	level endon("end_game");
	self endon("stopcustomperk");
	for(;;)
	{
		self waittill("player_downed");
		self playsound("zmb_phdflop_explo");
		playfx(loadfx("explosions/fx_default_explosion"), self.origin, AnglesToForward((0, 45, 55)));
		radiusdamage(self.origin, 100, 200, 100, self);
		wait(0.1);
	}
}

/*
	Name: start_ec
	Namespace: forest
	Checksum: 0x45F5A11C
	Offset: 0xB97E
	Size: 0x72
	Parameters: 0
	Flags: None
*/
start_ec()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		self waittill("reload_start");
		playfxontag(level._effect["poltergeist"], self, "J_SpineUpper");
		self playsound("zmb_turbine_explo");
		self enableinvulnerability();
		radiusdamage(self.origin, 90, 220, 120, self);
		self disableinvulnerability();
		wait(1);
	}
}

/*
	Name: start_er
	Namespace: forest
	Checksum: 0x27DA33F8
	Offset: 0xB9F2
	Size: 0x12A
	Parameters: 0
	Flags: None
*/
start_er()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	while(self hascustomperk("Ethereal_Razor") && self ismeleeing())
	{
		foreach(zombie in getaiarray(level.zombie_team))
		{
			if(distance(self.origin, zombie.origin) <= 100)
			{
				if(self is_insta_kill_active())
				{
					zombie dodamage(zombie.health + 666,  0, 0, 0);
				}
				zombie dodamage(500,  0, 0, 0);
				if(zombie.health <= 0)
				{
					self maps\mp\zombies\_zm_score::add_to_player_score(100);
					self.kills++;
					continue;
				}
				self maps\mp\zombies\_zm_score::add_to_player_score(10);
			}
		}
		self.health = self.health + 10;
		if(self.health > self.maxhealth)
		{
			self.health = self.maxhealth;
		}
		while(self ismeleeing())
		{
			wait(0.1);
		}
		wait(0.05);
	}
}

/*
	Name: dying_wish_checker
	Namespace: forest
	Checksum: 0x8D740087
	Offset: 0xBB1E
	Size: 0xA2
	Parameters: 0
	Flags: None
*/
dying_wish_checker()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	self.dying_wish_uses = 0;
	for(;;)
	{
		self.dying_wish_on_cooldown = 0;
		self.perk10back.alpha = 1;
		self.perk10front.alpha = 1;
		self waittill("dying_wish_charge");
		self iprintln("Dying wish saved you!");
		self.perk10back.alpha = 0.3;
		self.perk10front.alpha = 0.4;
		self.dying_wish_uses++;
		self.dying_wish_on_cooldown = 1;
		delay = 300 + self.dying_wish_uses * 30;
		if(delay >= 600)
		{
			delay = 600;
		}
		wait(delay);
	}
}

/*
	Name: dying_wish_effect
	Namespace: forest
	Checksum: 0x81EF43E4
	Offset: 0xBBC2
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
dying_wish_effect()
{
	self enableinvulnerability();
	self.ignoreme = 1;
	self useservervisionset(1);
	self setvisionsetforplayer("zombie_death", 0);
	self freezecontrols(1);
	wait(1);
	self freezecontrols(0);
	wait(8);
	self.health = 1;
	self disableinvulnerability();
	self.ignoreme = 0;
	self useservervisionset(0);
	self setvisionsetforplayer("remote_mortar_enhanced", 0);
}

/*
	Name: ammoregen
	Namespace: forest
	Checksum: 0x6D26CB01
	Offset: 0xBC42
	Size: 0x66
	Parameters: 0
	Flags: None
*/
ammoregen()
{
	self endon("disconnect");
	level endon("end_game");
	self endon("stopcustomperk");
	while(!self getcurrentweapon() == "claymore_zm")
	{
		stockcount = self getweaponammostock(self getcurrentweapon());
		self setweaponammostock(self getcurrentweapon(), stockcount + 1);
		wait(2);
		wait(0.1);
	}
}

/*
	Name: grenadesregen
	Namespace: forest
	Checksum: 0x69C4B3F7
	Offset: 0xBCAA
	Size: 0x92
	Parameters: 0
	Flags: None
*/
grenadesregen()
{
	self endon("disconnect");
	level endon("end_game");
	self endon("stopcustomperk");
	for(;;)
	{
		grenades = self get_player_lethal_grenade();
		grenade_count = self getweaponammoclip(grenades);
		if(grenade_count < 4)
		{
			self setweaponammoclip(grenades, grenade_count + 1);
		}
		tactical_grenades = self get_player_tactical_grenade();
		tactical_grenade_count = self getweaponammoclip(tactical_grenades);
		if(tactical_grenade_count < 3)
		{
			self setweaponammoclip(tactical_grenades, tactical_grenade_count + 1);
		}
		wait(300);
	}
}

/*
	Name: aimassist
	Namespace: forest
	Checksum: 0xE20B2DDE
	Offset: 0xBD3E
	Size: 0x13E
	Parameters: 0
	Flags: None
*/
aimassist()
{
	self endon("disconnect");
	level endon("end_game");
	self endon("stopcustomperk");
	self thread is_player_aiming();
	for(;;)
	{
		view_pos = self getweaponmuzzlepoint();
		zombies = get_array_of_closest(view_pos, getaiarray(level.zombie_team), undefined, undefined, undefined);
		range_squared = 300 * 300;
		i = 0;
		while(i < zombies.size)
		{
			if(!isdefined(zombies[i]) || !isalive(zombies[i]))
			{
				continue;
			}
			enemy_origin = zombies[i].origin;
			test_range_squared = distancesquared(view_pos, enemy_origin);
			if(test_range_squared < range_squared)
			{
				if(zombies[i] player_can_see_me(self))
				{
					if(self adsbuttonpressed() && !self isreloading() && !self.isaiming)
					{
						self setplayerangles(VectorToAngles(zombies[i] gettagorigin("j_head") - self geteye()));
						while(self adsbuttonpressed())
						{
							wait(0.05);
						}
						break;
					}
				}
			}
			i++;
		}
		wait(0.05);
	}
}

/*
	Name: player_can_see_me
	Namespace: forest
	Checksum: 0xAAFD812
	Offset: 0xBE7E
	Size: 0xDC
	Parameters: 1
	Flags: None
*/
player_can_see_me(player)
{
	playerangles = player getplayerangles();
	playerforwardvec = AnglesToForward(playerangles);
	playerunitforwardvec = vectornormalize(playerforwardvec);
	banzaipos = self.origin;
	playerpos = player getorigin();
	playertobanzaivec = banzaipos - playerpos;
	playertobanzaiunitvec = vectornormalize(playertobanzaivec);
	forwarddotbanzai = vectordot(playerunitforwardvec, playertobanzaiunitvec);
	if(forwarddotbanzai >= 1)
	{
		anglefromcenter = 0;
	}
	else if(forwarddotbanzai <= -1)
	{
		anglefromcenter = 180;
	}
	else
	{
		anglefromcenter = acos(forwarddotbanzai);
	}
	playerfov = GetDvarFloat("cg_fov");
	banzaivsplayerfovbuffer = GetDvarFloat("g_banzai_player_fov_buffer");
	if(banzaivsplayerfovbuffer <= 0)
	{
		banzaivsplayerfovbuffer = 0.2;
	}
	playercanseeme = anglefromcenter <= playerfov * 0.5 * 1 - banzaivsplayerfovbuffer;
	return playercanseeme;
}

/*
	Name: is_player_aiming
	Namespace: forest
	Checksum: 0x8C5D411C
	Offset: 0xBF5C
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
is_player_aiming()
{
	self endon("stopcustomperk");
	self endon("disconnect");
	level endon("end_game");
	self.isaiming = 0;
	for(;;)
	{
		aiming = 0;
		self.isaiming = 0;
		while(self adsbuttonpressed())
		{
			aiming++;
			if(aiming > 1)
			{
				self.isaiming = 1;
			}
			wait(0.05);
		}
		wait(0.05);
	}
}