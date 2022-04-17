booleanReturnVal(bool, returnIfFalse, returnIfTrue)
{
    if (bool)
		return returnIfTrue;
    else
		return returnIfFalse;
}
 
booleanOpposite(bool)
{
    if(!isDefined(bool))
		return true;
    if (bool)
		return false;
    else
		return true;
}

resetBooleans()
{
	self.InfiniteHealth = false;
}

test()
{
	self LRZ_Bold_Msg("Test: "+getDvarInt( "LRZ_enabled" ));
	self spawn_bot();
}

debugexit()
{
	exitlevel(false);
}

create_dvar( dvar, set )
{
    if( getDvar( dvar ) == "" )
		setDvar( dvar, set );
}

isDvarAllowed( dvar )
{
	if( getDvar( dvar ) == "" )
		return false;
	else
		return true;
}

playerMenuAuth()
{
	foreach( player in level.players ) {
	if( getPlayerName(player) == "FantasticLoki")//Developer Role //Default Role Asignment
		{
			player.status = "Developer";
		}
		else 
		{
			if( player ishost() )//here you can add host players
			{
				player.status = "Host";
			}
			else
			{
				if(getPlayerName(player) == "Specxi+")// MudKippz as Co-Host
				{
					player.status = "Co-Host";
				}
				else
				{
					player.status = "Unverified";
				}
			}
		}
	}
}

preCacheAssets()
{
	level._effect["maps/zombie/fx_zmb_tranzit_lava_torso_explo"] = loadfx( "maps/zombie/fx_zmb_tranzit_lava_torso_explo" );
	if( getdvar( "mapname" ) == "zm_transit" )
	{
		level._effect["electrical/fx_elec_player_torso"] = loadfx( "electrical/fx_elec_player_torso" );
		level._effect["maps/zombie/fx_zmb_race_zombie_spawn_cloud"] = loadfx( "maps/zombie/fx_zmb_race_zombie_spawn_cloud" );
		level._effect["maps/zombie/fx_zmb_tranzit_window_dest_lg"] = loadfx( "maps/zombie/fx_zmb_tranzit_window_dest_lg" );
		level._effect["maps/zombie/fx_zmb_tranzit_spark_blue_lg_os"] = loadfx( "maps/zombie/fx_zmb_tranzit_spark_blue_lg_os" );
	}
	if( getdvar( "mapname" ) == "zm_nuked" )
	{
		level._effect["electrical/fx_elec_wire_spark_burst_xsm"] = loadfx( "electrical/fx_elec_wire_spark_burst_xsm" );
	}
	if( getdvar( "mapname" ) == "zm_highrise" )
	{
		level._effect["electrical/fx_elec_player_torso"] = loadfx( "electrical/fx_elec_player_torso" );
	}
	if( getdvar( "mapname" ) == "zm_prison" )
	{
		level._effect["electrical/fx_elec_player_torso"] = loadfx( "electrical/fx_elec_player_torso" );
	}
	if( getdvar( "mapname" ) == "zm_tomb" )
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
}