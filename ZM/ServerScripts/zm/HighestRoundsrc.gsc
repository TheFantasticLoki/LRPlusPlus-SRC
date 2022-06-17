// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool
#include common_scripts\utility;
#include scripts\zm\zm_bo2_bots;
#include maps\mp\_utility;
#include maps\mp\animscripts\zm_combat;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_gv_actions;
#include maps\mp\gametypes_zm\_damagefeedback;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_score;

init()
{
    if ( !isdvarallowed( "HRTracker" ) || getDvar( "HRTracker" ) == 0 )
        return;

    thread high_round_tracker();
    level thread onplayerconnect();
}

onplayerconnect()
{
    for (;;)
    {
        level waittill( "connecting", player );

        player thread high_round_info();
    }
}

high_round_tracker()
{
    thread high_round_info_giver();
    gamemode = gamemodename( getdvar( "ui_gametype" ) );
    map = mapname( level.script );

    if ( level.script == "zm_transit" && getdvar( "ui_gametype" ) == "zsurvival" )
        map = startlocationname( getdvar( "ui_zm_mapstartlocation" ) );

    level.basepath = getdvar( "fs_basepath" ) + "/" + getdvar( "fs_basegame" ) + "/";
    path = level.basepath + "/logs/" + map + gamemode + "HighRound.txt";
    file = fopen( path, "r" );
    text = fread( file );
    fclose( file );
    highroundinfo = strtok( text, ";" );
    level.highround = int( highroundinfo[0] );
    level.highroundplayers = highroundinfo[1];

    for (;;)
    {
        level waittill( "end_game" );

        if ( level.round_number > level.highround )
        {
            level.highroundplayers = "";
            players = get_players();

            for ( i = 0; i < players.size; i++ )
            {
                if ( level.highroundplayers == "" )
                {
                    level.highroundplayers = players[i].name;
                    continue;
                }

                level.highroundplayers = level.highroundplayers + "," + players[i].name;
            }

            foreach ( player in level.players )
            {
                player tell( "New Record: ^1" + level.round_number );
                player tell( "Set by: ^1" + level.highroundplayers );
            }

            log_highround_record( level.round_number + ";" + level.highroundplayers );
        }
    }
}

log_highround_record( newrecord )
{
    gamemode = gamemodename( getdvar( "ui_gametype" ) );
    map = mapname( level.script );

    if ( level.script == "zm_transit" && getdvar( "ui_gametype" ) == "zsurvival" )
        map = startlocationname( getdvar( "ui_zm_mapstartlocation" ) );

    level.basepath = getdvar( "fs_basepath" ) + "/" + getdvar( "fs_basegame" ) + "/";
    path = level.basepath + "/logs/" + map + gamemode + "HighRound.txt";
    file = fopen( path, "w" );
    fputs( newrecord, file );
    fclose( file );
}

startlocationname( location )
{
    if ( location == "cornfield" )
        return "Cornfield";
    else if ( location == "diner" )
        return "Diner";
    else if ( location == "farm" )
        return "Farm";
    else if ( location == "power" )
        return "Power";
    else if ( location == "town" )
        return "Town";
    else if ( location == "transit" )
        return "BusDepot";
    else if ( location == "tunnel" )
        return "Tunnel";
}

mapname( map )
{
    if ( map == "zm_buried" )
        return "Buried";
    else if ( map == "zm_highrise" )
        return "DieRise";
    else if ( map == "zm_prison" )
        return "MOTD";
    else if ( map == "zm_nuked" )
        return "Nuketown";
    else if ( map == "zm_tomb" )
        return "Origins";
    else if ( map == "zm_transit" )
        return "Tranzit";
    else if ( map == "zm_prison" && getdvar( "CUSTOM_MAP" ) == "1" )
        return "MOTDBridge";
    else if ( map == "zm_prison" && getdvar( "CUSTOM_MAP" ) == "2" )
        return "MOTDRooftop";
    else if ( map == "zm_transit" && getdvar( "CUSTOM_MAP" ) == "1" )
        return "Nacht";
    else if ( map == "zm_transit" && getdvar( "CUSTOM_MAP" ) == "1" && getdvar( "legacy" ) == "1" )
        return "LegacyNacht";
    else if ( map == "zm_transit" && getdvar( "CUSTOM_MAP" ) == "2" )
        return "DinerSurvival";
    else if ( map == "zm_transit" && getdvar( "CUSTOM_MAP" ) == "3" )
        return "BusRide";
    else if ( map == "zm_transit" && getdvar( "CUSTOM_MAP" ) == "4" )
        return "BurningForest";
    else if ( map == "zm_transit" && getdvar( "CUSTOM_MAP" ) == "5" )
        return "Lab";

    return "NA";
}

gamemodename( gamemode )
{
    if ( gamemode == "zstandard" )
        return "Standard";
    else if ( gamemode == "zclassic" )
        return "Classic";
    else if ( gamemode == "zsurvival" )
        return "Survival";
    else if ( gamemode == "zgrief" )
        return "Grief";
    else if ( gamemode == "zcleansed" )
        return "Turned";

    return "NA";
}

high_round_info_giver()
{
    highroundinfo = 1;
    roundmultiplier = 5;
    level endon( "end_game" );

    while ( true )
    {
        level waittill( "start_of_round" );

        if ( level.round_number == highroundinfo * roundmultiplier )
        {
            highroundinfo++;

            foreach ( player in level.players )
            {
                player tell( "High Round Record for this map: ^1" + level.highround );
                player tell( "Record set by: ^1" + level.highroundplayers );
            }
        }
    }
}

high_round_info()
{
    wait 6;
    self tell( "High Round Record for this map: ^1" + level.highround );
    self tell( "Record set by: ^1" + level.highroundplayers );
}
