// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

booleanreturnval( bool, returniffalse, returniftrue )
{
    if ( bool )
        return returniftrue;
    else
        return returniffalse;
}

booleanopposite( bool )
{
    if ( !isdefined( bool ) )
        return true;

    if ( bool )
        return false;
    else
        return true;
}

resetbooleans()
{
    self.infinitehealth = 0;
}

test()
{
    self lrz_bold_msg( "Test: " + self.origin );
}

debugexit()
{
    exitlevel( 0 );
}

create_dvar( dvar, set )
{
    if ( getdvar( dvar ) == "" )
        setdvar( dvar, set );
}

isdvarallowed( dvar )
{
    if ( getdvar( dvar ) == "" )
        return false;
    else
        return true;
}

precacheassets()
{
    level._effect["maps/zombie/fx_zmb_tranzit_lava_torso_explo"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_torso_explo" );

    if ( getdvar( "mapname" ) == "zm_transit" )
    {
        level._effect["electrical/fx_elec_player_torso"] = loadfx( "electrical/fx_elec_player_torso" );
        level._effect["maps/zombie/fx_zmb_race_zombie_spawn_cloud"] = loadfx( "maps/zombie/fx_zmb_race_zombie_spawn_cloud" );
        level._effect["maps/zombie/fx_zmb_tranzit_window_dest_lg"] = loadfx( "maps/zombie/fx_zmb_tranzit_window_dest_lg" );
        level._effect["maps/zombie/fx_zmb_tranzit_spark_blue_lg_os"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_lg_os" );
    }

    if ( getdvar( "mapname" ) == "zm_nuked" )
        level._effect["electrical/fx_elec_wire_spark_burst_xsm"] = loadfx( "electrical/fx_elec_wire_spark_burst_xsm" );

    if ( getdvar( "mapname" ) == "zm_highrise" )
        level._effect["electrical/fx_elec_player_torso"] = loadfx( "electrical/fx_elec_player_torso" );

    if ( getdvar( "mapname" ) == "zm_prison" )
        level._effect["electrical/fx_elec_player_torso"] = loadfx( "electrical/fx_elec_player_torso" );

    if ( getdvar( "mapname" ) == "zm_tomb" )
    {
        level._effect["maps/zombie_tomb/fx_tomb_ee_fire_wagon"] = loadfx( "maps/zombie_tomb/fx_tomb_ee_fire_wagon" );
        level._effect["maps/zombie_tomb/fx_tomb_shovel_dig"] = loadfx( "maps/zombie_tomb/fx_tomb_shovel_dig" );
    }

    precacheshader( "zombies_rank_5" );
    precacheshader( "zombies_rank_4" );
    precacheshader( "zombies_rank_3" );
    precacheshader( "zombies_rank_2" );
    precacheshader( "zombies_rank_1" );
    precacheshader( "specialty_additionalprimaryweapon_zombies" );
    precacheshader( "specialty_ads_zombies" );
    precacheshader( "specialty_doubletap_zombies" );
    PrecacheShader("specialty_deadshot_zombies");
    precacheshader( "specialty_juggernaut_zombies" );
    precacheshader( "specialty_marathon_zombies" );
    precacheshader( "specialty_quickrevive_zombies" );
    precacheshader( "specialty_fastreload_zombies" );
    precacheshader( "specialty_tombstone_zombies" );
    precacheshader( "specialty_quickrevive_zombies" );
    precacheshader( "lui_loader_no_offset" );
    precacheshader( "minimap_icon_mystery_box" );
    precacheshader( "specialty_instakill_zombies" );
    precacheshader( "specialty_firesale_zombies" );
    precachemodel( "collision_clip_sphere_32" );
    precachemodel( "zm_nuked_female_01_static" );
    precachemodel( "defaultactor" );
    precachemodel( "defaultvehicle" );
    precachemodel( "test_sphere_silver" );
    precachemodel( "test_sphere_lambert" );
    precachemodel( "test_macbeth_chart" );
    precachemodel( "test_macbeth_chart_unlit" );
    precachemodel( "c_zom_player_farmgirl_fb" );
    precachemodel( "c_zom_player_oldman_fb" );
    precachemodel( "c_zom_player_reporter_fb" );
    precachemodel( "c_zom_player_engineer_fb" );
    precachemodel( "zombie_wolf" );
    precachemodel( "weapon_zombie_monkey_bomb" );
    precachemodel( "p6_anim_zm_bus_driver" );
    precachemodel( "c_zom_screecher_fb" );
    precachemodel( "veh_t6_civ_bus_zombie" );
    precachemodel( "p6_anim_zm_magic_box" );
    precachemodel( "c_zom_avagadro_fb" );
    precachemodel( "zombie_teddybear" );
    precachemodel( "zombie_vending_jugg_on" );
    precachemodel( "zombie_vending_doubletap2_on" );
    precachemodel( "zombie_vending_sleight_on" );
    precachemodel( "zombie_vending_revive_on" );
    precachemodel( "zombie_bomb" );
    precachemodel( "zombie_skull" );
    precachemodel( "zombie_x2_icon" );
    precachemodel( "zombie_ammocan" );
    precachemodel( "fx_axis_createfx" );
    precachemodel( "c_zom_player_farmgirl_dlc1_fb" );
    precachemodel( "c_zom_player_oldman_dlc1_fb" );
    precachemodel( "c_zom_player_engineer_dlc1_fb" );
    precachemodel( "c_zom_player_reporter_dlc1_fb" );
    precachemodel( "c_zom_player_arlington_fb" );
    precachemodel( "c_zom_player_deluca_fb" );
    precachemodel( "c_zom_player_handsome_fb" );
    precachemodel( "c_zom_player_oleary_fb" );
    precachemodel( "c_zom_player_grief_guard_fb" );
    precachemodel( "c_zom_player_grief_inmate_fb" );
    precachemodel( "p6_zm_al_skull_afterlife" );
    precachemodel( "c_zom_wolf_head" );
    precachemodel( "p6_zm_al_vending_pap_on" );
    precachemodel( "c_zom_cellbreaker_fb" );
    precachemodel( "p6_zm_al_electric_chair" );
    precachemodel( "veh_t6_dlc_zombie_plane_whole" );
    precachemodel( "p6_anim_zm_al_magic_box_lock" );
    precachemodel( "c_zom_player_farmgirl_fb" );
    precachemodel( "c_zom_player_oldman_fb" );
    precachemodel( "c_zom_player_engineer_fb" );
    precachemodel( "c_zom_player_reporter_dam_fb" );
    precachemodel( "c_zom_zombie_buried_ghost_woman_fb" );
    precachemodel( "c_zom_buried_sloth_fb" );
    precachemodel( "fxanim_zom_buried_fountain_mod" );
    precachemodel( "c_zom_tomb_dempsey_fb" );
    precachemodel( "c_zom_tomb_takeo_fb" );
    precachemodel( "c_zom_tomb_nikolai_fb" );
    precachemodel( "c_zom_tomb_richtofen_fb" );
    precachemodel( "c_zom_tomb_crusader_body_zc" );
    precachemodel( "veh_t6_dlc_mkiv_tank" );
    precachemodel( "veh_t6_dlc_zm_biplane" );
    precachemodel( "p6_zm_tm_dig_mound" );
    precachemodel( "c_zom_mech_body" );
    precachemodel( "veh_t6_dlc_zm_robot_1" );
    precachemodel( "p6_zm_al_vending_doubletap2_on" );
    PrecacheModel("collision_geo_cylinder_32x128_standard");
	PrecacheModel("zombie_perk_bottle_marathon");
	PrecacheModel("zombie_perk_bottle_whoswho");
	PrecacheModel("zombie_vending_nuke_on_lo");
	PrecacheModel("p6_anim_zm_buildable_pap");
	PrecacheModel("p6_zm_al_vending_jugg_on");
	PrecacheModel("p6_zm_al_vending_sleight_on");
	PrecacheModel("p6_zm_al_vending_ads_on");
	PrecacheModel("p6_zm_al_vending_nuke_on");
	PrecacheModel("p6_zm_al_vending_three_gun_on");
}

replaceFuncs()
{
    //replaceFunc(maps\mp\zombies\_zm_powerups::full_ammo_powerup,::new_full_ammo_powerup);
}

max_ammo_refill_clip()
{
    level endon("end_game");
    self endon("disconnect");
    for(;;) 
    {
        self waittill("zmb_max_ammo");
        weaps = self getweaponslist(1);
        foreach (weap in weaps) 
        {
            self setweaponammoclip(weap, weaponclipsize(weap));
        }
        wait 0.05;
    }
}

spawnIfRoundOne() //spawn player
{
	wait 3;
	if ( self.sessionstate == "spectator" && level.round_number == 1 )
		self iprintln("Get ready to be spawned!");
	wait 5;
	if ( self.sessionstate == "spectator" && level.round_number == 1 )
	{
		self [[ level.spawnplayer ]]();
		if ( level.script != "zm_tomb" || level.script != "zm_prison" || !is_classic() )
			thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
	}
}

resetCmap() //reset custom map dvar to ensure proper initialisation of zpp perks
{
    level waittill("end_game");
    self endon("disconnect");
    setdvar("CUSTOM_MAP", "0");
}

getplayerbyguid( guid )
{
	i = 0;
	while( i < level.players.size )
	{
		if( int( level.players[ i] getguid() ) == int( guid ) && isalive( level.players[ i] ) )
		{
			return level.players[ i];
		}
		i++;
	}
	return 0;

}

players_info()
{
	players = [];
	i = 0;
	while( i < level.players.size )
	{
		players[i] = [];
		players[i]["Name"] = level.players[ i].name;
		players[i]["Guid"] = level.players[ i] getguid();
		players[i]["Clientslot"] = level.players[ i] getentitynumber();
		players[i]["Stats"] = level.players[ i] getplayerstats();
		i++;
	}
	return players;

}

getplayerstats()
{
	stats = [];
	stats["Kills"] = self.pers[ "kills"];
	stats["Downs"] = self.pers[ "downs"];
	stats["Revives"] = self.pers[ "revives"];
	stats["Headshots"] = self.pers[ "headshots"];
	stats["Score"] = self.score_total;
	return stats;

}

saynotready()
{
    self iprintln("Not ready!");
}
