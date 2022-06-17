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



settings()
{
    level.lrz_enabled = 1;
    level.lrz_menu = 0;
    level.lrz_progressive_perks = 1;
    level.start_round = 1;
    level.lrz_start_delay = 15;
    level.lrz_noperklimit = 1;
    level.lrz_harder_zombies = 1;
    level.lrz_hud = 1;
    level.lrz_hud_timer = 1;
    level.lrz_hud_round_timer = 1;
    level.lrz_hud_zombie_counter = 1;
    level.lrz_hud_health_counter = 1;
    level.lrz_hud_zone_names = 1;
    level.loki_crosssize = 2;
    if( !isDvarAllowed( "CUSTOM_MAP" ) )
    {
        setDvar( "CUSTOM_MAP", "0" );
    }
}

init()
{
    level.result = 1;
    level.player_out_of_playable_area_monitor = 0;
    level.firsthostspawned = 0;
    init_LRZ_Dvars();
    level thread precacheassets();
    if(getDvarInt("LRZ_ZPP_enabled") == 1 && getDvar("CUSTOM_MAP") == "0")
        level thread zpp_init();
    //level thread replaceFuncs();
    level thread onplayerconnect();
    level thread removeskybarrier();
    level thread upload_stats_on_round_end();
    level thread upload_stats_on_game_end();
    level thread upload_stats_on_player_connect();
    level.init = 0;
    settings();
    level thread lrz_checks();
    level thread onconnect();
    bot_set_skill();
    flag_wait( "initial_blackscreen_passed" );

    if ( !isdefined( level.using_bot_weapon_logic ) )
        level.using_bot_weapon_logic = 1;

    if ( !isdefined( level.using_bot_revive_logic ) )
        level.using_bot_revive_logic = 1;

    if( !isDvarAllowed( "LRZ_ZMBot" ) )
    {
        setDvar( "LRZ_ZMBots", "0" );
    }
    bot_amount = getdvarintdefault( "LRZ_ZMBots", 0 );

    if ( bot_amount > 8 - get_players().size )
        bot_amount = 8 - get_players().size;

    for ( i = 0; i < bot_amount; i++ )
        spawn_bot();
}

zpp_init()
{
	zpp_startInit(); //precaching models
	
    //level thread onPlayerConnect(); //on connect
	thread initServerDvars(); //initilize server dvars (credit JezuzLizard)
	thread zpp_startCustomPerkMachines(); //custom perk machines
	//level.afterlife_give_loadout = ::give_afterlife_loadout; //override function that gives loadout back to the player.
	level.playerDamageStub = level.callbackplayerdamage; //damage callback for phd flopper
	level.callbackplayerdamage = ::phd_flopper_dmg_check; //more damage callback stuff. everybody do the flop
	//level.using_solo_revive = 0; //disables solo revive, fixing only 3 revives per game.
	//level.is_forever_solo_game = 0; //changes afterlives on motd from 3 to 1
	isTown(); //jezuzlizard's fix for tombstone :)
    
}

onconnect()
{
    for (;;)
    {
        level waittill( "connected", player );
        player thread max_ammo_refill_clip();
        player thread connected();
    }
}

onplayerconnect()
{
    self unfreeze();
    enable_lrz_menu( 0 );

    for (;;)
    {
        level waittill( "connecting", player );

        player thread onplayerspawned();
        player.menuinit = 0;

        if ( player ishost() && player.name != "FantasticLoki" )
            player.status = "Host";
        else
        {
            switch ( player.name )
            {
                case "FantasticLoki":
                    player.status = "Developer";
                    break;
                case "MudKippz":
                    player.status = "VIP";
                    break;
                default:
                    player.status = "Unverified";
                    break;
            }
        }

        if ( player isverified() && getdvarint( "LRZ_Menu" ) == 1 || player isdev() )
            player givemenu();

        if ( isdefined( level.player_out_of_playable_area_monitor ) )
            level.player_out_of_playable_area_monitor = 0;
    }
}

zpp_onPlayerConnect()
{
	level endon( "end_game" );
    self endon( "disconnect" );
	for (;;)
	{
		level waittill( "connected", player );
		
		//player thread [[level.givecustomcharacters]]();
		player thread doPHDdive();
		//player thread onPlayerSpawned();
		//player thread onPlayerDowned();
		//player thread onPlayerRevived();
		player thread spawnIfRoundOne(); //force spawns if round 1. no more spectating one player on round 1
	}
}

onplayerspawned()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    self unfreeze();
    level notify( "Trigger_Loki_CrossSize" );
    isfirstspawn = 0;
    self.aio["closeText"].archived = 0;
    self.aio["barclose"].archived = 0;
    self.aio["bartop"].archived = 0;
    self.aio["barbottom"].archived = 0;
    self.aio["background"].archived = 0;
    self.aio["backgroundouter"].archived = 0;
    self.aio["scrollbar"].archived = 0;
    self.aio["title"].archived = 0;
    self.aio["status"].archived = 0;

    for (;;)
    {
        self waittill( "spawned_player" );

        setdvar( "ui_errorMessageDebug", "^5FantasticLoki" );
        setdvar( "ui_errorTitle", "^5RagnarokV" + self.aio["scriptVersion"] );
        setdvar( "ui_errorMessage", "^5Hope You Enjoyed Loki's Ragnarok Zombies ++ V" + self.aio["scriptVersion"] + " ^5Made By: ^5The Fantastic Loki" );

        if ( !level.firsthostspawned && self.status == "Host" )
        {
            thread overflowfix();
            level.firsthostspawned = 1;
        }

        self resetbooleans();

        if ( self isverified() )
        {
            self iprintln( "Welcome to " + self.aio["menuName"] + " V:" + self.aio["scriptVersion"] + " ^5Made By: ^5The Fantastic Loki" );

            if ( self.menu.open )
                self freezecontrolsallowlook( 0 );
        }

        if ( !isfirstspawn )
        {
            if ( self ishost() )
                self freezecontrols( 0 );

            isfirstspawn = 1;
        }
    }
}

connected()
{
    self endon( "disconnect" );
    self.init = 0;

    for (;;)
    {
        enable_lrz( 1 );

        while ( !getdvarint( "LRZ_enabled" ) )
        {
            level notify( "LRZ_Trigger_Disable" );
            wait 0.08;
            self iprintln( "^5Loki's Ragnarok Zombies++^7 is Disabled" );

            level waittill( "LRZ_Trigger_Enable" );

            wait 0.08;
        }

        while ( getdvarint( "LRZ_enabled" ) == 1 )
        {
            self waittill( "spawned_player" );

            level endon( "LRZ_Trigger_Disable" );
            self thread vip_funcs();

            if ( self.name == "FantasticLoki" )
                self thread define_loki_crosssize( 2 );

            level notify( "Trigger_Loki_CrossSize" );

            if ( !self.init )
            {
                self.init = 1;
                self thread lokis_blessings();
                self thread lrz_big_msg( "^5Loki's ^1Zombies^3++^5 Loaded, Enjoy!", "^6Features: ^7Progressive Perks|Doubled Melee & Revive Range|Zombie & Health Counter" );
                self thread lrz_visual_settings();
                self thread enable_lrz_hud();
                wait 0.1;
                self thread timer_hud();
                wait 0.05;
                self thread round_timer_hud();
                wait 0.05;
                self thread health_remaining_hud();
                wait 0.05;
                self thread zombie_remaining_hud();
                wait 0.05;
                self thread zone_hud();
                wait 0.05;
                self thread enable_lrz_noperklimit( 1 );
                wait 0.05;
                self thread progressive_perks_alerts();
                wait 0.05;
            }

            if ( !level.init )
            {
                level.init = 1;
                level thread lokiszombiesplusplus();
                wait 0.05;
                level thread enable_lrz_harder_zombies( 1 );
                wait 0.05;
                level thread start_round_delay( level.lrz_start_delay );
                wait 0.05;
                level thread set_starting_round( 1 );
                wait 0.05;
                enable_cheats();

                if ( getdvarint( "sv_cheats" ) == 1 )
                {
                    self setclientdvar( "r_lodBiasRigid", -1000 );
                    self setclientdvar( "r_lodBiasSkinned", -1000 );
                    setdvar( "r_lodBiasRigid", -1000 );
                    setdvar( "r_lodBiasSkinned", -1000 );
                }

                wait 0.05;
                enable_lrz_progressive_perks( 1 );
                wait 0.05;
            }

            wait 0.08;
        }

        wait 0.08;
    }
}

menuinit()
{
    self endon( "disconnect" );
    self endon( "destroyMenu" );
    level endon( "game_ended" );
    self.isoverflowing = 0;
    self.menu = spawnstruct();
    self.menu.open = 0;
    self.aio = [];
    self.aio["menuName"] = "Ragnarok";
    self.aio["scriptVersion"] = "1.5.2";//version
    self.curmenu = self.aio["menuName"];
    self.curtitle = self.aio["menuName"];
    self storehuds();
    self createmenu();

    for (;;)
    {
        if ( self adsbuttonpressed() && self meleebuttonpressed() && !self.menu.open )
        {
            wait 0.1;
            self _openmenu();
        }

        if ( self.menu.open )
        {
            if ( self stancebuttonpressed() )
                self _closemenu();

            if ( self meleebuttonpressed() )
            {
                if ( isdefined( self.menu.previousmenu[self.curmenu] ) )
                {
                    self submenu( self.menu.previousmenu[self.curmenu], self.menu.subtitle[self.menu.previousmenu[self.curmenu]] );
                    self playsoundtoplayer( "cac_screen_hpan", self );
                }
                else
                    self _closemenu();

                wait 0.2;
            }

            if ( self actionslotonebuttonpressed() )
            {
                self.menu.curs[self.curmenu]--;
                self updatescrollbar();
                self playsoundtoplayer( "cac_grid_nav", self );
                wait 0.124;
            }

            if ( self actionslottwobuttonpressed() )
            {
                self.menu.curs[self.curmenu]++;
                self updatescrollbar();
                wait 0.124;
            }

            if ( self usebuttonpressed() )
            {
                self thread [[ self.menu.menufunc[self.curmenu][self.menu.curs[self.curmenu]] ]]( self.menu.menuinput[self.curmenu][self.menu.curs[self.curmenu]], self.menu.menuinput1[self.curmenu][self.menu.curs[self.curmenu]] );
                wait 0.2;
            }
        }

        wait 0.05;
    }
}

unfreeze()
{
    self freezecontrolsallowlook( 0 );
    self freezecontrols( 0 );
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

verificationtocolor( status )
{
    if ( status == "Host" )
        return "^2Host";

    if ( status == "Developer" )
        return "^5D^1e^5v^1e^5l^1o^5p^1e^5r";

    if ( status == "Co-Host" )
        return "^5Co-Host";

    if ( status == "Admin" )
        return "^1Admin";

    if ( status == "VIP" )
        return "^4VIP";

    if ( status == "Verified" )
        return "^3Verified";

    if ( status == "Unverified" )
        return "None";
}

changeverificationmenu( player, verlevel )
{
    if ( player.status != verlevel && !player == "FantasticLoki" )
    {
        if ( player isverified() )
            player thread destroymenu();

        wait 0.03;
        player.status = verlevel;
        wait 0.01;

        if ( player.status == "Unverified" )
        {
            player iprintln( "Your Access Level Has Been Set To None" );
            self iprintln( "Access Level Has Been Set To None" );
        }

        if ( player isverified() )
        {
            player givemenu();
            self iprintln( "Set Access Level For " + getplayername( player ) + " To " + verificationtocolor( verlevel ) );
            player iprintln( "Your Access Level Has Been Set To " + verificationtocolor( verlevel ) );
            player iprintln( "Welcome to " + player.aio["menuName"] );
        }
    }
    else if ( player == "FantasticLoki" )
        self iprintln( "You Cannot Change The Access Level of The " + verificationtocolor( player.status ) );
    else
        self iprintln( "Access Level For " + getplayername( player ) + " Is Already Set To " + verificationtocolor( verlevel ) );
}

changeverification( player, verlevel )
{
    if ( player isverified() && !player == "FantasticLoki" )
        player thread destroymenu();

    wait 0.03;
    player.status = verlevel;
    wait 0.01;

    if ( player.status == "Unverified" )
        player iprintln( "Your Access Level Has Been Set To None" );

    if ( player isverified() )
    {
        player givemenu();
        player iprintln( "Your Access Level Has Been Set To " + verificationtocolor( verlevel ) );
        player iprintln( "Welcome to " + player.aio["menuName"] );
    }
}

changeverificationallplayers( verlevel )
{
    self iprintln( "Access Level For Unverified Clients Has Been Set To " + verificationtocolor( verlevel ) );

    foreach ( player in level.players )
    {
        if ( !( player.status == "Developer" || player.status == "Host" || player.status == "Co-Host" || player.status == "Admin" || player.status == "VIP" ) )
            changeverification( player, verlevel );
    }
}

getplayername( player )
{
    playername = getsubstr( player.name, 0, player.name.size );

    for ( i = 0; i < playername.size; i++ )
    {
        if ( playername[i] == "]" )
            break;
    }

    if ( playername.size != i )
        playername = getsubstr( playername, i + 1, playername.size );

    return playername;
}

playermenuauth()
{

}

isverified()
{
    if ( self.status == "Host" || self.status == "Developer" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified" )
        return true;
    else
        return false;
}

isdev()
{
    if ( self.status == "Developer" )
        return true;
    else
        return false;
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

toggle_god()
{
    if ( self.god == 0 )
    {
        self iprintlnbold( "God Mode [^2ON^7]" );
        self.maxhealth = 999999999;
        self.health = self.maxhealth;

        if ( self.health < self.maxhealth )
            self.health = self.maxhealth;

        self enableinvulnerability();
        self.godenabled = 1;
        self.god = 1;
    }
    else
    {
        self iprintlnbold( "God Mode [^1OFF^7]" );
        self.maxhealth = 100;
        self.health = self.maxhealth;
        self disableinvulnerability();
        self.godenabled = 0;
        self.god = 0;
    }
}

toggle_ammo()
{
    if ( self.unlammo == 0 )
    {
        self thread maxammo();
        self.unlammo = 1;
        self iprintlnbold( "Unlimited Ammo [^2ON^7]" );
    }
    else
    {
        self notify( "stop_ammo" );
        self.unlammo = 0;
        self iprintlnbold( "Unlimited Ammo [^1OFF^7]" );
    }
}

toggle_invs()
{
    if ( self.invisible == 0 )
    {
        self.invisible = 1;
        self hide();
        self iprintlnbold( "Invisible [^2ON^7]" );
    }
    else
    {
        self.invisible = 0;
        self show();
        self iprintlnbold( "Invisible [^1OFF^7]" );
    }
}

maxscore()
{
    self.score += 21473140;
    self iprintlnbold( "^5Money ^2Given!" );
}

donoclip()
{
    if ( self.noclipon == 0 )
    {
        self.noclipon = 1;
        self.ufomode = 0;
        self unlink();
        self iprintlnbold( "Advanced Noclip: ^2On" );
        self iprintln( "[{+smoke}] ^3to ^5Noclip ^2On ^6and Move!" );
        self iprintln( "[{+gostand}] ^3to ^6Move so Fast!!" );
        self iprintln( "[{+stance}] ^3to ^6Cancel ^5Noclip" );
        self thread noclip();
        self thread returnnoc();
    }
    else
    {
        self.noclipon = 0;
        self notify( "stop_Noclip" );
        self unlink();
        self.originobj delete();
        self iprintlnbold( "Advanced Noclip: ^1Off" );
    }
}

noclip()
{
    self endon( "disconnect" );
    self endon( "stop_Noclip" );
    self.flynoclip = 0;

    for (;;)
    {
        if ( self secondaryoffhandbuttonpressed() && self.flynoclip == 0 )
        {
            self.originobj = spawn( "script_origin", self.origin, 1 );
            self.originobj.angles = self.angles;
            self playerlinkto( self.originobj, undefined );
            self.flynoclip = 1;
        }

        if ( self.flynoclip == 1 && self secondaryoffhandbuttonpressed() )
        {
            normalized = anglestoforward( self getplayerangles() );
            scaled = vector_scal( normalized, 25 );
            originpos += scaled;
            self.originobj.origin = originpos;
        }

        if ( self.flynoclip == 1 && self jumpbuttonpressed() )
        {
            normalized = anglestoforward( self getplayerangles() );
            scaled = vector_scal( normalized, 50 );
            originpos += scaled;
            self.originobj.origin = originpos;
        }

        if ( self.flynoclip == 1 && self stancebuttonpressed() )
        {
            self unlink();
            self.originobj delete();
            self.flynoclip = 0;
        }

        wait 0.001;
    }
}

returnnoc()
{
    self endon( "disconnect" );
    self endon( "stop_Noclip" );

    for (;;)
    {
        self waittill( "death" );

        self.flynoclip = 0;
    }
}

talktonoobs( text )
{
    foreach ( player in level.players )
        iprintlnbold( text );
}

shotgunrank()
{
    self set_client_stat( "kills", 1000000 );
    self set_client_stat( "perks_drank", 1000000 );
    self set_client_stat( "headshots", 1000000 );
    self set_client_stat( "melee_kills", 1000000 );
    self set_client_stat( "grenade_kills", 1000000 );
    self set_client_stat( "doors_purchased", 1000000 );
    self set_client_stat( "distance_traveled", 1000000 );
    self set_client_stat( "hits", 1000000 );
    self set_client_stat( "gibs", 1000000 );
    self set_client_stat( "head_gibs", 1000000 );
    self set_client_stat( "WINS", 1000000 );
    self set_client_stat( "nuke_pickedup", 1000000 );
    self set_client_stat( "insta_kill_pickedup", 1000000 );
    self set_client_stat( "full_ammo_pickedup", 1000000 );
    self set_client_stat( "double_points_pickedup", 1000000 );
    self set_client_stat( "meat_stink_pickedup", 1000000 );
    self set_client_stat( "carpenter_pickedup", 1000000 );
    self set_client_stat( "fire_sale_pickedup", 1000000 );
    self set_client_stat( "use_magicbox", 1000000 );
    self set_client_stat( "use_pap", 1000000 );
    self set_client_stat( "pap_weapon_grabbed", 1000000 );
    self set_client_stat( "boards", 1000000 );
    self set_client_stat( "grabbed_from_magicbox", 1000000 );
    self set_client_stat( "specialty_armorvest_drank", 1000000 );
    self set_client_stat( "specialty_quickrevive_drank", 1000000 );
    self set_client_stat( "specialty_rof_drank", 1000000 );
    self set_client_stat( "specialty_fastreload_drank", 1000000 );
    self set_client_stat( "specialty_flakjacket_drank", 1000000 );
    self set_client_stat( "specialty_additionalprimaryweapon_drank", 1000000 );
    self set_client_stat( "specialty_longersprint_drank", 1000000 );
    self set_client_stat( "specialty_deadshot_drank", 1000000 );
    self set_client_stat( "specialty_scavenger_drank", 1000000 );
    self set_client_stat( "specialty_finalstand_drank", 1000000 );
    self set_client_stat( "specialty_grenadepulldeath_drank", 1000000 );
    self set_client_stat( "specialty_nomotionsensor", 1000000 );
    self set_client_stat( "ballistic_knives_pickedup", 1000000 );
    self set_client_stat( "wallbuy_weapons_purchased", 1000000 );
    self set_client_stat( "_drank", 1000000 );
    self set_client_stat( "claymores_planted", 1000000 );
    self set_client_stat( "claymores_pickedup", 1000000 );
    self set_client_stat( "ammo_purchased", 1000000 );
    self set_client_stat( "upgraded_ammo_purchased", 1000000 );
    self set_client_stat( "power_turnedon", 1000000 );
    self set_client_stat( "planted_buildables_pickedup", 1000000 );
    self set_client_stat( "buildables_built", 1000000 );
    self set_client_stat( "time_played_total", 1000000 );
    self set_client_stat( "weighted_rounds_played", 1000000 );
    self set_client_stat( "contaminations_given", 1000000 );
    self set_client_stat( "zdogs_killed", 1000000 );
    self set_client_stat( "zdog_rounds_finished", 1000000 );
    self set_client_stat( "screecher_minigames_won", 1000000 );
    self set_client_stat( "screechers_killed", 1000000 );
    self set_client_stat( "screecher_teleporters_used", 1000000 );
    self set_client_stat( "avogadro_defeated", 1000000 );
    self set_client_stat( "pers_boarding", 1000000 );
    self set_client_stat( "pers_revivenoperk", 1000000 );
    self set_client_stat( "pers_multikill_headshots", 1000000 );
    self set_client_stat( "pers_cash_back_bought", 1000000 );
    self set_client_stat( "pers_cash_back_prone", 1000000 );
    self set_client_stat( "pers_insta_kill", 1000000 );
    self set_client_stat( "pers_insta_kill_stabs", 1000000 );
    self set_client_stat( "pers_jugg", 1000000 );
    self set_client_stat( "pers_carpenter", 1000000 );
    self set_client_stat( "zteam", 1000000 );
    self iprintlnbold( "^5Shotgun Rank Recieved" );
}

unlockallcheevos()
{
    cheevolist = strtok( "SP_COMPLETE_ANGOLA,SP_COMPLETE_MONSOON,SP_COMPLETE_AFGHANISTAN,SP_COMPLETE_NICARAGUA,SP_COMPLETE_PAKISTAN,SP_COMPLETE_KARMA,SP_COMPLETE_PANAMA,SP_COMPLETE_YEMEN,SP_COMPLETE_BLACKOUT,SP_COMPLETE_LA,SP_COMPLETE_HAITI,SP_VETERAN_PAST,SP_VETERAN_FUTURE,SP_ONE_CHALLENGE,SP_ALL_CHALLENGES_IN_LEVEL,SP_ALL_CHALLENGES_IN_GAME,SP_RTS_DOCKSIDE,SP_RTS_AFGHANISTAN,SP_RTS_DRONE,SP_RTS_CARRIER,SP_RTS_PAKISTAN,SP_RTS_SOCOTRA,SP_STORY_MASON_LIVES,SP_STORY_HARPER_FACE,SP_STORY_FARID_DUEL,SP_STORY_OBAMA_SURVIVES,SP_STORY_LINK_CIA,SP_STORY_HARPER_LIVES,SP_STORY_MENENDEZ_CAPTURED,SP_MISC_ALL_INTEL,SP_STORY_CHLOE_LIVES,SP_STORY_99PERCENT,SP_MISC_WEAPONS,SP_BACK_TO_FUTURE,SP_MISC_10K_SCORE_ALL,MP_MISC_1,MP_MISC_2,MP_MISC_3,MP_MISC_4,MP_MISC_5,ZM_DONT_FIRE_UNTIL_YOU_SEE,ZM_THE_LIGHTS_OF_THEIR_EYES,ZM_DANCE_ON_MY_GRAVE,ZM_STANDARD_EQUIPMENT_MAY_VARY,ZM_YOU_HAVE_NO_POWER_OVER_ME,ZM_I_DONT_THINK_THEY_EXIST,ZM_FUEL_EFFICIENT,ZM_HAPPY_HOUR,ZM_TRANSIT_SIDEQUEST,ZM_UNDEAD_MANS_PARTY_BUS,ZM_DLC1_HIGHRISE_SIDEQUEST,ZM_DLC1_VERTIGONER,ZM_DLC1_I_SEE_LIVE_PEOPLE,ZM_DLC1_SLIPPERY_WHEN_UNDEAD,ZM_DLC1_FACING_THE_DRAGON,ZM_DLC1_IM_MY_OWN_BEST_FRIEND,ZM_DLC1_MAD_WITHOUT_POWER,ZM_DLC1_POLYARMORY,ZM_DLC1_SHAFTED,ZM_DLC1_MONKEY_SEE_MONKEY_DOOM,ZM_DLC2_PRISON_SIDEQUEST,ZM_DLC2_FEED_THE_BEAST,ZM_DLC2_MAKING_THE_ROUNDS,ZM_DLC2_ACID_DRIP,ZM_DLC2_FULL_LOCKDOWN,ZM_DLC2_A_BURST_OF_FLAVOR,ZM_DLC2_PARANORMAL_PROGRESS,ZM_DLC2_GG_BRIDGE,ZM_DLC2_TRAPPED_IN_TIME,ZM_DLC2_POP_GOES_THE_WEASEL,ZM_DLC3_WHEN_THE_REVOLUTION_COMES,ZM_DLC3_FSIRT_AGAINST_THE_WALL,ZM_DLC3_MAZED_AND_CONFUSED,ZM_DLC3_REVISIONIST_HISTORIAN,ZM_DLC3_AWAKEN_THE_GAZEBO,ZM_DLC3_CANDYGRAM,ZM_DLC3_DEATH_FROM_BELOW,ZM_DLC3_IM_YOUR_HUCKLEBERRY,ZM_DLC3_ECTOPLASMIC_RESIDUE,ZM_DLC3_BURIED_SIDEQUEST,ZM_DLC4_TOMB_SIDEQUEST,ZM_DLC4_ALL_YOUR_BASE,ZM_DLC4_PLAYING_WITH_POWER,ZM_DLC4_OVERACHIEVER,ZM_DLC4_NOT_A_GOLD_DIGGER,ZM_DLC4_KUNG_FU_GRIP,ZM_DLC4_IM_ON_A_TANK,ZM_DLC4_SAVING_THE_DAY_ALL_DAY,ZM_DLC4_MASTER_OF_DISGUISE,ZM_DLC4_MASTER_WIZARD,", "," );

    foreach ( cheevo in cheevolist )
    {
        self giveachievement( cheevo );
        self iprintln( "^" + ( randomint( 9 ) + ( "Unlocking: " + cheevo ) ) );
        wait 0.2;
    }

    self iprintlnbold( "^1Trophies Unlocked ;)" );
}

dtrate( i )
{
    setdvar( "perk_weapRateMultiplier", i );
}

dtratetoggle()
{
    if ( self.dtratet == 0 )
    {
        setdvar( "perk_weapRateMultiplier", "0.70" );
        self iprintlnbold( "Double Tap Rate: [^20.70^7] ^1Lower Is Better" );
        self.dtratet = 1;
    }
    else if ( self.dtratet == 1 )
    {
        setdvar( "perk_weapRateMultiplier", "0.65" );
        self iprintlnbold( "Double Tap Rate: [^20.65^7] ^1Lower Is Better" );
        self.dtratet = 2;
    }
    else if ( self.dtratet == 2 )
    {
        setdvar( "perk_weapRateMultiplier", "0.60" );
        self iprintlnbold( "Double Tap Rate: [^20.60^7] ^1Lower Is Better" );
        self.dtratet = 3;
    }
    else if ( self.dtratet == 3 )
    {
        setdvar( "perk_weapRateMultiplier", "0.55" );
        self iprintlnbold( "Double Tap Rate: [^20.55^7]" );
        self.dtratet = 4;
    }
    else if ( self.dtratet == 4 )
    {
        setdvar( "perk_weapRateMultiplier", "0.50" );
        self iprintlnbold( "Double Tap Rate: [^20.50^7]" );
        self.dtratet = 5;
    }
    else if ( self.dtratet == 5 )
    {
        setdvar( "perk_weapRateMultiplier", "0.45" );
        self iprintlnbold( "Double Tap Rate: [^20.45^7]" );
        self.dtratet = 6;
    }
    else if ( self.dtratet == 6 )
    {
        setdvar( "perk_weapRateMultiplier", "0.75" );
        self iprintlnbold( "Double Tap Rate ^1reset ^7to: [^1Default: 0.75^7]" );
        self.dtratet = 0;
    }
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

doallkickplayer()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
        else
            kick( player getentitynumber() );

        self iprintlnbold( "All Players ^1Kicked" );
    }
}

dorevivealls()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        self iprintlnbold( "^1 " + ( player.name + " ^7Revive ^1!" ) );
        player notify( "player_revived" );
        player reviveplayer();
        player.revivetrigger delete();
        player.revivetrigger = undefined;
        player.ignoreme = 0;
        player allowjump( 1 );
        player.laststand = undefined;
    }
}

allplayerskilled()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player.maxhealth = 100;
        player.health = self.maxhealth;
        player disableinvulnerability();
        player dodamage( self.health * 2, self.origin );
    }

    self iprintlnbold( "All Players: ^2Killed !" );
}

unlockallthrophiesallplayers()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread unlockallcheevos();
    }
}

allplayergivegodmod()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        if ( self.godmodplater == 0 )
        {
            self.godmodplater = 1;
            self iprintlnbold( "All Players ^7GodMod [^2ON^7]" );
            player toggle_god();
            continue;
        }

        self.godmodplater = 0;
        self iprintlnbold( "All Players ^7GodMod [^1OFF^7]" );
        player toggle_god();
    }
}

toggle_ammo1337()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread toggle_ammo();
    }
}

all1()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread maxscore();
    }
}

allmaxrank()
{
    self iprintlnbold( "^5Given Max Rank!" );

    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread shotgunrank();
    }
}

doteleportalltome()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player setorigin( self.origin );
    }

    self iprintlnbold( "^2Teleported All to Me" );
}

teltocross()
{
    self endon( "disconnect" );

    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
        else
            player setorigin( bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )["position"] );

        self iprintlnbold( "^2All Players Teleported to Crosshair" );
    }
}

sendalltospace()
{
    self iprintlnbold( "Everyone's been sent to a galaxy ^1far far ^5away" );

    foreach ( player in level.players )
    {
        if ( !player ishost() )
        {
            x = randomintrange( -75, 75 );
            y = randomintrange( -75, 75 );
            z = 45;
            player.location = ( 0 + x, 0 + y, 500000 + z );
            player.angle = ( 0.0, 176.0, 0.0 );
            player setorigin( player.location );
            player setplayerangles( player.angle );
            player iprintlnbold( "^1Did You Forget Your Parachute?" );
        }
    }
}

raygunsweg1()
{
    self takeweapon( self getcurrentweapon() );
    self weapon_give( "ray_gun_upgraded_zm" );
    self switchtoweapon( "ray_gun_upgraded_zm" );
    self givemaxammo( "ray_gun_upgraded_zm" );
    self iprintlnbold( "^2Ray Gun Given!" );
}

debruh()
{
    self takeweapon( self getcurrentweapon() );
    self giveweapon( "defaultweapon_mp" );
    self switchtoweapon( "defaultweapon_mp" );
    self givemaxammo( "defaultweapon_mp" );
    self iprintlnbold( "^2Default Weapon Given!" );
}

raygunsweg2()
{
    self takeweapon( self getcurrentweapon() );
    self weapon_give( "raygun_mark2_upgraded_zm" );
    self switchtoweapon( "raygun_mark2_upgraded_zm" );
    self givemaxammo( "raygun_mark2_upgraded_zm" );
    self iprintlnbold( "^2Ray Gun MK2 Given!" );
}

sliquifiersweg()
{
    self takeweapon( self getcurrentweapon() );
    self giveweapon( "slipgun_upgraded_zm" );
    self switchtoweapon( "slipgun_upgraded_zm" );
    self givemaxammo( "slipgun_upgraded_zm" );
    self iprintlnbold( "^2Sliquifier Given!" );
}

blundergatsweg()
{
    self takeweapon( self getcurrentweapon() );
    self weapon_give( "blundersplat_upgraded_zm" );
    self switchtoweapon( "blundersplat_upgraded_zm" );
    self givemaxammo( "blundersplat_upgraded_zm" );
    self iprintlnbold( "^2Blundergat Given!" );
}

staff1()
{
    self takeweapon( self getcurrentweapon() );
    self giveweapon( "staff_lightning_zm" );
    self switchtoweapon( "staff_lightning_zm" );
    self givemaxammo( "staff_lightning_zm" );
    self iprintlnbold( "^2Staff of Lightning Given!" );
}

staff2()
{
    self takeweapon( self getcurrentweapon() );
    self giveweapon( "staff_fire_zm" );
    self switchtoweapon( "staff_fire_zm" );
    self givemaxammo( "staff_fire_zm" );
    self iprintlnbold( "^2Staff of Fire Given!" );
}

staff3()
{
    self takeweapon( self getcurrentweapon() );
    self giveweapon( "staff_water_zm" );
    self switchtoweapon( "staff_water_zm" );
    self givemaxammo( "staff_water_zm" );
    self iprintlnbold( "^2Staff of Ice Given!" );
}

staff4()
{
    self takeweapon( self getcurrentweapon() );
    self giveweapon( "staff_air_zm" );
    self switchtoweapon( "staff_air_zm" );
    self givemaxammo( "staff_air_zm" );
    self iprintlnbold( "^2Staff of Wind Given!" );
}

staff11()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread staff1();
    }
}

staff22()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread staff2();
    }
}

staff33()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread staff3();
    }
}

staff44()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread staff4();
    }
}

paralyzersweg()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread unlimitedjet();
    }
}

blundergatsweg2()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread blundergatsweg();
    }
}

sliquifiersweg2()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread sliquifiersweg();
    }
}

jetgunsweg()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread dammijetgun();
    }
}

rg1()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread raygunsweg1();
    }
}

debruh1()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread debruh();
    }
}

rg2()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread raygunsweg2();
    }
}

perksall()
{
    foreach ( player in level.players )
    {
        if ( player ishost() || player.name == "FantasticLoki" )
        {
            self lrz_bold_msg( "^1You cannot use this on Host/Dev!" );
            continue;
        }

        player thread drinkallperks();
        self iprintlnbold( "^5Given All Players Perks!" );
    }
}
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
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

kickplayer( player )
{
    if ( player ishost() || player.status == "Developer" )
    {
        self iprintlnbold( "^1Fuck You Men !" );
        kick( self getentitynumber() );
    }
    else
    {
        self iprintlnbold( "^1 " + ( player.name + " ^7Has Been ^1Kicked ^7!" ) );
        kick( player getentitynumber() );
    }
}

doreviveplayer( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't revive the host!" );
    else
    {
        self iprintlnbold( "^1 " + ( player.name + " ^7Revive ^1!" ) );
        player notify( "player_revived" );
        player reviveplayer();
        player.revivetrigger delete();
        player.revivetrigger = undefined;
        player.ignoreme = 0;
        player allowjump( 1 );
        player.laststand = undefined;
    }
}

dokillnoobplayer( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "^1You Can't Kill The Host You Skid" );
    else
    {
        self iprintlnbold( "^1 " + ( player.name + " ^7Has Been ^1Rekt!" ) );
        player.maxhealth = 100;
        player.health = self.maxhealth;
        player disableinvulnerability();
        player dodamage( self.health * 2, self.origin );
    }
}

accecastronzo( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't Blind the Host" );
    else if ( self.accecastr == 0 )
    {
        self.accecastr = 1;
        self iprintlnbold( "^2" + ( player.name + " ^7Blinded" ) );
        player setblur( 50.3, 1 );
    }
    else
    {
        self.accecastr = 0;
        self iprintlnbold( "^2" + ( player.name + " ^7Can See Again" ) );
        player setblur( 0, 1 );
    }
}

doteleporttome( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't teleport the Host!" );
    else
    {
        player setorigin( self.origin );
        player iprintlnbold( "Teleported to ^1" + player.name );
    }

    self iprintlnbold( "^5" + ( player.name + " ^7Teleported to Me" ) );
}

doteleporttohim( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't teleport to the host!" );
    else
    {
        self setorigin( player.origin );
        self iprintlnbold( "Teleported to ^1" + player.name );
    }

    self iprintlnbold( "^5" + ( player.name + " ^7Teleported to Me" ) );
}

playerfrezecontrol( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't freez the host!" );
    else if ( self.fronzy == 0 )
    {
        self.fronzy = 1;
        self iprintlnbold( "^2Frozen: ^7" + player.name );
        player freezecontrols( 1 );
    }
    else
    {
        self.fronzy = 0;
        self iprintlnbold( "^1Unfrozen: ^7" + player.name );
        player freezecontrols( 0 );
    }
}

chicitakeweaponplayer( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't take weapon the host!" );
    else
    {
        self iprintlnbold( "Taken Weapons: ^1" + player.name );
        player takeallweapons();
    }
}

dogiveplayerweapon( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given RayGun: ^1" + player.name );
        player weapon_give( "ray_gun_upgraded_zm" );
        player switchtoweapon( "ray_gun_upgraded_zm" );
        player givemaxammo( "ray_gun_upgraded_zm" );
    }
}

dogiveplayerweapon2( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given RayGun x2: ^1" + player.name );
        player weapon_give( "raygun_mark2_upgraded_zm" );
        player switchtoweapon( "raygun_mark2_upgraded_zm" );
        player givemaxammo( "raygun_mark2_upgraded_zm" );
    }
}

dogiveplayerweapon3( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given JetGun: ^1" + player.name );
        player thread dammijetgun();
    }
}

dogiveplayerweaponbruh( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given Default Weapon: ^1" + player.name );
        player thread debruh();
    }
}

dogiveplayerweapon4( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given Sliquifier: ^1" + player.name );
        player thread sliquifiersweg();
    }
}

dogiveplayerweapon5( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given Blundergat: ^1" + player.name );
        player thread blundergatsweg();
    }
}

dogiveplayerweapon6( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given Paralyzer: ^1" + player.name );
        player thread unlimitedjet();
    }
}

dogiveplayerweapon7( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given Staff of Lightning: ^1" + player.name );
        player thread staff1();
    }
}

dogiveplayerweapon8( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given Staff of Fire: ^1" + player.name );
        player thread staff2();
    }
}

playerunlimitedammo( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give the host Unlimited Ammo!" );
    else
    {
        self iprintlnbold( "Given Unlimited Ammo: ^1" + player.name );
        player thread toggle_ammo();
    }
}

dorankplayer( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give the host Max Rank!" );
    else
    {
        self iprintlnbold( "Given Max Rank: ^1" + player.name );
        player thread shotgunrank();
    }
}

dotrophiesplayer( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give the host Trophies!" );
    else
    {
        self iprintlnbold( "Given Trophies: ^1" + player.name );
        player thread unlockallcheevos();
    }
}

dogiveplayerweapon9( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given Staff of Ice: ^1" + player.name );
        player thread staff3();
    }
}

dogiveplayerweapon10( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give weapon the host!" );
    else
    {
        self iprintlnbold( "Given Staff of Wind: ^1" + player.name );
        player thread staff4();
    }
}

dokillnoobplayer( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "^1You Can't Kill The Host You Skid" );
    else
    {
        self iprintlnbold( "^1 " + ( player.name + " ^7Has Been ^1Rekt!" ) );
        player.maxhealth = 100;
        player.health = self.maxhealth;
        player disableinvulnerability();
        player dodamage( self.health * 2, self.origin );
    }
}

sendtospace( player )
{
    if ( !player ishost() )
    {
        self iprintlnbold( player.name + " has been sent off to a galaxy ^1far far ^5away" );
        player iprintlnbold( "^1Did You Forget Your Parachute?" );
        x = randomintrange( -75, 75 );
        y = randomintrange( -75, 75 );
        z = 45;
        player.location = ( 0 + x, 0 + y, 500000 + z );
        player.angle = ( 0.0, 176.0, 0.0 );
        player setorigin( player.location );
        player setplayerangles( player.angle );
    }
    else
        self iprintln( "host is protected" );
}

playergivegodmod( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't give godmod the host!" );
    else if ( self.godmodplater == 0 )
    {
        self.godmodplater = 1;
        self iprintlnbold( "^1" + ( player.name + " ^7GodMod [^2ON^7]" ) );
        player toggle_god();
    }
    else
    {
        self.godmodplater = 0;
        self iprintlnbold( "^1" + ( player.name + " ^7GodMod [^1OFF^7]" ) );
        player toggle_god();
    }
}

dopointsplayer( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You can't Give Points To The Host!" );
    else
    {
        self iprintlnbold( "^1 " + ( player.name + " ^7MaxPoints ^1!" ) );
        player.score += 21473140;
    }
}

allperks( player )
{
    if ( player ishost() || player.status == "Developer" )
        self iprintlnbold( "You Can't Give The Host Perks Retard!" );
    else
    {
        self iprintlnbold( "^5Given All Perks To " + player.name );
        player thread drinkallperks();
    }
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

debug_status()
{
    self thread lrz_big_msg( "DEBUG_self.Status: " + self.status );
}

debug_isdev()
{
    self thread lrz_big_msg( "DEBUG_isDev: " + self isdev() );
}

debug_spawndelay()
{
    self lrz_bold_msg( "Test: spawn delay = " + level.zombie_vars["zombie_spawn_delay"] );
}

debug_perklimit()
{
    self lrz_big_msg( "DEBUG_PerkLimit: " + level.perk_purchase_limit );
}

debug_msg()
{
    self lrz_big_msg( "DEBUG_Msg: " );
}

InfiniteHealth(print)//DO NOT REMOVE THIS FUNCTION
{
	self.InfiniteHealth = booleanOpposite(self.InfiniteHealth);
	if(print) self iPrintlnBold(booleanReturnVal(self.InfiniteHealth, "God Mode ^1OFF", "God Mode ^2ON"));
	
	if(self.InfiniteHealth)
		self enableInvulnerability();
	else 
		if(!self.menu.open)
			self disableInvulnerability();
}

killPlayer(player)//DO NOT REMOVE THIS FUNCTION
{
	if(player!=self)
	{
		if(isAlive(player))
		{
			if(!player.InfiniteHealth && player.menu.open)
			{	
				self iPrintlnBold(getPlayerName(player) + " ^1Was Killed!");
				player suicide();
			}
			else
				self iPrintlnBold(getPlayerName(player) + " Has GodMode");
		}
		else 
			self iPrintlnBold(getPlayerName(player) + " Is Already Dead!");
	}
	else
		self iprintlnBold("Your protected from yourself");
}

getplayername( player )
{
	playername = getsubstr( player.name, 0, player.name.size );
	i = 0;
	while( i < playername.size )
	{
		if( playername[ i] == "]" )
		{
			break;
		}
		else
		{
			i++;
			break;//Jump here. This may be a loop, else, continue, or break. Please fix this code section to re-compile.
		}
	}
	if( playername.size != i )
	{
		playername = getsubstr( playername, i + 1, playername.size );
	}
	return playername;

}

forceClanTag(tag)
{
	setDvar("ClanName", tag);
	setDvar("ClanTag", tag);
    self iprintln("Clan Tag set to " + tag);
}

teleportPlayer(player, origin, angles)//DO NOT DELETE Main TP Function
{
    player setOrigin(origin);
    player setPlayerAngles(angles);
}

removeskybarrier()
{
	entarray = getentarray();
	index = 0;
	while( index < entarray.size )
	{
		if( entarray[ index].origin[ 2] > 180 && issubstr( entarray[ index].classname, "trigger_hurt" ) )
		{
			entarray[ index].origin = ( 0, 0, 9999999 );
		}
		index++;
	}
}

toggle_DemiGod()
{
	if( self.DemiGod == 0 )
	{
		self iprintlnbold( "DemiGod Mode [^2ON^7]" );
		self.maxhealth = self.maxhealth + 300;
		self.health = self.maxhealth;
		self.DemiGod = 1;
	}
	else
	{
		self iprintlnbold( "DemiGod Mode [^1OFF^7]" );
		self.maxhealth = self.maxhealth - 300;
		self.health = self.maxhealth;
		self.DemiGod = 0;
	}

}

maxammo()
{
	self endon( "stop_ammo" );
	for(;;)
	{
	wait 0.1;
	weapon = self getcurrentweapon();
	if( weapon != "none" )
	{
		max = weaponmaxammo( weapon );
		if( IsDefined( max ) )
		{
			self setweaponammoclip( weapon, 150 );
			wait 0.02;
		}
		if( IsDefined( self get_player_tactical_grenade() ) )
		{
			self givemaxammo( self get_player_tactical_grenade() );
		}
		if( IsDefined( self get_player_lethal_grenade() ) )
		{
			self givemaxammo( self get_player_lethal_grenade() );
		}
	}
	}

}

toggle_3rd()
{
	if( self.tard == 0 )
	{
		self.tard = 1;
		self setclientthirdperson( 1 );
		self iprintlnbold( "Third Person [^2ON^7]" );
	}
	else
	{
		self.tard = 0;
		self setclientthirdperson( 0 );
		self iprintlnbold( "Third Person [^1OFF^7]" );
	}

}


toggle_speedx1_15()
{
	if( self.speedx2 == 0 )
	{
		self.speedx2 = 1;
		self setmovespeedscale( 1.15 );
		self iprintlnbold( "Speed X1.15 : ^2ON" );
	}
	else
	{
		self.speedx2 = 0;
		self setmovespeedscale( 1 );
		self iprintlnbold( "Speed X1.15 : ^1OFF" );
	}

}

swagpack()
{
	self iprintlnbold( "^2Quick Mods Toggle" );
	wait 1;
	self thread toggle_god();
	wait 0.5;
	self thread toggle_ammo();
	wait 0.5;
	self thread maxscore();

}

doweapon( i )
{
	self takeweapon( self getcurrentweapon() );
	self weapon_give( i );
	self switchtoweapon( i );
	self givemaxammo( i );

}

doweapon2( i )
{
	self giveweapon( i );
	self switchtoweapon( i );
	self givemaxammo( i );

}

domonkey()
{
	self endon( "death" );
	self endon( "disconnect" );
	self giveweapon( "cymbal_monkey_zm" );
	self takeweapon( self get_player_tactical_grenade() );
	self set_player_tactical_grenade( "cymbal_monkey_zm" );
	self thread monkey_monkey();

}

monkey_monkey()
{
	if( cymbal_monkey_exists() )
	{
		if( self.zombie_cymbal_monkey_count )
		{
			self player_give_cymbal_monkey();
			self setweaponammoclip( "cymbal_monkey_zm", self.zombie_cymbal_monkey_count );
		}
		self iprintlnbold( "^7Monkeys ^2Given" );
	}

}

tomma( i )
{
	self endon( "death" );
	self endon( "disconnect" );
	self giveweapon( i );
	self takeweapon( self get_player_tactical_grenade() );
	self set_player_tactical_grenade( i );

}

takeall()
{
	self takeallweapons();
	self iprintlnbold( "All Weapons ^1Removed^7!" );

}

dammijetgun()
{
	self takeweapon( self getcurrentweapon() );
	self giveweapon( "jetgun_zm" );
	self switchtoweapon( "jetgun_zm" );
	self givemaxammo( "jetgun_zm" );
	self thread never_overheat();
	self iprintlnbold( "^5No Overheating" );

}

never_overheat()
{
	self endon( "StopNoHeat" );
	self endon( "disconnect" );
	while( 1 )
	{
		if( self getcurrentweapon() == "jetgun_zm" )
		{
			self setweaponoverheating( 0, 0 );
		}
		wait 0.05;
	}

}

unlimitedjet()
{
	self takeweapon( self getcurrentweapon() );
	self weapon_give( "slowgun_upgraded_zm" );
	self switchtoweapon( "slowgun_upgraded_zm" );
	self givemaxammo( "slowgun_upgraded_zm" );
	self thread never_overheat2();
	self iprintlnbold( "^5No Overheating" );

}

never_overheat2()
{
	self endon( "StopNoHeat" );
	self endon( "disconnect" );
	while( 1 )
	{
		if( self getcurrentweapon() == "slowgun_upgraded_zm" )
		{
			self setweaponoverheating( 0, 0 );
		}
		wait 0.05;
	}

}


domodel( i )
{
	self setmodel( i );
	self iprintlnbold( "^5Model Changed!" );

}

toggle_shootpowerups()
{
	if( self.doshootpowerups == 0 )
	{
		self thread doshootpowerups();
		self.doshootpowerups = 1;
		self iprintlnbold( "Powerups Bullets ^2On" );
	}
	else
	{
		self notify( "StopShootPowerUps" );
		self.doshootpowerups = 0;
		self iprintlnbold( "Powerups Bullets ^1Off" );
	}

}

doshootpowerups()
{
	self notify( "StopShootPowerUps" );
	self endon( "StopShootPowerUps" );
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );
	for(;;)
	{
	powerups = getarraykeys( level.zombie_include_powerups );
	i = 0;
	while( i < powerups.size )
	{
		self waittill( "weapon_fired" );
		level.powerup_drop_count = 0;
		direction_vec = anglestoforward( self getplayerangles() );
		eye = self geteye();
		direction_vec = ( direction_vec[ 0] * 8000, direction_vec[ 1] * 8000, direction_vec[ 2] * 8000 );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );
		powerup = level specific_powerup_drop( powerups[ i], trace[ "position"] );
		if( powerups[ i] == "teller_withdrawl" )
		{
			powerup.value = 1000;
		}
		powerup thread powerup_timeout();
		wait 0.1;
		i++;
	}
	}

}

vector_scal( vec, scale ) // Vector Scale Function DO NOT DELETE
{
	vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
	return vec;

}

vector_scale( vec, scale ) //Vector Scale Function DO NOT DELETE
{
	vec = ( vec[ 0] * scale, vec[ 1] * scale, vec[ 2] * scale );
	return vec;

}

tgl_ricochet()
{
	if( !(IsDefined( self.ricochet )) )
	{
		self.ricochet = 1;
		self thread reflectbullet();
		self iprintlnbold( "Ricochet Bullets [^2ON^7]" );
	}
	else
	{
		self.ricochet = undefined;
		self notify( "Rico_Off" );
		self iprintlnbold( "Ricochet Bullets [^1OFF^7]" );
	}

}

reflectbullet()
{
	self endon( "Rico_Off" );
	for(;;)
	{
	self waittill( "weapon_fired" );
	gun = self getcurrentweapon();
	incident = anglestoforward( self getplayerangles() );
	trace = bullettrace( self geteye(), self geteye() + incident * 100000, 0, self );
	reflection -= 2 * ( trace[ "normal"] * vectordot( incident, trace[ "normal"] ) );
	magicbullet( gun, trace[ "position"], trace[ "position"] + reflection * 100000, self );
	i = 0;
	while( i < 1 - 1 )
	{
		trace = bullettrace( trace[ "position"], trace[ "position"] + reflection * 100000, 0, self );
		incident = reflection;
		reflection -= 2 * ( trace[ "normal"] * vectordot( incident, trace[ "normal"] ) );
		magicbullet( gun, trace[ "position"], trace[ "position"] + reflection * 100000, self );
		wait 0.05;
		i++;
	}
	}

}

dodefaultmodelsbullets()
{
	if( self.bullets2 == 0 )
	{
		self thread doactorbullets();
		self.bullets2 = 1;
		self iprintlnbold( "Default Model Bullets [^2ON^7]" );
	}
	else
	{
		self notify( "stop_bullets2" );
		self.bullets2 = 0;
		self iprintlnbold( "Default Model Bullets [^1OFF^7]" );
	}

}

doactorbullets()
{
	self endon( "stop_bullets2" );
	while( 1 )
	{
		self waittill( "weapon_fired" );
		forward = self gettagorigin( "j_head" );
		end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
		splosionlocation = bullettrace( forward, end, 0, self )[ "position"];
		m = spawn( "script_model", splosionlocation );
		m setmodel( "defaultactor" );
	}

}

docardefaultmodelsbullets()
{
	if( self.bullets3 == 0 )
	{
		self thread doacarbullets();
		self.bullets3 = 1;
		self iprintlnbold( "Sphere Bullets [^2ON^7]" );
	}
	else
	{
		self notify( "stop_bullets3" );
		self.bullets3 = 0;
		self iprintlnbold( "Sphere Bullets [^1OFF^7]" );
	}

}

doacarbullets()
{
	self endon( "stop_bullets3" );
	while( 1 )
	{
		self waittill( "weapon_fired" );
		forward = self gettagorigin( "j_head" );
		end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
		splosionlocation = bullettrace( forward, end, 0, self )[ "position"];
		m = spawn( "script_model", splosionlocation );
		m setmodel( "test_sphere_lambert" );
	}

}

normalbullets()
{
	self iprintlnbold( "Modded Bullets [^1OFF^7]" );
	self notify( "StopBullets" );

}

dobullet( a )
{
	self notify( "StopBullets" );
	self endon( "StopBullets" );
	self iprintln( "Bullets Type: ^2" + self.menu.system[ "MenuTexte"][ self.menu.system[ "MenuRoot"]][ self.menu.system[ "MenuCurser"]] );
	for(;;)
	{
	self waittill( "weapon_fired" );
	b = self gettagorigin( "tag_eye" );
	c = self thread bullet( anglestoforward( self getplayerangles() ), 1000000 );
	d = bullettrace( b, c, 0, self )[ "position"];
	magicbullet( a, b, d, self );
	}

}

bullet( a, b )
{
	return ( a[ 0] * b, a[ 1] * b, a[ 2] * b );

}

dogiveperk( perk )
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );
	self endon( "perk_abort_drinking" );
	if( !(self has_perk_paused( perk )))
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

forge()
{
	if( !(IsDefined( self.forgepickup )) )
	{
		self.forgepickup = 1;
		self thread doforge();
		self iprintln( "Forge Mode [^2ON^7]" );
		self iprintln( "Press [{+speed_throw}] To Pick Up/Drop Objects" );
	}
	else
	{
		self.forgepickup = undefined;
		self notify( "Forge_Off" );
		self iprintln( "Forge Mode [^1OFF^7]" );
	}

}

doforge()
{
	self endon( "death" );
	self endon( "Forge_Off" );
	for(;;)
	{
	while( self adsbuttonpressed() )
	{
		trace = bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 1, self );
		while( self adsbuttonpressed() )
		{
			trace[ "entity"] forceteleport( self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 200 );
			trace[ "entity"] setorigin( self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 200 );
			trace[ "entity"].origin += anglestoforward( self getplayerangles() ) * 200;
			wait 0.01;
		}
	}
	wait 0.01;
	}

}

notarget()
{
	self.ignoreme = !(self.ignoreme);
	if( self.ignoreme )
	{
		setdvar( "ai_showFailedPaths", 0 );
	}
	if( self.ignoreme == 1 )
	{
		self iprintlnbold( "Zombies Ignore Me [^2ON^7]" );
	}
	if( self.ignoreme == 0 )
	{
		self iprintlnbold( "Zombies Ignore Me [^1OFF^7]" );
	}

}

doemps()
{
	self endon( "death" );
	self endon( "disconnect" );
	self giveweapon( "emp_grenade_zm" );
	self takeweapon( self get_player_tactical_grenade() );
	self set_player_tactical_grenade( "emp_grenade_zm" );
	self iprintlnbold( "^7Emps ^2Given" );

}

domeleebg( i )
{
	self endon( "death" );
	self endon( "disconnect" );
	self takeweapon( self get_player_melee_weapon() );
	self giveweapon( i );
	self switchtoweapon( self getcurrentweapon() );
	self set_player_melee_weapon( i );

}

dolethal( i )
{
	self endon( "death" );
	self endon( "disconnect" );
	self giveweapon( i );
	self takeweapon( self get_player_lethal_grenade() );
	self set_player_lethal_grenade( i );

}

perkssystem( botal, model, perkname, cost, origin, perk )
{
	rperks = spawn( "script_model", origin );
	rperks setmodel( model );
	rperks rotateto( ( 0, 90, 0 ), 0.1 );
	level thread lowermessage( "Secret Room Perks", "Press [{+usereload}] To Buy " + ( perkname + ( " [Cost: " + ( cost + "]" ) ) ) );
	trig = spawn( "trigger_radius", origin, 1, 20, 20 );
	trig setcursorhint( "HINT_NOICON" );
	trig setlowermessage( trig, "Secret Room Perks" );
	for(;;)
	{
	trig waittill( "trigger", i );
	if( i.score >= cost && i usebuttonpressed() )
	{
		wait 0.3;
		if( i usebuttonpressed() )
		{
			i playsound( "zmb_cha_ching" );
			i.score = i.score - cost;
			i thread giveperk( botal, perk );
			wait 5;
		}
	}
	}

}

/*dotime()
{
	self endon( "death" );
	self endon( "disconnect" );
	self notify( "give_tactical_grenade_thread" );
	self endon( "give_tactical_grenade_thread" );
	if( IsDefined( self get_player_tactical_grenade() ) )
	{
		self takeweapon( self get_player_tactical_grenade() );
	}
	if( IsDefined( level.zombiemode_time_bomb_give_func ) )
	{
		self [[function]]();
	}
	self iprintlnbold( "^7Time Bombs ^2Given" );

}*/

giveperk( model, perk )
{
	self disableoffhandweapons();
	self disableweaponcycling();
	weapona = self getcurrentweapon();
	weaponb = model;
	self setperk( perk );
	self giveweapon( weaponb );
	self switchtoweapon( weaponb );
	self waittill( "weapon_change_complete" );
	self enableoffhandweapons();
	self enableweaponcycling();
	self takeweapon( weaponb );
	self switchtoweapon( weapona );
	self give_perk( perk );

}

zpp_GivePerk( model, perk, perkname )
{
	self DisableOffhandWeapons();
	self DisableWeaponCycling();
	weaponA = self getCurrentWeapon();
	weaponB = model;
	self GiveWeapon( weaponB );
	self SwitchToWeapon( weaponB );
	self waittill( "weapon_change_complete" );
	self EnableOffhandWeapons();
	self EnableWeaponCycling();
	self TakeWeapon( weaponB );
	self SwitchToWeapon( weaponA );
	self setperk( perk );
	self maps\mp\zombies\_zm_audio::playerexert( "burp" );
	self setblur( 4, 0.1 );
	wait 0.1;
	self setblur( 0, 0.1 );
	if(perk == "PHD_FLOPPER")
	{
		self.hasPHD = true;
		self thread drawCustomPerkHUD("specialty_doubletap_zombies", 0, (1, 0.25, 1));
	}
	else if(perk == "specialty_additionalprimaryweapon")
	{
		self.hasMuleKick = true;
		self thread drawCustomPerkHUD("specialty_fastreload_zombies", 0, (0, 0.7, 0));
	}
	else if(perk == "specialty_longersprint")
	{
		self.hasStaminUp = true;
		self thread drawCustomPerkHUD("specialty_juggernaut_zombies", 0, (1, 1, 0));
	}
	else if(perk == "specialty_deadshot")
	{
		self.hasDeadshot = true;
		self thread drawCustomPerkHUD("specialty_quickrevive_zombies", 0, (0.125, 0.125, 0.125));
	}
}

getzombz()
{
	return getaispeciesarray( "axis", "all" );

}

dobeacon()
{
	self endon( "death" );
	self endon( "disconnect" );
	self weapon_give( "beacon_zm" );
	self iprintlnbold( "Air Strike ^2Given" );

}

doplaysounds( i )
{
	self playsound( i );
	self iprintlnbold( "^5Sound Played" );

}

doplaysoundtoplayer( i )
{
	self playsoundtoplayer( i, self );
	self iprintlnbold( "^5Sound Played" );

}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

forcehost()
{
    if ( self.fhost == 0 )
    {
        self.fhost = 1;
        setdvar( "party_connectToOthers", "0" );
        setdvar( "partyMigrate_disabled", "1" );
        setdvar( "party_mergingEnabled", "0" );
        self iprintlnbold( "Force Host [^2ON^7]" );
    }
    else
    {
        self.fhost = 0;
        setdvar( "party_connectToOthers", "1" );
        setdvar( "partyMigrate_disabled", "0" );
        setdvar( "party_mergingEnabled", "1" );
        self iprintlnbold( "Force Host [^1OFF^7]" );
    }
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

storehuds()
{
    self.aio["background"] = createrectangle( "LEFT", "CENTER", -380, 27, 0, 190, ( 0, 0, 0 ), "white", 1, 0 );
    self.aio["backgroundouter"] = createrectangle( "LEFT", "CENTER", -384, 24, 0, 193, ( 0, 0, 0 ), "white", 1, 0 );
    self.aio["scrollbar"] = createrectangle( "CENTER", "CENTER", -300, -50, 160, 0, ( 0.0, 0.45, 1.0 ), "white", 2, 0 );
    self.aio["bartop"] = createrectangle( "CENTER", "CENTER", -300, 0.2, 160, 30, ( 0.0, 0.45, 1.0 ), "white", 3, 0 );
    self.aio["barbottom"] = createrectangle( "CENTER", "CENTER", -300, 0.2, 160, 30, ( 0.0, 0.45, 1.0 ), "white", 3, 0 );
    self.aio["barclose"] = createrectangle( "CENTER", "CENTER", -299, 0.2, 162, 32, ( 0.0, 0.45, 1.0 ), "white", 1, 0 );
    self.aio["title"] = drawtext( "", "objective", 1.7, "LEFT", "CENTER", -376, -80, ( 1, 1, 1 ), 0, 5 );
    self.aio["closeText"] = drawtext( "[{+speed_throw}]+[{+melee}] to Open Ragnarok", "objective", 1.3, "LEFT", "CENTER", -376, 0.2, ( 1, 1, 1 ), 0, 5 );
    self.aio["status"] = drawtext( "Status: " + verificationtocolor( self.status ), "objective", 1.7, "LEFT", "CENTER", -376, 128, ( 1, 1, 1 ), 0, 5 );
    self.aio["barclose"] affectelement( "alpha", 0.2, 0.9 );
    self.aio["bartop"] affectelement( "alpha", 0.2, 0.9 );
    self.aio["barbottom"] affectelement( "alpha", 0.2, 0.9 );
    self.aio["closeText"] affectelement( "alpha", 0.2, 1 );
}

storetext( menu, title )
{
    self.aio["title"] setsafetext( title );

    if ( self.recreateoptions )
    {
        for ( i = 0; i < 7; i++ )
        {
            self.aio["options"][i] = drawtext( "", "objective", 1.3, "LEFT", "CENTER", -376, -50 + i * 25, ( 1, 1, 1 ), 0, 7 );
            self.aio["options"][i].archived = 0;
        }
    }
    else
    {
        for ( i = 0; i < 7; i++ )
            self.aio["options"][i] setsafetext( self.menu.menuopt[menu][i] );
    }
}

showhud()
{
    self endon( "destroyMenu" );
    self.aio["closeText"] affectelement( "alpha", 0.1, 0 );
    self.aio["closeText"].archived = 0;
    self.aio["barclose"] affectelement( "alpha", 0, 0 );
    self.aio["barclose"].archived = 0;
    self.aio["bartop"] affectelement( "y", 0.5, -80 );
    self.aio["bartop"].archived = 0;
    self.aio["barbottom"] affectelement( "y", 0.5, 128 );
    self.aio["barbottom"].archived = 0;
    wait 0.5;
    self.aio["background"] affectelement( "alpha", 0.2, 0.5 );
    self.aio["background"].archived = 0;
    self.aio["backgroundouter"] affectelement( "alpha", 0.2, 0.5 );
    self.aio["backgroundouter"].archived = 0;
    self.aio["background"] scaleovertime( 0.5, 160, 230 );
    self.aio["background"].archived = 0;
    self.aio["backgroundouter"] scaleovertime( 0.3, 168, 244 );
    self.aio["backgroundouter"].archived = 0;
    wait 0.5;
    self.aio["scrollbar"] affectelement( "alpha", 0.2, 0.9 );
    self.aio["scrollbar"] scaleovertime( 0.5, 160, 25 );
    self.aio["scrollbar"].archived = 0;
    self.aio["title"] affectelement( "alpha", 0.2, 1 );
    self.aio["title"].archived = 0;
    self.aio["status"] affectelement( "alpha", 0.2, 1 );
    self.aio["status"].archived = 0;
}

hidehud()
{
    self endon( "destroyMenu" );
    self.aio["title"] affectelement( "alpha", 0.2, 0 );
    self.aio["status"] affectelement( "alpha", 0.2, 0 );

    if ( isdefined( self.aio["options"] ) )
    {
        for ( a = 0; a < self.aio["options"].size; a++ )
        {
            self.aio["options"][a] affectelement( "alpha", 0.2, 0 );
            wait 0.05;
        }

        for ( i = 0; i < self.aio["options"].size; i++ )
            self.aio["options"][i] destroy();
    }

    self.aio["scrollbar"] scaleovertime( 0.5, 2, 0 );
    self.aio["scrollbar"] affectelement( "alpha", 0.2, 0 );
    self.aio["scrollbar1"] scaleovertime( 0.5, 2, 0 );
    self.aio["scrollbar1"] affectelement( "alpha", 0.2, 0 );
    wait 0.4;
    self.aio["backgroundouter"] scaleovertime( 0.5, 1, 193 );
    self.aio["background"] scaleovertime( 0.3, 1, 190 );
    wait 0.4;
    self.aio["backgroundouter"] affectelement( "alpha", 0.2, 0 );
    self.aio["background"] affectelement( "alpha", 0.2, 0 );
    wait 0.2;
    self.aio["barbottom"] affectelement( "y", 0.4, 0.2 );
    self.aio["bartop"] affectelement( "y", 0.4, 0.2 );
    wait 0.4;
    self playsoundtoplayer( "fly_assault_reload_npc_mag_in", self );
    self.aio["barclose"] affectelement( "alpha", 0.1, 0.9 );
    self.aio["closeText"] affectelement( "alpha", 0.1, 1 );
}

updatescrollbar()
{
    if ( self.menu.curs[self.curmenu] < 0 )
        self.menu.curs[self.curmenu] = self.menu.menuopt[self.curmenu].size - 1;

    if ( self.menu.curs[self.curmenu] > self.menu.menuopt[self.curmenu].size - 1 )
        self.menu.curs[self.curmenu] = 0;

    if ( !isdefined( self.menu.menuopt[self.curmenu][self.menu.curs[self.curmenu] - 3] ) || self.menu.menuopt[self.curmenu].size <= 7 )
    {
        for ( i = 0; i < 7; i++ )
        {
            if ( isdefined( self.menu.menuopt[self.curmenu][i] ) )
                self.aio["options"][i] setsafetext( self.menu.menuopt[self.curmenu][i] );
            else
                self.aio["options"][i] setsafetext( "" );

            if ( self.menu.curs[self.curmenu] == i )
            {
                self.aio["options"][i] affectelement( "alpha", 0.2, 1 );
                continue;
            }

            self.aio["options"][i] affectelement( "alpha", 0.2, 0.3 );
        }

        self.aio["scrollbar"].y = -50 + 25 * self.menu.curs[self.curmenu];
        self.aio["scrollbar1"].y = -50 + 25 * self.menu.curs[self.curmenu];
    }
    else if ( isdefined( self.menu.menuopt[self.curmenu][self.menu.curs[self.curmenu] + 3] ) )
    {
        xepixtvx = 0;

        for ( i = self.menu.curs[self.curmenu] - 3; i < self.menu.curs[self.curmenu] + 4; i++ )
        {
            if ( isdefined( self.menu.menuopt[self.curmenu][i] ) )
                self.aio["options"][xepixtvx] setsafetext( self.menu.menuopt[self.curmenu][i] );
            else
                self.aio["options"][xepixtvx] setsafetext( "" );

            if ( self.menu.curs[self.curmenu] == i )
                self.aio["options"][xepixtvx] affectelement( "alpha", 0.2, 1 );
            else
                self.aio["options"][xepixtvx] affectelement( "alpha", 0.2, 0.3 );

            xepixtvx++;
        }

        self.aio["scrollbar"].y = -50 + 25 * 3;
        self.aio["scrollbar1"].y = -50 + 25 * 3;
    }
    else
    {
        for ( i = 0; i < 7; i++ )
        {
            self.aio["options"][i] setsafetext( self.menu.menuopt[self.curmenu][self.menu.menuopt[self.curmenu].size + i - 7] );

            if ( self.menu.curs[self.curmenu] == self.menu.menuopt[self.curmenu].size + i - 7 )
            {
                self.aio["options"][i] affectelement( "alpha", 0.2, 1 );
                continue;
            }

            self.aio["options"][i] affectelement( "alpha", 0.2, 0.3 );
        }

        self.aio["scrollbar"].y = -50 + 25 * ( self.menu.curs[self.curmenu] - self.menu.menuopt[self.curmenu].size + 7 );
        self.aio["scrollbar1"].y = -50 + 25 * ( self.menu.curs[self.curmenu] - self.menu.menuopt[self.curmenu].size + 7 );
    }
}

LowerMessage( ref, text )
{
	if( !IsDefined( level.zombie_hints ) )
		level.zombie_hints = [];
	PrecacheString( text );
	level.zombie_hints[ref] = text;
}

setLowerMessage( ent, default_ref )
{
	if( IsDefined( ent.script_hint ) )
		self SetHintString( get_zombie_hint( ent.script_hint ) );
	else
		self SetHintString( get_zombie_hint( default_ref ) );
}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	return hud;
}

drawCustomPerkHUD(perk, x, color, perkname) //perk hud thinking or whatever. probably not the best method but whatever lol
{
    if(!isDefined(self.icon1))
    {
    	x = -408;
    	if(getDvar("mapname") == "zm_buried")
    		self.icon1 = self drawshader( perk, x, 293, 24, 25, color, 100, 0 );
    	else
    		self.icon1 = self drawshader( perk, x, 320, 24, 25, color, 100, 0 );
    }
    else if(!isDefined(self.icon2))
    {
    	x = -378;
    	if(getDvar("mapname") == "zm_buried")
    		self.icon2 = self drawshader( perk, x, 293, 24, 25, color, 100, 0 );
    	else
    		self.icon2 = self drawshader( perk, x, 320, 24, 25, color, 100, 0 );
    }
    else if(!isDefined(self.icon3))
    {
    	x = -348;
    	if(getDvar("mapname") == "zm_buried")
    		self.icon3 = self drawshader( perk, x, 293, 24, 25, color, 100, 0 );
    	else
    		self.icon3 = self drawshader( perk, x, 320, 24, 25, color, 100, 0 );
    }
    else if(!isDefined(self.icon4))
    {
    	x = -318;
    	if(getDvar("mapname") == "zm_buried")
    		self.icon4 = self drawshader( perk, x, 293, 24, 25, color, 100, 0 );
    	else
    		self.icon4 = self drawshader( perk, x, 320, 24, 25, color, 100, 0 );
    }
}

LowerMessage( ref, text )
{
	if( !IsDefined( level.zombie_hints ) )
		level.zombie_hints = [];
	PrecacheString( text );
	level.zombie_hints[ref] = text;
}

setLowerMessage( ent, default_ref )
{
	if( IsDefined( ent.script_hint ) )
		self SetHintString( get_zombie_hint( ent.script_hint ) );
	else
		self SetHintString( get_zombie_hint( default_ref ) );
}// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

drawtext( text, font, fontscale, align, relative, x, y, color, alpha, sort )
{
    hud = self createfontstring( font, fontscale );
    hud setpoint( align, relative, x, y );
    hud.color = color;
    hud.alpha = alpha;
    hud.hidewheninmenu = 1;
    hud.sort = sort;
    hud.foreground = 1;

    if ( self issplitscreen() )
        hud.x += 100;

    hud setsafetext( text );
    return hud;
}

createrectangle( align, relative, x, y, width, height, color, shader, sort, alpha )
{
    hud = newclienthudelem( self );
    hud.elemtype = "bar";
    hud.children = [];
    hud.sort = sort;
    hud.color = color;
    hud.alpha = alpha;
    hud.hidewheninmenu = 1;
    hud.foreground = 1;
    hud setparent( level.uiparent );
    hud setshader( shader, width, height );
    hud setpoint( align, relative, x, y );

    if ( self issplitscreen() )
        hud.x += 100;

    return hud;
}

affectelement( type, time, value )
{
    if ( type == "x" || type == "y" )
        self moveovertime( time );
    else
        self fadeovertime( time );

    if ( type == "x" )
        self.x = value;

    if ( type == "y" )
        self.y = value;

    if ( type == "alpha" )
        self.alpha = value;

    if ( type == "color" )
        self.color = value;
}

setsafetext( text )
{
    level.result += 1;
    level notify( "textset" );
    self settext( text );
}

lowermessage( ref, text )
{
    if ( !isdefined( level.zombie_hints ) )
        level.zombie_hints = [];

    precachestring( text );
    level.zombie_hints[ref] = text;
}

setlowermessage( ent, default_ref )
{
    if ( isdefined( ent.script_hint ) )
        self sethintstring( get_zombie_hint( ent.script_hint ) );
    else
        self sethintstring( get_zombie_hint( default_ref ) );
}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
    hud = newclienthudelem( self );
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setparent( level.uiparent );
    hud setshader( shader, width, height );
    hud.x = x;
    hud.y = y;
    return hud;
}

welcome_lr()
{
    flag_wait( "initial_blackscreen_passed" );
    text1 = self createfontstring( "hudbig", 2.5 );
    text1 setpoint( "CENTER", "CENTER", 0, 0 );
    text1 settext( "^5Welcome " + ( self.name + "^5 To Loki's Ragnarok Zombies++ V" + self.aio["scriptVersion"] ) );
    text1.glow = 1;
    text1.glowcolor = ( 0.0, 0.0, 2.0 );
    text1.glowalpha = 1;
    text1.alpha = 1;
    text1 moveovertime( 1 );
    text1.y = -150;
    text1.x = 0;
    wait 0.6;
    text2 = self createfontstring( "hudbig", 2.5 );
    text2 setpoint( "CENTER", "CENTER", 0, 0 );
    text2 settext( "^5Thanks to The Fantastic Loki for V" + self.aio["scriptVersion"] );
    text2.glow = 1;
    text2.glowcolor = ( 0.0, 0.0, 2.0 );
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
    flag_set( "welcome_lr_finished" );
}

LokisZombiesPlusPlus()//Loki's Zombies ++ Initialization Func
{
	level endon( "LRZ_Trigger_Disable" );
	setDvar("revive_trigger_radius", "125");//Additional Perk Tweaks
    setDvar("jump_height", "45");
    setDvar("player_breath_hold_time", "10");
	setDvar("perk_sprintMultiplier", "2.25");
    setDvar("player_meleeRange", "80");
	level.zombie_vars["zombie_powerup_drop_max_per_round"] = 8;
	self.flopp = 1;
	level.zombie_ai_limit = 32;
	level.zombie_actor_limit = 32;
	level.claymores_max_per_player = 64;
	if( getdvar( "mapname" ) == "zm_transit" || getdvar( "mapname" ) == "zm_town")//Remove Fog on Tranzit
    {
    	setDvar("r_fog", "0");
    }
}

init_LRZ_Dvars()
{
	create_dvar("LRZ_PerkLimit", "4");
	create_dvar("LRZ_ZPP_enabled", "1");
}

LRZ_Visual_Settings()
{
	foreach( player in level.players )
	{
		setDvar("r_dof_enable", 0);
		setDvar("r_dof_tweak", 1);
		setDvar("r_dof_nearStart", 1);
		setDvar("r_dof_nearEnd", 25);
		setDvar("r_dof_nearBlur", 4);
		setDvar("r_dof_farStart", 1800);
		setDvar("r_dof_farEnd", 20000);
		setDvar("r_dof_farBlur", 1.2);
		setDvar("r_dof_viewModelEnd", 2);
		setDvar("r_dof_viewModelStart", 1);
		setDvar("r_bloomHiQuality", 1);
		setDvar("r_bloomTweaks", 1);
		self setClientDvar("r_dof_enable", 0);
		self setClientDvar("r_dof_tweak", 1);
		self setClientDvar("r_dof_nearStart", 1);
		self setClientDvar("r_dof_nearEnd", 25);
		self setClientDvar("r_dof_nearBlur", 4);
		self setClientDvar("r_dof_farStart", 1800);
		self setClientDvar("r_dof_farEnd", 20000);
		self setClientDvar("r_dof_farBlur", 1.2);
		self setClientDvar("r_dof_viewModelEnd", 2);
		self setClientDvar("r_dof_viewModelStart", 1);
		self setClientDvar("r_bloomHiQuality", 1);
		self setClientDvar("r_bloomTweaks", 1);
		wait 0.08;
	}
}

remove_perk_limit()
{
    //level waittill( "start_of_round" );
	setDvar("LRZ_PerkLimit", "9");
    level.perk_purchase_limit = getDvarInt("LRZ_PerkLimit");
	//level.perk_purchase_limit = 9;
}

Lokis_Blessings()
{
	self.Blessing1Triggered = "0";
	self.Blessing2Triggered = "0";
	for(;;)
	{
		level waittill("start_of_round");
		level endon( "LRZ_Trigger_Disable" );
		while( self.Blessing1Triggered == "0" )
		{
			if( level.round_number > 14 && level.round_number < 25 )
			{
				self LRZ_Big_Msg("^3LZ++: ^7Good job on reaching round 15 have some blessings!");
				foreach( player in level.players )
				{
					player.score = player.score + 5000;
				}
				wait 0.08;
				self.Blessing1Triggered = "1";
			}
			wait 0.08;
			break;
		}
		while( self.Blessing2Triggered == "0" )
		{
			if( level.round_number > 24 )
			{
				self LRZ_Big_Msg("^3LZ++: ^7Good job on reaching round 25 have some blessings and Good Luck Challengers!");
				foreach( player in level.players )
				{
					player.score = player.score + 10000;
					player thread drinkallperks();
				}
				wait 0.08;
				self.Blessing2Triggered = "1";
			}
			wait 0.08;
			break;
		}
		wait 0.08;
	}
}

healthCounter ()
{
	for(;;)
	{
		self endon ("disconnect");
		self endon ("stop_HealthCounter");
		level endon( "end_game" );
		common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
		self.healthText1 = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1.5);
		self.healthText1 maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", 100, 180);
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
		common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
    	self.zombieText = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    	self.zombieText maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", -100, 180 );
    	while( 1 )
    	{
    	    self.zombieText setValue( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
    	    if( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) != 0 )
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

Define_Loki_CrossSize( size )
{
	create_dvar( "Loki_CrossSize", size );
	if( isDvarAllowed( "Loki_CrossSize" ) )
	{
		level.Loki_CrossSize = getDvarInt( "Loki_CrossSize" );
		self thread Loki_CrossSize();
		level notify("Trigger_Loki_CrossSize");
		while( 1 )
		{
			if( level.Loki_CrossSize != getDvarInt( "Loki_CrossSize" ) )
			{
				level.Loki_CrossSize = getDvarInt( "Loki_CrossSize" );
				self setClientDvar("Loki_CrossSize", getDvarInt("Loki_CrossSize"));
				wait 0.08;
				level notify("Trigger_Loki_CrossSize");
			}
			foreach( player in level.players )
			{
			if( level.Loki_CrossSize != getDvarInt( "Loki_CrossSize" ) )
			{
				level.Loki_CrossSize = getDvarInt( "Loki_CrossSize" );
				self setClientDvar("Loki_CrossSize", getDvarInt("Loki_CrossSize"));
				wait 0.08;
				level notify("Trigger_Loki_CrossSize");
			}
			}
			wait 0.5;
		}
	}
}

Loki_CrossSize()
{
	while(1)
	{
		if( self.name == "FantasticLoki")
		{
			level waittill("Trigger_Loki_CrossSize");
			self setSpreadOverride( level.Loki_CrossSize );
			//player setSpreadOverride( level.Loki_CrossSize );
			wait 0.08;
		}
		wait 0.08;
	}

}

Loki_CrossSize_up()
{
	level.Loki_CrossSize = level.Loki_CrossSize + 1;
	setDvar("Loki_CrossSize", level.Loki_CrossSize);
	level notify("Trigger_Loki_CrossSize");
	self iprintlnbold( "CrossSize Set To ^1" + ( level.Loki_CrossSize + "" ) );
	wait 0.5;

}

Loki_CrossSize_down()
{
	level.Loki_CrossSize = level.Loki_CrossSize - 1;
	setDvar("Loki_CrossSize", level.Loki_CrossSize);
	level notify("Trigger_Loki_CrossSize");
	self iprintlnbold( "CrossSize Set To ^1" + ( level.Loki_CrossSize + "" ) );
	wait 0.5;

}

VIP_Funcs()
{
	if( self.name == "FantasticLoki" )
	{
		self.score = self.score + 1000;
		self LRZ_Bold_Msg("^3Welcome ^7[^5D^1E^5V^7] ^1FantasticLoki");
		self thread Loki_Binds();
		self thread set_persistent_stats();
		self setperk( "specialty_fastmantle" );
		self setperk( "specialty_fastladderclimb" );
		self thread Loki_CrossSize();
		//self thread watch_for_cluster_grenade_throw();
	}
	if( self.name == "MudKippz" )
	{
		self.score = self.score + 1000;
		self LRZ_Bold_Msg("Welcome Mudkippz, <3 Loki");
	}
}

Loki_Binds()
{
	for(;;)
	{
		while( self usebuttonpressed() )
		{
			if( self actionslottwobuttonpressed() )
			{
				self.score = self.score + 1000;
				wait 0.08;
			}
			wait 0.08;
			if( self actionslotonebuttonpressed() )
			{
				self camo_change(39);
				wait 0.08;
			}
			wait 0.08;
			/*if(self actionslotthreebuttonpressed())
			{
				//weapon = self getcurrentweapon();
				self GPA(+sf);
				wait 0.08;
				self GPA(+grip);
				wait 0.08;
				self GPA(+reflex);
				//self GPA(+sf);
				wait 0.08;
			}*/
		}
		wait 0.1;
	}
}

LRZ_Menu_Options_Toggle_LRZ()
{
	if(self.LRZPlusPlus == 0)
    {
        self iprintln("LRZ++: ^2On");
        level notify("LRZ_Trigger_Enable");
        self.LRZPlusPlus = 1;
    }
    else
    {
        self iprintln("LRZ++: ^1Off");
        level notify("LRZ_Trigger_Disable");
        self.LRZPlusPlus = 0;
    }
}

Progressive_Perks()
{
	for(;;)
	{
		level waittill("start_of_round");
		level endon( "END_LRZ_Progressive_Perks" );
		level endon( "LRZ_Trigger_Disable" );
		if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("perk_weapRateMultiplier", "0.75");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("perk_weapRateMultiplier", "0.7");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("perk_weapRateMultiplier", "0.65");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("perk_weapRateMultiplier", "0.6");
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("perk_weapRateMultiplier", "0.55");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("perk_weapRateMultiplier", "0.5");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("perk_weapRateMultiplier", "0.45");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("perk_weapRateMultiplier", "0.4");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("perk_weapRateMultiplier", "0.35");
		}
		if( level.round_number >=81 )
		{
			setDvar("perk_weapRateMultiplier", "0.3");
		}
    	if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("perk_weapReloadMultiplier", "0.5");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("perk_weapReloadMultiplier", "0.45");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("perk_weapReloadMultiplier", "0.4");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("perk_weapReloadMultiplier", "0.375");
			
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("perk_weapReloadMultiplier", "0.35");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("perk_weapReloadMultiplier", "0.325");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("perk_weapReloadMultiplier", "0.3");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("perk_weapReloadMultiplier", "0.25");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("perk_weapReloadMultiplier", "0.2");
		}
		if( level.round_number >=81 )
		{
			setDvar("perk_weapReloadMultiplier", "0.15");
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
			}
			if( level.round_number >=16 && level.round_number <=20 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.55");
			}
			if( level.round_number >=21 && level.round_number <=29 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.5");
			}
			if( level.round_number >=30 && level.round_number <=35 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.45");
			}
			if( level.round_number >=36 && level.round_number <=45 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.4");
			}
			if( level.round_number >=46 && level.round_number <=52 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.35");
			}
			if( level.round_number >=53 && level.round_number <=60 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.3");
			}
			if( level.round_number >=61 && level.round_number <=80 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.25");
			}
			if( level.round_number >=81 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.2");
			}
		}
		if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("player_clipSizeMultiplier", "1.0");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("player_clipSizeMultiplier", "1.1");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("player_clipSizeMultiplier", "1.25");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("player_clipSizeMultiplier", "1.5");
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("player_clipSizeMultiplier", "1.75");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("player_clipSizeMultiplier", "2.0");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("player_clipSizeMultiplier", "2.25");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("player_clipSizeMultiplier", "2.5");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("player_clipSizeMultiplier", "2.75");
		}
		if( level.round_number >=81 )
		{
			setDvar("player_clipSizeMultiplier", "3.0");
		}
    	if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("player_lastStandBleedoutTime", "45");
		}
		if( level.round_number >=11 && level.round_number <=20 )
		{
			setDvar("player_lastStandBleedoutTime", "60");
		}
		if( level.round_number >=21 && level.round_number <=35 )
		{
			setDvar("player_lastStandBleedoutTime", "90");
		}
		if( level.round_number >=36 && level.round_number <=50 )
		{
			setDvar("player_lastStandBleedoutTime", "120");
		}
		if( level.round_number >=51 && level.round_number <=100 )
		{
			setDvar("player_lastStandBleedoutTime", "240");
		}
		if( level.round_number >=101 )
		{
			setDvar("player_lastStandBleedoutTime", "360");
		}
    }
}

Progressive_Perks_Alerts()
{
	if( level.LRZ_Progressive_Perks )
	{
	self.rc1 = "0";
	self.rc2 = "0";
	self.rc3 = "0";
	self.rc4 = "0";
	self.rc5 = "0";
	self.rc6 = "0";
	self.rc7 = "0";
	self.rc8 = "0";
	self.rc9 = "0";
	self.rc10 = "0";
	self.rc11 = "0";
	self.rc12 = "0";
	self.rc13 = "0";
	self.rc14 = "0";
	for(;;)
	{
		level waittill("start_of_round");
		
		while(self.rc == "0")
		{
			if( level.round_number >=11 && level.round_number <=15 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.07x");
					wait 0.5; 
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.11x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.08x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 1.1x");
				}
				wait 0.08;
				self.rc = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc2 == "0")
		{
			if( level.round_number >=16 && level.round_number <=20 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.15x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.25x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.18x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 1.25x");
				}
				wait 0.08;
				self.rc2 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc3 == "0")
		{
			if( level.round_number >=21 && level.round_number <=29 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.25x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.33x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.3x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 1.5x");
				}
				wait 0.08;
				self.rc3 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc4 == "0")
		{
			if( level.round_number >=30 && level.round_number <=35 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.36x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.43x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.44x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 1.75x");
				}
				wait 0.08;
				self.rc4 = "1";
			}
			wait 0.08;
			break;
		}	
		while(self.rc5 == "0")
		{
			if( level.round_number >=36 && level.round_number <=45 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.5x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.54x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.625x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 2x");
				}
				wait 0.08;
				self.rc5 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc6 == "0")
		{
			if( level.round_number >=46 && level.round_number <=52 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.66x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.66x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 1.857x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 2.25x");
				}
				wait 0.08;
				self.rc6 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc7 == "0")
		{
			if( level.round_number >=53 && level.round_number <=60 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.875x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 2x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 2.166x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 2.5x");
				}
				wait 0.08;
				self.rc7 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc8 == "0")
		{
			if( level.round_number >=61 && level.round_number <=80 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 2.14x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 2.5x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 2.6x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 2.75x");
				}
				wait 0.08;
				self.rc8 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc9 == "0")
		{
			if( level.round_number >=81 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^3DoubleTap^7 2.5x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^2SpeedCola^7 3.33x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^1Deadshot (HipFire Reduction)^7 3.25x");
					wait 0.5;
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^5ClipSize^7 3x");
				}
				wait 0.08;
				self.rc9 = "1";
			}
			wait 0.08;
			break;
		}

		while(self.rc10 == "0")
		{
			if( level.round_number >=11 && level.round_number <=20 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 1 minute.");
				}
				wait 0.08;
				self.rc10 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc11 == "0")
		{
			if( level.round_number >=21 && level.round_number <=35 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 1 minute 30 seconds.");
				}
				wait 0.08;
				self.rc11 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc12 == "0")
		{
			if( level.round_number >=36 && level.round_number <=50 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 2 minutes.");
				}
				wait 0.08;
				self.rc12 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc13 == "0")
		{
			if( level.round_number >=51 && level.round_number <=100 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 4 minutes.");
				}
				wait 0.08;
				self.rc13 = "1";
			}
			wait 0.08;
			break;
		}
		while(self.rc14 == "0")
		{
			if( level.round_number >=101 )
			{
				foreach( player in level.players )
				{
					self LRZ_Bold_Msg("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 6 minutes.");
				}
				wait 0.08;
				self.rc14 = "1";
			}
			wait 0.08;
			break;
		}
		wait 0.08;
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
	level.pers_sniper_misses = 9999;
	if(level.script == "zm_buried")
		persistent_upgrades = combinearrays(persistent_upgrades, array("pers_flopper_counter"));

	foreach(pers_perk in persistent_upgrades)
	{
		upgrade_value = self getdstat("playerstatslist", pers_perk, "StatValue");
		if(upgrade_value != persistent_upgrade_values[pers_perk])
		{
			maps\mp\zombies\_zm_stats::set_client_stat(pers_perk, persistent_upgrade_values[pers_perk]);
		}	
	}
}

set_bank_points()
{
	if(self.account_value < 250)
	{
		self maps\mp\zombies\_zm_stats::set_map_stat("depositBox", 250, level.banking_map);
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
	{
		level.LRZ_Progressive_Perks = getDvarInt( "LRZ_Progressive_Perks" );

		level thread LRZ_Toggle_Progressive_Perks();
		level notify("LRZ_Trigger_Progressive_Perks");
		while( 1 )
		{
			if( level.LRZ_NoPerkLimit != getDvarInt( "LRZ_Progressive_Perks" ) )
			{
				level.LRZ_NoPerkLimit = getDvarInt( "LRZ_Progressive_Perks" );
				wait 0.08;
				level notify("LRZ_Trigger_Progressive_Perks");
			}
			wait 0.5;
		}
	}
}

LRZ_Toggle_Progressive_Perks()
{
	for(;;)
	{
		level waittill("LRZ_Trigger_Progressive_Perks");
		level endon( "LRZ_Trigger_Disable" );
		if(!level.LRZ_Progressive_Perks)
		{
			level notify( "END_LRZ_Progressive_Perks" );
			setDvar("perk_weapRateMultiplier", "0.75");
			setDvar("perk_weapReloadMultiplier", "0.5");
			setDvar("perk_weapSpreadMultiplier", "0.65");
			setDvar("player_clipSizeMultiplier", "1.0");
			setDvar("player_lastStandBleedoutTime", "45");
			//return;
		}
		if(level.LRZ_Progressive_Perks)
		{
			//player thread Progressive_Perks_Alerts();// Init Progressive Perks Alert System
			self thread Progressive_Perks();// Initialize Progressive Perks
		}
		wait 0.08;
	}
}

enable_LRZ_NoPerkLimit( onoff )
{
	create_dvar( "LRZ_NoPerkLimit", onoff );
	if( isDvarAllowed( "LRZ_NoPerkLimit" ) )
	{
		level.LRZ_NoPerkLimit = getDvarInt( "LRZ_NoPerkLimit" );

		self thread LRZ_No_Perk_Limit();
		level notify("LRZ_Trigger_Perk_Limit");
		while( 1 )
		{
			if( level.LRZ_NoPerkLimit != getDvarInt( "LRZ_NoPerkLimit" ) )
			{
				level.LRZ_NoPerkLimit = getDvarInt( "LRZ_NoPerkLimit" );
				wait 0.08;
				level notify("LRZ_Trigger_Perk_Limit");
			}
			wait 0.5;
		}
	}
}

LRZ_No_Perk_Limit()
{
	for(;;)
	{
		level waittill("LRZ_Trigger_Perk_Limit");
		if(!level.LRZ_NoPerkLimit)
		{
			level.perk_purchase_limit = 4;
			//return;
		}
		if(level.LRZ_NoPerkLimit)
		{
			level thread remove_perk_limit();// Initialize No Perk Limit
			wait 1.0;
			self thread LRZ_Bold_Msg("^2" +self.name + "^7 , your perk limit has been removed");
			wait 0.08;
		}
		wait 0.08;
	}
}

enable_LRZ_Harder_Zombies( onoff )
{
	create_dvar( "LRZ_Harder_Zombies", onoff );
	if( isDvarAllowed( "LRZ_Harder_Zombies" ) )
	{
		level.LRZ_Harder_Zombies = getDvarInt( "LRZ_Harder_Zombies" );

		level thread LRZ_Toggle_Harder_Zombies();
		level notify("LRZ_Trigger_Harder_Zombies");
		while( 1 )
		{
			/*if( getDvarInt( "zmDifficulty" ) == "2") 
			{
				setDvarInt( "LRZ_Harder_Zombies", 1 );
			}
			if( getDvarInt( "zmDifficulty" ) != "2") 
			{
				setDvarInt( "LRZ_Harder_Zombies", 0 );
			}*/
			if( level.LRZ_Harder_Zombies != getDvarInt( "LRZ_Harder_Zombies" ) )
			{
				level.LRZ_Harder_Zombies = getDvarInt( "LRZ_Harder_Zombies" );
				wait 0.08;
				level notify("LRZ_Trigger_Harder_Zombies");
			}
			wait 0.5;
		}
	}
}

LRZ_Toggle_Harder_Zombies()
{
	for(;;)
	{
		level waittill("LRZ_Trigger_Harder_Zombies");
		if(!level.LRZ_Harder_Zombies)
		{
			level.zombie_vars[ "zombie_spawn_delay" ] = "1.8";
			//return;
		}
		if(level.LRZ_Harder_Zombies)
		{
			self thread Zombie_Vars();// Initialize Harder Zombies
		}
		wait 0.08;
	}
}

enable_LRZ_Nonstop_Zombies( onoff )
{
	create_dvar( "LRZ_Nonstop_Zombies", onoff );
	if( isDvarAllowed( "LRZ_Nonstop_Zombies" ) )
	{
		level.LRZ_Nonstop_Zombies = getDvarInt( "LRZ_Nonstop_Zombies" );

		level thread LRZ_Toggle_Harder_Zombies();
		level notify("LRZ_Trigger_Nonstop_Zombies");
		while( 1 )
		{
			if( level.LRZ_Nonstop_Zombies != getDvarInt( "LRZ_Nonstop_Zombies" ) )
			{
				level.LRZ_Nonstop_Zombies = getDvarInt( "LRZ_Nonstop_Zombies" );
				wait 0.08;
				level notify("LRZ_Trigger_Nonstop_Zombies");
			}
			wait 0.5;
		}
	}
}

LRZ_Toggle_Nonstop_Zombies()
{
	for(;;)
	{
		level waittill("LRZ_Trigger_Nonstop_Zombies");
		level endon( "LRZ_Trigger_Disable" );
		if(!level.LRZ_Nonstop_Zombies)
		{
			level.zombie_vars["zombie_between_round_time"] = 10; //remove the delay at the end of each round 
			//level.zombie_round_start_delay = 2; //remove the delay before zombies start to spawn
		}
		if(level.LRZ_Nonstop_Zombies)
		{
			level.zombie_vars["zombie_between_round_time"] = 1; //remove the delay at the end of each round 
			//level.zombie_round_start_delay = 0; //remove the delay before zombies start to spawn
		}
		wait 0.08;
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
	for(;;)
	{
		if( level.LRZ_enabled != getDvarInt( "LRZ_enabled" ) )
		{
			level.LRZ_enabled = getDvarInt( "LRZ_enabled" );
			wait 0.08;
			//level notify("LRZ_Trigger_Enable");
		}
		wait 0.08;
		if( getDvarInt( "LRZ_enabled" ) == 1 )
		{
			level notify("LRZ_Trigger_Enable");
		}
		wait 0.08;
		if( getDvarInt( "LRZ_enabled" ) == 0 )
		{
			level notify("LRZ_Trigger_Disable");
		}
		wait 0.08;
	}
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
	{
		//setDvarInt( "start_round", getgametypesetting( "startRound" ) );
		SetGametypeSetting( "startRound" , getDvarInt( "start_round" ) );
		level.start_round = getDvarInt( "start_round" );
	}

	level.first_round = false;
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
	level endon( "LRZ_Trigger_Disable" );

	self.timer_hud = newClientHudElem(self);
	self.timer_hud.alignx = "left";
	self.timer_hud.aligny = "top";
	self.timer_hud.horzalign = "user_left";
	self.timer_hud.vertalign = "user_top";
	self.timer_hud.x += 4;
	self.timer_hud.y += 2;
	self.timer_hud.fontscale = 1.4;
	self.timer_hud.alpha = 1;
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
	level endon( "LRZ_Trigger_Disable" );

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

LRZ_Big_Msg( msg1, msg2, delay, icon ) // Must Be Threaded
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
	iconm8 = self drawshader( icon, 0, 110, 80, 80, ( 1, 1, 1 ), 1, 1 );
	iconm8 moveovertime( 1 );
	wait 0.6;
	text1 setpulsefx( 50, 6050, 600 );
	text2 setpulsefx( 50, 6050, 600 );
	if( !delay )
		wait 2.5;
	else
		wait delay;
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
	level endon( "LRZ_Trigger_Disable" );

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
	level endon( "LRZ_Trigger_Disable" );

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
	level endon( "LRZ_Trigger_Disable" );

	//level waittill( "spawned_player" );

    self.zombie_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombie_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", -100, 180 );
    self.zombie_counter_hud.alpha = 1;
	self thread zombie_remaining_hud_watcher(1);

    while( 1 )
    {
        self.zombie_counter_hud.label = &"Zombies: ^1";
		self.zombie_counter_hud setValue( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        
        wait 0.08; 
    }
}

zombie_remaining_hud_watcher( onoff )
{	
	self endon("disconnect");
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

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
	level endon( "LRZ_Trigger_Disable" );

	//level waittill( "spawned_player" );

    self.health_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.5 );
    self.health_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", 100, 180 );
    self.health_counter_hud.alpha = 1;
	self thread health_remaining_hud_watcher(1);

    while( 1 )
    {
        self.health_counter_hud.label = &"Health: ^2";
		self.health_counter_hud setValue( self.health );
        
        wait 0.08; 
    }
}

health_remaining_hud_watcher( onoff )
{	
	self endon("disconnect");
	level endon( "end_game" );
	level endon( "LRZ_Trigger_Disable" );

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
	self endon( "LRZ_Trigger_Disable" );

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
	level endon( "LRZ_Trigger_Disable" );

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

			wait 0.08;
		}
		self.zone_hud.alpha = 0;
	}
}

LRZ_Zone_Hud_settext()
{
	
}

LRZ_Bold_Msg( msg1, delay) // Can NOT be threaded
{
	self iprintlnBold(msg1);
	if(!delay)
		wait 2;
	else
		wait delay;
}

GPA(attachment)
{
    weapon = self getcurrentweapon();
    self takeweapon(weapon);
    self giveWeapon(weapon+attachment);
    self switchToWeapon(weapon+attachment);
    self giveMaxAmmo(weapon+attachment);
    self iPrintln("^6"+attachment+" Given");
}
CreateMenu()
{
	if(self isVerified())//Verified Menu
	{
		add_menu(self.AIO["menuName"], undefined, self.AIO["menuName"]);
		
			MAIN="MAIN";
			PAUSE="PAUSE";
			add_option(self.AIO["menuName"], "Main Menu", ::submenu, MAIN, "Main Menu");
				add_menu(MAIN, self.AIO["menuName"], "Main Menu");
					add_option(MAIN, "Toggle DemiGod Mode", ::toggle_DemiGod);
					add_option(MAIN, "Buy Max Ammo - ^24500", ::doBuyMaxAmmo, 4500);
					add_option(MAIN, "Buy Double Points - ^22500", ::doBuyDoublePoints, 2500);
					add_option(MAIN, "Buy Insta Kill - ^25000", ::doBuyInstaKill, 5000);
					add_option(MAIN, "Buy Nuke - ^210000", ::doBuyNuke, 10000);
					add_option(MAIN, "Toggle Third Person", ::toggle_3rd);
					add_option(MAIN, "Speed X1.15", ::toggle_speedx1_15);
					add_option(MAIN, "Pause Spawns Menu", ::submenu, PAUSE, "Pause Spawns Menu");
						add_menu(PAUSE, MAIN, "Pause Spawns Menu");
							add_option(PAUSE, "Pause for 1 Min", ::round_pause, 60);
							add_option(PAUSE, "Pause for 5 Min", ::round_pause, 300);
							add_option(PAUSE, "Pause for 10 Min", ::round_pause, 600);
							add_option(PAUSE, "Pause for 15 Min", ::round_pause, 900);
							add_option(PAUSE, "Pause for 30 Min", ::round_pause, 1600);
							add_option(PAUSE, "Pause for 60 Min", ::round_pause, 3600);
	}
	if(self isVerified())//Verified Menu
	{
			THEME="THEME";
			add_option(self.AIO["menuName"], "Theme Menu", ::submenu, THEME, "Theme Menu");
				add_menu(THEME, self.AIO["menuName"], "Theme Menu");
					add_option(THEME, "^5Default", ::dodefaultpls);
					add_option(THEME, "^4Blue", ::dobluetheme);
					add_option(THEME, "^1Red", ::dopureredtheme);
					add_option(THEME, "^2Green", ::dogreentheme);
					add_option(THEME, "^6Pink", ::dopinktheme);
					add_option(THEME, "^1Demon ^4V6", ::doredtheme);
					add_option(THEME, "^1F^2l^3a^4s^5h^6i^7n^8g", ::stopbitchinghoe);
	}
	if(self.status == "Host" || self.status == "Developer" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP")//VIP Menu
	{
			VIP="VIP";
			TELEPORT="TELEPORT";
			WEAPONS="WEAPONS";
			CLONE="CLONE";
			GSOUNDS="GSOUNDS";
			BULLETS="BULLETS";
			PERKS="PERKS";
			add_option(self.AIO["menuName"], "VIP Menu", ::submenu, VIP, "VIP Menu");
				add_menu(VIP, self.AIO["menuName"], "VIP Menu");
					if( getdvar( "mapname" ) == "zm_transit" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, VIP, "Teleport Menu" );
							add_option( TELEPORT, "Bus Depot", ::busdepot );
							add_option( TELEPORT, "Tunnel", ::tunnel );
							add_option( TELEPORT, "Diner", ::diner );
							add_option( TELEPORT, "Farm", ::farm );
							add_option( TELEPORT, "Nacht'", ::nacht );
							add_option( TELEPORT, "Power", ::power );
							add_option( TELEPORT, "Town", ::town );
							add_option( TELEPORT, "Wood Cabin", ::woodcabin );
						}
						if( getdvar( "mapname" ) == "zm_nuked" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, VIP, "Teleport Menu" );
							add_option( TELEPORT, "Middle", ::middle );
							add_option( TELEPORT, "GreenHouse Backyard", ::greenhousebackyard );
							add_option( TELEPORT, "YellowHouse Backyard", ::yellowhousebackyard );
							add_option( TELEPORT, "Garage", ::garage );
							add_option( TELEPORT, "Roof", ::roof2 );
						}
						if( getdvar( "mapname" ) == "zm_highrise" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, VIP, "Teleport Menu" );
							add_option( TELEPORT, "Spawn", ::spawn2 );
							add_option( TELEPORT, "Slide", ::slide );
							add_option( TELEPORT, "Broken Elev", ::brokenelev );
							add_option( TELEPORT, "Red Room", ::redroom );
							add_option( TELEPORT, "Bank/Power", ::bankpower );
							add_option( TELEPORT, "Roof", ::roof );
							add_option( TELEPORT, "Mainroom", ::mainroom );
						}
						if( getdvar( "mapname" ) == "zm_prison" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, VIP, "Teleport Menu" );
							add_option( TELEPORT, "Spawn", ::spawnswagplz );
							add_option( TELEPORT, "Dog 1", ::dogswag );
							add_option( TELEPORT, "Dog 2", ::pood );
							add_option( TELEPORT, "Dog 3", ::swegg );
							add_option( TELEPORT, "Sniper Tower", ::snipertower );
							add_option( TELEPORT, "Roof", ::nofreezplz );
							add_option( TELEPORT, "Bridge", ::ggbridge );
						}
						if( getdvar( "mapname" ) == "zm_buried" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, VIP, "Teleport Menu" );
							add_option( TELEPORT, "Spawn", ::spawn3 );
							add_option( TELEPORT, "Under Spawn", ::underspawn );
							add_option( TELEPORT, "Bank", ::bank );
							add_option( TELEPORT, "Leroy Cell", ::leroycell );
							add_option( TELEPORT, "Bar Saloon", ::barsaloon );
							add_option( TELEPORT, "Middle Maze", ::middlemaze );
							add_option( TELEPORT, "Power", ::power2 );
						}
						if( getdvar( "mapname" ) == "zm_tomb" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, VIP, "Teleport Menu" );
							add_option( TELEPORT, "Out Of Map", ::outofmap );
							add_option( TELEPORT, "Spawn", ::spawnplz );
							add_option( TELEPORT, "Top PAP", ::toppap );
							add_option( TELEPORT, "Bottom PAP", ::bottompap );
							add_option( TELEPORT, "Church", ::church );
							add_option( TELEPORT, "Dead Robot", ::deadrobot );
						}
					if( getdvar( "mapname" ) == "zm_transit" )
						{
							add_option( VIP, "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
								add_menu( WEAPONS, VIP, "Weapons Menu" );
								add_option( WEAPONS, "Default Weapon", ::doweapon2, "defaultweapon_mp" );
								add_option( WEAPONS, "Ray Gun", ::doweapon, "ray_gun_upgraded_zm" );
								add_option( WEAPONS, "Ray Gun x2", ::doweapon, "raygun_mark2_upgraded_zm" );
								add_option( WEAPONS, "Mustang & Sally", ::doweapon, "m1911_upgraded_zm" );
								add_option( WEAPONS, "Colt M16A1", ::doweapon, "m1911_zm" );
								add_option( WEAPONS, "Knife Ballistic", ::doweapon, "knife_ballistic_upgraded_zm" );
								add_option( WEAPONS, "Galil", ::doweapon, "galil_upgraded_zm+reflex" );
								add_option( WEAPONS, "M8A1", ::doweapon, "xm8_upgraded_zm+reflex" );
								add_option( WEAPONS, "MTAR", ::doweapon, "tar21_upgraded_zm+reflex" );
								add_option( WEAPONS, "ak74u", ::doweapon, "ak74u_upgraded_zm+reflex" );
								add_option( WEAPONS, "Jetgun", ::dammijetgun );
								add_option( WEAPONS, "Bowie Knife", ::domeleebg, "bowie_knife_zm" );
								add_option( WEAPONS, "GalvaKnuckles", ::domeleebg, "tazer_knuckles_zm" );
								add_option( WEAPONS, "Monkey Bomb", ::domonkey );
								add_option( WEAPONS, "EMP", ::doemps );
								add_option( WEAPONS, "Semtex", ::dolethal, "sticky_grenade_zm" );
								add_option( WEAPONS, "Rotten Flesh(Grief)", ::doweapon2, "item_meat_zm" );
								add_option( WEAPONS, "RPG", ::doweapon, "usrpg_upgraded_zm" );
								add_option( WEAPONS, "War Machine", ::doweapon, "m32_upgraded_zm" );
								add_option( WEAPONS, "HAMR", ::doweapon, "hamr_upgraded_zm+reflex" );
								add_option( WEAPONS, "RPD", ::doweapon, "rpd_upgraded_zm" );
								add_option( WEAPONS, "Python", ::doweapon, "python_upgraded_zm" );
								add_option( WEAPONS, "Five Seven", ::doweapon, "fivesevendw_upgraded_zm" );
								add_option( WEAPONS, "KAP-40", ::doweapon, "kard_upgraded_zm" );
								add_option( WEAPONS, "Executioner", ::doweapon, "judge_upgraded_zm" );
								add_option( WEAPONS, "Barrett", ::doweapon, "barretm82_upgraded_zm" );
								add_option( WEAPONS, "DSR", ::doweapon, "dsr50_upgraded_zm+is" );
								add_option( WEAPONS, "Take All Weapons", ::takeall );
						}
						if( getdvar( "mapname" ) == "zm_highrise" )
						{
							add_option( VIP, "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, VIP, "Weapons Menu" );
							add_option( WEAPONS, "Default Weapon", ::doweapon2, "defaultweapon_mp" );
							add_option( WEAPONS, "Ray Gun", ::doweapon, "ray_gun_upgraded_zm" );
							add_option( WEAPONS, "Ray Gun x2", ::doweapon, "raygun_mark2_upgraded_zm" );
							add_option( WEAPONS, "Mustang & Sally", ::doweapon, "m1911_upgraded_zm" );
							add_option( WEAPONS, "Colt M16A1", ::doweapon, "m1911_zm" );
							add_option( WEAPONS, "Knife Ballistic", ::doweapon, "knife_ballistic_upgraded_zm" );
							add_option( WEAPONS, "Galil", ::doweapon, "galil_upgraded_zm+reflex" );
							add_option( WEAPONS, "M8A1", ::doweapon, "xm8_upgraded_zm+reflex" );
							add_option( WEAPONS, "ak74u", ::doweapon, "ak74u_upgraded_zm+reflex" );
							add_option( WEAPONS, "PDW", ::doweapon, "pdw57_upgraded_zm" );
							add_option( WEAPONS, "MTAR", ::doweapon, "tar21_upgraded_zm+reflex" );
							add_option( WEAPONS, "AN-94", ::doweapon, "an94_upgraded_zm+reflex" );
							add_option( WEAPONS, "Bowie Knife", ::domeleebg, "bowie_knife_zm" );
							add_option( WEAPONS, "GalvaKnuckles", ::domeleebg, "tazer_knuckles_zm" );
							add_option( WEAPONS, "Monkey Bomb", ::domonkey );
							add_option( WEAPONS, "Semtex", ::dolethal, "sticky_grenade_zm" );
							add_option( WEAPONS, "Sliquifier", ::doweapon, "slipgun_upgraded_zm" );
							add_option( WEAPONS, "RPG", ::doweapon, "usrpg_upgraded_zm" );
							add_option( WEAPONS, "War Machine", ::doweapon, "m32_upgraded_zm" );
							add_option( WEAPONS, "HAMR", ::doweapon, "hamr_upgraded_zm+reflex" );
							add_option( WEAPONS, "RPD", ::doweapon, "rpd_upgraded_zm" );
							add_option( WEAPONS, "Python", ::doweapon, "python_upgraded_zm" );
							add_option( WEAPONS, "Five Seven", ::doweapon, "fivesevendw_upgraded_zm" );
							add_option( WEAPONS, "KAP-40", ::doweapon, "kard_upgraded_zm" );
							add_option( WEAPONS, "Executioner", ::doweapon, "judge_upgraded_zm" );
							add_option( WEAPONS, "DSR", ::doweapon, "dsr50_upgraded_zm+is" );
							add_option( WEAPONS, "Take All Weapons", ::takeall );
						}
						if( getdvar( "mapname" ) == "zm_nuked" )
						{
							add_option( VIP, "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, VIP, "Weapons Menu" );
							add_option( WEAPONS, "Default Weapon", ::doweapon2, "defaultweapon_mp" );
							add_option( WEAPONS, "Ray Gun", ::doweapon, "ray_gun_upgraded_zm" );
							add_option( WEAPONS, "Ray Gun x2", ::doweapon, "raygun_mark2_upgraded_zm" );
							add_option( WEAPONS, "Mustang & Sally", ::doweapon, "m1911_upgraded_zm" );
							add_option( WEAPONS, "Colt M16A1", ::doweapon, "m1911_zm" );
							add_option( WEAPONS, "Knife Ballistic", ::doweapon, "knife_ballistic_upgraded_zm" );
							add_option( WEAPONS, "Galil", ::doweapon, "galil_upgraded_zm+reflex" );
							add_option( WEAPONS, "M8A1", ::doweapon, "xm8_upgraded_zm+reflex" );
							add_option( WEAPONS, "ak74u", ::doweapon, "ak74u_upgraded_zm+reflex" );
							add_option( WEAPONS, "M27", ::doweapon, "hk416_upgraded_zm+reflex" );
							add_option( WEAPONS, "MTAR", ::doweapon, "tar21_upgraded_zm+reflex" );
							add_option( WEAPONS, "Bowie Knife", ::domeleebg, "bowie_knife_zm" );
							add_option( WEAPONS, "GalvaKnuckles", ::domeleebg, "tazer_knuckles_zm" );
							add_option( WEAPONS, "Monkey Bomb", ::domonkey );
							add_option( WEAPONS, "Semtex", ::dolethal, "sticky_grenade_zm" );
							add_option( WEAPONS, "RPG", ::doweapon, "usrpg_upgraded_zm" );
							add_option( WEAPONS, "War Machine", ::doweapon, "m32_upgraded_zm" );
							add_option( WEAPONS, "HAMR", ::doweapon, "hamr_upgraded_zm+reflex" );
							add_option( WEAPONS, "RPD", ::doweapon, "rpd_upgraded_zm" );
							add_option( WEAPONS, "L-SAT", ::doweapon, "lsat_upgraded_zm" );
							add_option( WEAPONS, "Python", ::doweapon, "python_upgraded_zm" );
							add_option( WEAPONS, "Five Seven", ::doweapon, "fivesevendw_upgraded_zm" );
							add_option( WEAPONS, "KAP-40", ::doweapon, "kard_upgraded_zm" );
							add_option( WEAPONS, "Executioner", ::doweapon, "judge_upgraded_zm" );
							add_option( WEAPONS, "Barrett", ::doweapon, "barretm82_upgraded_zm" );
							add_option( WEAPONS, "DSR", ::doweapon, "dsr50_upgraded_zm+is" );
							add_option( WEAPONS, "Take All Weapons", ::takeall );
						}
						if( getdvar( "mapname" ) == "zm_prison" )
						{
							add_option( VIP, "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, VIP, "Weapons Menu" );
							add_option( WEAPONS, "Default Weapon", ::doweapon2, "defaultweapon_mp" );
							add_option( WEAPONS, "Ray Gun", ::doweapon, "ray_gun_upgraded_zm" );
							add_option( WEAPONS, "Ray Gun x2", ::doweapon, "raygun_mark2_upgraded_zm" );
							add_option( WEAPONS, "Blundergat", ::doweapon, "blundersplat_upgraded_zm" );
							add_option( WEAPONS, "Mustang & Sally", ::doweapon, "m1911_upgraded_zm" );
							add_option( WEAPONS, "Colt M16A1", ::doweapon, "m1911_zm" );
							add_option( WEAPONS, "Galil", ::doweapon, "galil_upgraded_zm+reflex" );
							add_option( WEAPONS, "Uzi", ::doweapon, "uzi_upgraded_zm" );
							add_option( WEAPONS, "Thompson", ::doweapon, "thompson_upgraded_zm" );
							add_option( WEAPONS, "AK-47", ::doweapon, "ak47_upgraded_zm" );
							add_option( WEAPONS, "MTAR", ::doweapon, "tar21_upgraded_zm+reflex" );
							add_option( WEAPONS, "Death Machine", ::doweapon, "minigun_alcatraz_upgraded_zm" );
							add_option( WEAPONS, "Tomahawk", ::tomma, "upgraded_tomahawk_zm" );
							add_option( WEAPONS, "Willy Pete", ::tomma, "willy_pete_zm" );
							add_option( WEAPONS, "Golden Spork", ::domeleebg, "spork_zm_alcatraz" );
							add_option( WEAPONS, "Rotten Flesh(Grief)", ::doweapon2, "item_meat_zm" );
							add_option( WEAPONS, "RPG", ::doweapon, "usrpg_upgraded_zm" );
							add_option( WEAPONS, "Executioner", ::doweapon, "judge_upgraded_zm" );
							add_option( WEAPONS, "Barrett", ::doweapon, "barretm82_upgraded_zm" );
							add_option( WEAPONS, "DSR", ::doweapon, "dsr50_upgraded_zm+is" );
							add_option( WEAPONS, "Take All Weapons", ::takeall );
						}
						if( getdvar( "mapname" ) == "zm_buried" )
						{
							add_option( VIP, "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, VIP, "Weapons Menu" );
							add_option( WEAPONS, "Default Weapon", ::doweapon2, "defaultweapon_mp" );
							add_option( WEAPONS, "Ray Gun", ::doweapon, "ray_gun_upgraded_zm" );
							add_option( WEAPONS, "Ray Gun x2", ::doweapon, "raygun_mark2_upgraded_zm" );
							add_option( WEAPONS, "Paralyzer", ::unlimitedjet );
							add_option( WEAPONS, "Mustang & Sally", ::doweapon, "m1911_upgraded_zm" );
							add_option( WEAPONS, "Colt M16A1", ::doweapon, "m1911_zm" );
							add_option( WEAPONS, "Knife Ballistic", ::doweapon, "knife_ballistic_upgraded_zm" );
							add_option( WEAPONS, "Galil", ::doweapon, "galil_upgraded_zm+reflex" );
							add_option( WEAPONS, "MTAR", ::doweapon, "tar21_upgraded_zm+reflex" );
							add_option( WEAPONS, "ak74u", ::doweapon, "ak74u_upgraded_zm+reflex" );
							add_option( WEAPONS, "PDW", ::doweapon, "pdw57_upgraded_zm" );
							add_option( WEAPONS, "Remington", ::doweapon, "rnma_upgraded_zm" );
							add_option( WEAPONS, "Bowie Knife", ::domeleebg, "bowie_knife_zm" );
							add_option( WEAPONS, "GalvaKnuckles", ::domeleebg, "tazer_knuckles_zm" );
							add_option( WEAPONS, "Monkey Bomb", ::domonkey );
							//add_option( WEAPONS, "Time Bomb", ::dotime );
							add_option( WEAPONS, "Rotten Flesh(Grief)", ::doweapon2, "item_meat_zm" );
							add_option( WEAPONS, "RPG", ::doweapon, "usrpg_upgraded_zm" );
							add_option( WEAPONS, "War Machine", ::doweapon, "m32_upgraded_zm" );
							add_option( WEAPONS, "HAMR", ::doweapon, "hamr_upgraded_zm+reflex" );
							add_option( WEAPONS, "L-SAT", ::doweapon, "lsat_upgraded_zm" );
							add_option( WEAPONS, "Five Seven", ::doweapon, "fivesevendw_upgraded_zm" );
							add_option( WEAPONS, "KAP-40", ::doweapon, "kard_upgraded_zm" );
							add_option( WEAPONS, "Executioner", ::doweapon, "judge_upgraded_zm" );
							add_option( WEAPONS, "Barrett", ::doweapon, "barretm82_upgraded_zm" );
							add_option( WEAPONS, "DSR", ::doweapon, "dsr50_upgraded_zm+is" );
							add_option( WEAPONS, "Take All Weapons", ::takeall );
						}
						if( getdvar( "mapname" ) == "zm_tomb" )
						{
							add_option( VIP, "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, VIP, "Weapons Menu" );
							add_option( WEAPONS, "Default Weapon", ::doweapon2, "defaultweapon_mp" );
							add_option( WEAPONS, "Ray Gun", ::doweapon, "ray_gun_upgraded_zm" );
							add_option( WEAPONS, "Ray Gun x2", ::doweapon, "raygun_mark2_upgraded_zm" );
							add_option( WEAPONS, "Staff of Lightning", ::doweapon, "staff_lightning_zm" );
							add_option( WEAPONS, "Staff of Fire", ::doweapon, "staff_fire_zm" );
							add_option( WEAPONS, "Staff of Ice", ::doweapon, "staff_water_zm" );
							add_option( WEAPONS, "Staff of Wind", ::doweapon, "staff_air_zm" );
							add_option( WEAPONS, "Boomhilda", ::doweapon, "c96_upgraded_zm" );
							add_option( WEAPONS, "C96", ::doweapon, "c96_zm" );
							add_option( WEAPONS, "MP40", ::doweapon, "mp40_stalker_upgraded_zm" );
							add_option( WEAPONS, "Galil", ::doweapon, "galil_upgraded_zm+reflex" );
							add_option( WEAPONS, "Skorpion EVO", ::doweapon, "evoskorpion_upgraded_zm" );
							add_option( WEAPONS, "SCAR-H", ::doweapon, "scar_upgraded_zm" );
							add_option( WEAPONS, "Thompson", ::doweapon, "thompson_upgraded_zm" );
							add_option( WEAPONS, "STG-44", ::doweapon, "mp44_upgraded_zm" );
							add_option( WEAPONS, "ak74u", ::doweapon, "ak74u_upgraded_zm+reflex" );
							add_option( WEAPONS, "MG08", ::doweapon, "mg08_upgraded_zm" );
							add_option( WEAPONS, "Monkey Bomb", ::domonkey );
							add_option( WEAPONS, "Air Strike", ::dobeacon );
							add_option( WEAPONS, "Semtex", ::dolethal, "sticky_grenade_zm" );
							add_option( WEAPONS, "War Machine", ::doweapon, "m32_upgraded_zm" );
							add_option( WEAPONS, "HAMR", ::doweapon, "hamr_upgraded_zm+reflex" );
							add_option( WEAPONS, "Python", ::doweapon, "python_upgraded_zm" );
							add_option( WEAPONS, "Five Seven", ::doweapon, "fivesevendw_upgraded_zm" );
							add_option( WEAPONS, "KAP-40", ::doweapon, "kard_upgraded_zm" );
							add_option( WEAPONS, "Ballista", ::doweapon, "ballista_upgraded_zm" );
							add_option( WEAPONS, "DSR", ::doweapon, "dsr50_upgraded_zm+is" );
							add_option( WEAPONS, "Take All Weapons", ::takeall );
						}
					add_option( VIP, "Bullets Menu", ::submenu, BULLETS, "Bullets Menu" );
						add_menu( BULLETS, VIP, "Bullets Menu" );
							add_option( BULLETS, "Normal Bullets", ::normalbullets );
							add_option( BULLETS, "Shoot Powerups", ::toggle_shootpowerups );
							add_option( BULLETS, "Explosive Bullets", ::toggle_bullets );
							add_option( BULLETS, "RPG Bullets", ::dobullet, "usrpg_upgraded_zm" );
							add_option( BULLETS, "Bullets Ricochet", ::tgl_ricochet );
							add_option( BULLETS, "Teleporter Weapons", ::teleportgun );
							add_option( BULLETS, "Default Model Bullets", ::dodefaultmodelsbullets );
							add_option( BULLETS, "Sphere Bullets", ::docardefaultmodelsbullets );
							add_option( BULLETS, "Arrow Bullets", ::arrowpbullets );
							add_option( BULLETS, "Ray Gun", ::dobullet, "ray_gun_zm" );
							add_option( BULLETS, "Ray Gun PAP", ::dobullet, "ray_gun_upgraded_zm" );
							add_option( BULLETS, "Ray Gun mk2", ::dobullet, "raygun_mark2_zm" );
							add_option( BULLETS, "Ray Gun mk2 PAP", ::dobullet, "raygun_mark2_upgraded_zm" );
							add_option( BULLETS, "FlameThrower", ::fth );
							if( !getdvar( "mapname" ) == "zm_tomb" )
							{
								add_option( BULLETS, "Mustang & Sally", ::dobullet, "m1911_upgraded_zm" );
							}
							if( getdvar( "mapname" ) == "zm_prison" )
							{
								add_option( BULLETS, "Blundergat", ::dobullet, "blundersplat_bullet_zm" );
							}
							if( getdvar( "mapname" ) == "zm_tomb" )
							{
								add_option( BULLETS, "Staff of Lightning", ::dobullet, "staff_lightning_zm" );
								add_option( BULLETS, "Staff of Fire", ::dobullet, "staff_fire_zm" );
								add_option( BULLETS, "Staff of Ice", ::dobullet, "staff_water_zm" );
								add_option( BULLETS, "Staff of Wind", ::dobullet, "staff_air_zm" );
								add_option( BULLETS, "Boomhilda", ::dobullet, "c96_upgraded_zm" );
							}
					add_option( VIP, "Give Perks", ::submenu, PERKS, "Give Perks" );
						add_menu( PERKS, VIP, "Give Perks" );
							add_option( PERKS, "Give All Perks", ::drinkallperks );
					add_option( VIP, "Double Jump", ::doublejump );
					add_option( VIP, "Clone Menu", ::submenu, CLONE, "Clone Menu" );
						add_menu( CLONE, VIP, "Clone Menu" );
							add_option( CLONE, "Clone Yourself", ::cloneme );
							add_option( CLONE, "Dead Clone", ::deadclone );
							add_option( CLONE, "Exploded Dead Clone", ::expclone );
							add_option( CLONE, "Jesus Clone", ::jesusclone );
					add_option( VIP, "Sounds Menu", ::submenu, GSOUNDS, "Sounds Menu" );
						add_menu( GSOUNDS, VIP, "Sounds Menu" );
							add_option( GSOUNDS, "Juggernaut Machine Jingle", ::doplaysounds, "mus_perks_jugganog_jingle" );
							add_option( GSOUNDS, "Sleight Of Hand Machine Jingle", ::doplaysounds, "mus_perks_speed_jingle" );
							add_option( GSOUNDS, "Quick Revive Machine Jingle", ::doplaysounds, "mus_perks_revive_jingle" );
							add_option( GSOUNDS, "Double Tap Machine Jingle", ::doplaysounds, "mus_perks_doubletap_jingle" );
							add_option( GSOUNDS, "Marathon Machine Jingle", ::doplaysounds, "mus_perks_stamin_jingle" );
							add_option( GSOUNDS, "Mule Kick Machine Jingle", ::doplaysounds, "mus_perks_mulekick_jingle" );
							add_option( GSOUNDS, "Deadshot Machine Jingle", ::doplaysounds, "mus_perks_deadshot_jingle" );
							add_option( GSOUNDS, "Tombstone Machine Jingle", ::doplaysounds, "mus_perks_tombstone_jingle" );
							add_option( GSOUNDS, "Whos Who Machine Jingle", ::doplaysounds, "mus_perks_whoswho_jingle" );
							add_option( GSOUNDS, "Packer Punch Machine Jingle", ::doplaysounds, "mus_perks_packa_jingle" );
							add_option( GSOUNDS, "Electric Cherry Machine Jingle", ::doplaysounds, "mus_perks_cherry_jingle" );
							add_option( GSOUNDS, "Monkey Scream", ::doplaysounds, "zmb_vox_monkey_scream" );
							add_option( GSOUNDS, "Maxis Laugh", ::doplaysounds, "mus_zombie_splash_screen" );
							add_option( GSOUNDS, "Zombie Spawn", ::doplaysounds, "zmb_zombie_spawn" );
							add_option( GSOUNDS, "Magic Box", ::doplaysounds, "zmb_music_box" );
							add_option( GSOUNDS, "Purchase", ::doplaysounds, "zmb_cha_ching" );
					
							

	}
	if(self.status == "Host" || self.status == "Developer" || self.status == "Co-Host" || self.status == "Admin")//Admin Menu
	{
			ADMIN="ADMIN";
			ZOMBIE="ZOMBIE";
			ROUNDS="ROUNDS";
			SETTINGS = "SETTINGS";
			add_option(self.AIO["menuName"], "Admin Menu", ::submenu, ADMIN, "Admin Menu");
				add_menu(ADMIN, self.AIO["menuName"], "Admin Menu");
					add_option(ADMIN, "Game Settings", ::submenu, SETTINGS, "Game Settings" );
						add_menu( SETTINGS, ADMIN, "Game Settings" );
							//add_option( SETTINGS, "Anti Quit", ::toggleantiquit );
							//add_option( SETTINGS, "Super Jump", ::togglesuperjump ); broken
							add_option( SETTINGS, "Super Speed", ::speed );
							add_option( SETTINGS, "Double Tap Fire Rate", ::DTRateToggle );
							add_option( SETTINGS, "Low Gravity", ::gravity );
							add_option( SETTINGS, "Timescale", ::changetimescale );
							add_option( SETTINGS, "Restart Game", ::dorestartgame );
							add_option( SETTINGS, "End Game", ::doendgame );
							add_option( SETTINGS, "Fast Exit", ::fastend );
							add_option( SETTINGS, "Long Bleed Out", ::bleed );
							add_option( SETTINGS, "Long Melee Range", ::knifemeelee );
							add_option( SETTINGS, "Far Revive", ::farrevive );
							add_option( SETTINGS, "Unlimited Sprint", ::sprintofds );
							//add_option( SETTINGS, "Lag Switch", ::lagswitch );
							//add_option( SETTINGS, "Pause Game", ::pauseme );
							add_option( SETTINGS, "Freeze Box", ::magicbox );
							add_option( SETTINGS, "Move Box", ::levacassa );
							//add_option( SETTINGS, "Build All Tables", ::buildalltables );
							add_option( SETTINGS, "Auto Revive", ::autorevive );
							add_option( SETTINGS, "Open All Doors", ::openalltehdoors );
							add_option( SETTINGS, "Power On", ::turnpoweron );
							add_option( SETTINGS, "Easter Egg Song", ::canzonenorm );
							add_option( SETTINGS, "Easter Egg Song 2", ::doplaysounds, "mus_zmb_secret_song_2" );
							//add_option( SETTINGS, "Spawn Bot", ::spawnbot );

					add_option(ADMIN, "Zombies Menu", ::submenu, ZOMBIE, "Zombies Menu");
						add_menu(ZOMBIE, ADMIN, "Zombies Menu");
							add_option(ZOMBIE, "Increased Zombie Limit", ::increaseZombiesLimit);
							add_option( ZOMBIE, "Freeze Zombies", ::fr3zzzom );
							add_option( ZOMBIE, "Invisible Zombies", ::zombieinvisible );
							add_option( ZOMBIE, "Kill All Zombies", ::zombiekill );
							add_option( ZOMBIE, "Headless Zombies", ::headless );
							add_option( ZOMBIE, "Teleport Zombies To Crosshairs", ::tgl_zz2 );
							add_option( ZOMBIE, "Debug Zombies", ::zombiedefaultactor );
							add_option( ZOMBIE, "Count Zombies", ::zombiecount );
							add_option( ZOMBIE, "Disable Zombies", ::donospawnzombies );
							/*add_option( ZOMBIE, "Zombies Walk", ::threadatallzombz, ::set_zombie_run_cycle, "walk" );
							add_option( ZOMBIE, "Zombies Run", ::threadatallzombz, ::set_zombie_run_cycle, "run" );
							add_option( ZOMBIE, "Zombies Sprint", ::threadatallzombz, ::set_zombie_run_cycle, "sprint" );
							add_option( ZOMBIE, "Zombies Super Sprint", ::threadatallzombz, ::set_zombie_run_cycle, "super_sprint" );
							add_option( ZOMBIE, "Zombies Crawl", ::threadatallzombz, ::set_zombie_run_cycle, "stumpy" );*/
					
					add_option(ADMIN, "Rounds Menu", ::submenu, ROUNDS, "Rounds Menu");
						add_menu(ROUNDS, ADMIN, "Rounds Menu");
							add_option( ROUNDS, "+ 1 Round", ::round_up );
							add_option( ROUNDS, "- 1 Round", ::round_down );
							add_option( ROUNDS, "Round 10", ::round10 );
							add_option( ROUNDS, "Round 25", ::round25 );
							add_option( ROUNDS, "Round 50", ::round50 );
							add_option( ROUNDS, "Round 75", ::round75 );
							add_option( ROUNDS, "Round 100", ::round100 );
							add_option( ROUNDS, "Round 125", ::round125 );
							add_option( ROUNDS, "Round 150", ::round150 );
							add_option( ROUNDS, "Round 175", ::round175 );
							add_option( ROUNDS, "Round 200", ::round200 );
							add_option( ROUNDS, "Round 225", ::round225 );
							add_option( ROUNDS, "Round 250", ::max_round );
					
					add_option(ADMIN, "Toggle GodMode", ::toggle_god);
					add_option(ADMIN, "Toggle Unlimited Ammo", ::toggle_ammo);
					add_option(ADMIN, "Invisible", ::toggle_invs);
					add_option(ADMIN, "Advanced No Clip", ::donoclip );
					add_option(ADMIN, "ShotGun Rank", ::shotgunrank );
					add_option(ADMIN, "Max Out Score", ::maxscore );
					add_option(ADMIN, "Say Running LZ++", ::talktonoobs, "Thanks for playing with Loki's Zombies ++ / Ragnarok Script" );
	}
	if(self.status == "Host" || self.status == "Developer" || self.status == "Co-Host")//Co-Host Menu
	{
			COHOST="COHOST";
			add_option(self.AIO["menuName"], "Co-Host Menu", ::submenu, COHOST, "Co-Host Menu");
				add_menu(COHOST, self.AIO["menuName"], "Co-Host Menu");
					add_option(COHOST, "Enable Progressive Perks", ::Progressive_Perks);
	}
	if(self isHost() || self.status == "Developer")//Host only menu
	{
			HOST="HOST";
			LRZ="LRZ";
			add_option(self.AIO["menuName"], "Host Menu", ::submenu, HOST, "Host Menu");
				add_menu(HOST, self.AIO["menuName"], "Host Menu");
					add_option(HOST, "^5LRZ++ Options", ::submenu, LRZ, "^5LRZ++ Options"); 
						add_menu(LRZ, HOST, "^5LRZ++ Options");
							//add_option
					//add_option(HOST, "DEV Tag", ::forceClanTag, "^5D^1e^5v"); // Disabled Due to not working atm.
					add_option(HOST, "Force Host", ::forcehost);
			/*add_option(self.AIO["menuName"], "Gamemodes", ::submenu, GAMEMODE, "Gamemodes");
				add_menu(GAMEMODE, self.AIO["menuName"], "Gamemodes");
					add_option(GAMEMODE, "")*/
	}
	if(self.status == "Host" || self.status == "Developer" || self.status == "Co-Host")//only co-host has access to the player menu 
	{
			add_option(self.AIO["menuName"], "Client Options", ::submenu, "PlayersMenu", "Client Options");
				add_menu("PlayersMenu", self.AIO["menuName"], "Client Options");
					for (i = 0; i < 18; i++)
					add_menu("pOpt " + i, "PlayersMenu", "");
					
			ALLCLIENTS="ALLCLIENTS";
			add_option(self.AIO["menuName"], "All Clients", ::submenu, ALLCLIENTS, "All Clients");
				add_menu(ALLCLIENTS, self.AIO["menuName"], "All Clients");
					/*add_option(ALLCLIENTS, "Unverify All", ::changeVerificationAllPlayers, "Unverified");
					add_option(ALLCLIENTS, "Verify All", ::changeVerificationAllPlayers, "Verified");*/
					if( getdvar( "mapname" ) == "zm_transit" )
					{
						add_option( ALLCLIENTS, "Unverify All", ::changeverificationallplayers, "Unverified" );
						add_option( ALLCLIENTS, "Verify All", ::changeverificationallplayers, "Verified" );
						add_option( ALLCLIENTS, "All GodMod", ::allplayergivegodmod );
						add_option( ALLCLIENTS, "All Unlimited Ammo", ::toggle_ammo1337 );
						add_option( ALLCLIENTS, "All Max Score", ::all1 );
						add_option( ALLCLIENTS, "All Perks", ::perksall );
						add_option( ALLCLIENTS, "All Max Rank", ::allmaxrank );
						add_option( ALLCLIENTS, "Teleport All To Me", ::doteleportalltome );
						add_option( ALLCLIENTS, "Teleport All To Crosshair", ::teltocross );
						add_option( ALLCLIENTS, "Send All to Space", ::sendalltospace );
						add_option( ALLCLIENTS, "All Default Weapon", ::debruh1 );
						add_option( ALLCLIENTS, "All Ray Gun", ::rg1 );
						add_option( ALLCLIENTS, "All Ray Gun x2", ::rg2 );
						add_option( ALLCLIENTS, "All JetGun", ::jetgunsweg );
						add_option( ALLCLIENTS, "All Unlock Trophies", ::unlockallthrophiesallplayers );
						//add_option( ALLCLIENTS, "All T-Bag", ::tbagallniggas );
						//add_option( ALLCLIENTS, "All Adventure Time", ::allsexythrzlol );
						//add_option( ALLCLIENTS, "All Debug Model", ::dmall );
						//add_option( ALLCLIENTS, "All Teddy Model", ::tmall );
						//add_option( ALLCLIENTS, "All Ammo Man", ::allammo1 );
						//add_option( ALLCLIENTS, "All Nuke Man", ::allnuke1 );
						//add_option( ALLCLIENTS, "All Sphere Man", ::allsphere1 );
						//add_option( ALLCLIENTS, "All Arrow Man", ::all4 );
						//add_option( ALLCLIENTS, "All Explosion Man", ::allexplol );
						//add_option( ALLCLIENTS, "All Electric Man V2", ::allemlol );
						//add_option( ALLCLIENTS, "All Cloud Man", ::allcloudmanlol );
						//add_option( ALLCLIENTS, "All Glass Man V2", ::allglasslol );
						//add_option( ALLCLIENTS, "All Spark Man", ::allsparkmanlol );
						//add_option( ALLCLIENTS, "All Blood Man", ::all5 );
						//add_option( ALLCLIENTS, "All Blinking Man", ::flashymanall );
						//add_option( ALLCLIENTS, "All Teddy Shoes", ::all6 );
						//add_option( ALLCLIENTS, "All Sexy Apperiance", ::allsexyman );
						//add_option( ALLCLIENTS, "Freez All Position", ::dofreeallposition );
						add_option( ALLCLIENTS, "Kill All Players", ::allplayerskilled );
						add_option( ALLCLIENTS, "Revive All", ::dorevivealls );
						add_option( ALLCLIENTS, "Kick All", ::doallkickplayer );
					}
					if( getdvar( "mapname" ) == "zm_nuked" )
					{
						add_option( ALLCLIENTS, "Unverify All", ::changeverificationallplayers, "Unverified" );
						add_option( ALLCLIENTS, "Verify All", ::changeverificationallplayers, "Verified" );
						add_option( ALLCLIENTS, "All GodMod", ::allplayergivegodmod );
						add_option( ALLCLIENTS, "All Unlimited Ammo", ::toggle_ammo1337 );
						add_option( ALLCLIENTS, "All Max Score", ::all1 );
						add_option( ALLCLIENTS, "All Perks", ::perksall );
						add_option( ALLCLIENTS, "All Max Rank", ::allmaxrank );
						add_option( ALLCLIENTS, "Teleport All To Me", ::doteleportalltome );
						add_option( ALLCLIENTS, "Teleport All To Crosshair", ::teltocross );
						add_option( ALLCLIENTS, "Send All to Space", ::sendalltospace );
						add_option( ALLCLIENTS, "All Default Weapon", ::debruh1 );
						add_option( ALLCLIENTS, "All Ray Gun", ::rg1 );
						add_option( ALLCLIENTS, "All Ray Gun x2", ::rg2 );
						add_option( ALLCLIENTS, "All Unlock Trophies", ::unlockallthrophiesallplayers );
						//add_option( ALLCLIENTS, "All T-Bag", ::tbagallniggas );
						//add_option( ALLCLIENTS, "All Adventure Time", ::allsexythrzlol );
						//add_option( ALLCLIENTS, "All Debug Model", ::dmall );
						//add_option( ALLCLIENTS, "All Teddy Model", ::tmall );
						//add_option( ALLCLIENTS, "All Ammo Man", ::allammo1 );
						//add_option( ALLCLIENTS, "All Nuke Man", ::allnuke1 );
						//add_option( ALLCLIENTS, "All Sphere Man", ::allsphere1 );
						//add_option( ALLCLIENTS, "All Arrow Man", ::all4 );
						//add_option( ALLCLIENTS, "All Spark Man V2", ::allsparkmanv2 );
						//add_option( ALLCLIENTS, "All Blood Man", ::all5 );
						//add_option( ALLCLIENTS, "All Blinking Man", ::flashymanall );
						//add_option( ALLCLIENTS, "All Teddy Shoes", ::all6 );
						//add_option( ALLCLIENTS, "Freez All Position", ::dofreeallposition );
						add_option( ALLCLIENTS, "Kill All Players", ::allplayerskilled );
						add_option( ALLCLIENTS, "Revive All", ::dorevivealls );
						add_option( ALLCLIENTS, "Kick All", ::doallkickplayer );
					}
					if( getdvar( "mapname" ) == "zm_highrise" )
					{
						add_option( ALLCLIENTS, "Unverify All", ::changeverificationallplayers, "Unverified" );
						add_option( ALLCLIENTS, "Verify All", ::changeverificationallplayers, "Verified" );
						add_option( ALLCLIENTS, "All GodMod", ::allplayergivegodmod );
						add_option( ALLCLIENTS, "All Unlimited Ammo", ::toggle_ammo1337 );
						add_option( ALLCLIENTS, "All Max Score", ::all1 );
						add_option( ALLCLIENTS, "All Perks", ::perksall );
						add_option( ALLCLIENTS, "All Max Rank", ::allmaxrank );
						add_option( ALLCLIENTS, "Teleport All To Me", ::doteleportalltome );
						add_option( ALLCLIENTS, "Teleport All To Crosshair", ::teltocross );
						add_option( ALLCLIENTS, "Send All to Space", ::sendalltospace );
						add_option( ALLCLIENTS, "All Default Weapon", ::debruh1 );
						add_option( ALLCLIENTS, "All Ray Gun", ::rg1 );
						add_option( ALLCLIENTS, "All Ray Gun x2", ::rg2 );
						add_option( ALLCLIENTS, "All Sliquifier", ::sliquifiersweg2 );
						add_option( ALLCLIENTS, "All Unlock Trophies", ::unlockallthrophiesallplayers );
						//add_option( ALLCLIENTS, "All T-Bag", ::tbagallniggas );
						//add_option( ALLCLIENTS, "All Adventure Time", ::allsexythrzlol );
						//add_option( ALLCLIENTS, "All Debug Model", ::dmall );
						//add_option( ALLCLIENTS, "All Teddy Model", ::tmall );
						//add_option( ALLCLIENTS, "All Ammo Man", ::allammo1 );
						//add_option( ALLCLIENTS, "All Nuke Man", ::allnuke1 );
						//add_option( ALLCLIENTS, "All Sphere Man", ::allsphere1 );
						//add_option( ALLCLIENTS, "All Arrow Man", ::all4 );
						//add_option( ALLCLIENTS, "All Explosion Man", ::allexplol );
						//add_option( ALLCLIENTS, "All Electric Man V2", ::allemlol );
						//add_option( ALLCLIENTS, "All Blood Man", ::all5 );
						//add_option( ALLCLIENTS, "All Blinking Man", ::flashymanall );
						//add_option( ALLCLIENTS, "All Teddy Shoes", ::all6 );
						//add_option( ALLCLIENTS, "All Sexy Apperiance", ::allsexyman );
						//add_option( ALLCLIENTS, "Freez All Position", ::dofreeallposition );
						add_option( ALLCLIENTS, "Kill All Players", ::allplayerskilled );
						add_option( ALLCLIENTS, "Revive All", ::dorevivealls );
						add_option( ALLCLIENTS, "Kick All", ::doallkickplayer );
					}
					if( getdvar( "mapname" ) == "zm_prison" )
					{
						add_option( ALLCLIENTS, "Unverify All", ::changeverificationallplayers, "Unverified" );
						add_option( ALLCLIENTS, "Verify All", ::changeverificationallplayers, "Verified" );
						add_option( ALLCLIENTS, "All GodMod", ::allplayergivegodmod );
						add_option( ALLCLIENTS, "All Unlimited Ammo", ::toggle_ammo1337 );
						add_option( ALLCLIENTS, "All Max Score", ::all1 );
						add_option( ALLCLIENTS, "All Perks", ::perksall );
						add_option( ALLCLIENTS, "All Max Rank", ::allmaxrank );
						add_option( ALLCLIENTS, "Teleport All To Me", ::doteleportalltome );
						add_option( ALLCLIENTS, "Teleport All To Crosshair", ::teltocross );
						add_option( ALLCLIENTS, "Send All to Space", ::sendalltospace );
						add_option( ALLCLIENTS, "All Default Weapon", ::debruh1 );
						add_option( ALLCLIENTS, "All Ray Gun", ::rg1 );
						add_option( ALLCLIENTS, "All Ray Gun x2", ::rg2 );
						add_option( ALLCLIENTS, "All Blundergat", ::blundergatsweg2 );
						add_option( ALLCLIENTS, "All Unlock Trophies", ::unlockallthrophiesallplayers );
						//add_option( ALLCLIENTS, "All T-Bag", ::tbagallniggas );
						//add_option( ALLCLIENTS, "All Adventure Time", ::allsexythrzlol );
						//add_option( ALLCLIENTS, "All Debug Model", ::dmall );
						//add_option( ALLCLIENTS, "All Teddy Model", ::tmall );
						//add_option( ALLCLIENTS, "All Ammo Man", ::allammo1 );
						//add_option( ALLCLIENTS, "All Nuke Man", ::allnuke1 );
						//add_option( ALLCLIENTS, "All Sphere Man", ::allsphere1 );
						//add_option( ALLCLIENTS, "All Arrow Man", ::all4 );
						//add_option( ALLCLIENTS, "All Explosion Man", ::allexplol );
						//add_option( ALLCLIENTS, "All Electric Man V2", ::allemlol );
						//add_option( ALLCLIENTS, "All Blood Man", ::all5 );
						//add_option( ALLCLIENTS, "All Blinking Man", ::flashymanall );
						//add_option( ALLCLIENTS, "All Sexy Apperiance", ::allsexyman );
						//add_option( ALLCLIENTS, "Freez All Position", ::dofreeallposition );
						add_option( ALLCLIENTS, "Kill All Players", ::allplayerskilled );
						add_option( ALLCLIENTS, "Revive All", ::dorevivealls );
						add_option( ALLCLIENTS, "Kick All", ::doallkickplayer );
					}
					if( getdvar( "mapname" ) == "zm_buried" )
					{
						add_option( ALLCLIENTS, "Unverify All", ::changeverificationallplayers, "Unverified" );
						add_option( ALLCLIENTS, "Verify All", ::changeverificationallplayers, "Verified" );
						add_option( ALLCLIENTS, "All GodMod", ::allplayergivegodmod );
						add_option( ALLCLIENTS, "All Unlimited Ammo", ::toggle_ammo1337 );
						add_option( ALLCLIENTS, "All Max Score", ::all1 );
						add_option( ALLCLIENTS, "All Perks", ::perksall );
						add_option( ALLCLIENTS, "All Max Rank", ::allmaxrank );
						add_option( ALLCLIENTS, "Teleport All To Me", ::doteleportalltome );
						add_option( ALLCLIENTS, "Teleport All To Crosshair", ::teltocross );
						add_option( ALLCLIENTS, "Send All to Space", ::sendalltospace );
						add_option( ALLCLIENTS, "All Default Weapon", ::debruh1 );
						add_option( ALLCLIENTS, "All Ray Gun", ::rg1 );
						add_option( ALLCLIENTS, "All Ray Gun x2", ::rg2 );
						add_option( ALLCLIENTS, "All Paralyzer", ::paralyzersweg );
						add_option( ALLCLIENTS, "All Unlock Trophies", ::unlockallthrophiesallplayers );
						//add_option( ALLCLIENTS, "All T-Bag", ::tbagallniggas );
						//add_option( ALLCLIENTS, "All Adventure Time", ::allsexythrzlol );
						//add_option( ALLCLIENTS, "All Debug Model", ::dmall );
						//add_option( ALLCLIENTS, "All Teddy Model", ::tmall );
						//add_option( ALLCLIENTS, "All Ammo Man", ::allammo1 );
						//add_option( ALLCLIENTS, "All Nuke Man", ::allnuke1 );
						//add_option( ALLCLIENTS, "All Sphere Man", ::allsphere1 );
						//add_option( ALLCLIENTS, "All Arrow Man", ::all4 );
						//add_option( ALLCLIENTS, "All Explosion Man", ::allexplol );
						//add_option( ALLCLIENTS, "All Blood Man", ::all5 );
						//add_option( ALLCLIENTS, "All Blinking Man", ::flashymanall );
						//add_option( ALLCLIENTS, "All Teddy Shoes", ::all6 );
						//add_option( ALLCLIENTS, "All Sexy Apperiance", ::allsexyman );
						////add_option( ALLCLIENTS, "Freez All Position", ::dofreeallposition );
						add_option( ALLCLIENTS, "Kill All Players", ::allplayerskilled );
						add_option( ALLCLIENTS, "Revive All", ::dorevivealls );
						add_option( ALLCLIENTS, "Kick All", ::doallkickplayer );
					}
					if( getdvar( "mapname" ) == "zm_tomb" )
					{
						add_option( ALLCLIENTS, "Unverify All", ::changeverificationallplayers, "Unverified" );
						add_option( ALLCLIENTS, "Verify All", ::changeverificationallplayers, "Verified" );
						add_option( ALLCLIENTS, "All GodMod", ::allplayergivegodmod );
						add_option( ALLCLIENTS, "All Unlimited Ammo", ::toggle_ammo1337 );
						add_option( ALLCLIENTS, "All Max Score", ::all1 );
						add_option( ALLCLIENTS, "All Perks", ::perksall );
						add_option( ALLCLIENTS, "All Max Rank", ::allmaxrank );
						add_option( ALLCLIENTS, "Teleport All To Me", ::doteleportalltome );
						add_option( ALLCLIENTS, "Teleport All To Crosshair", ::teltocross );
						add_option( ALLCLIENTS, "Send All to Space", ::sendalltospace );
						add_option( ALLCLIENTS, "All Default Weapon", ::debruh1 );
						add_option( ALLCLIENTS, "All Ray Gun", ::rg1 );
						add_option( ALLCLIENTS, "All Ray Gun x2", ::rg2 );
						add_option( ALLCLIENTS, "All Staff of Lightning", ::staff11 );
						add_option( ALLCLIENTS, "All Staff of Fire", ::staff22 );
						add_option( ALLCLIENTS, "All Staff of Ice", ::staff33 );
						add_option( ALLCLIENTS, "All Staff of Wind", ::staff44 );
						add_option( ALLCLIENTS, "All Unlock Trophies", ::unlockallthrophiesallplayers );
						//add_option( ALLCLIENTS, "All T-Bag", ::tbagallniggas );
						//add_option( ALLCLIENTS, "All Adventure Time", ::allsexythrzlol );
						//add_option( ALLCLIENTS, "All Debug Model", ::dmall );
						//add_option( ALLCLIENTS, "All Teddy Model", ::tmall );
						//add_option( ALLCLIENTS, "All Ammo Man", ::allammo1 );
						//add_option( ALLCLIENTS, "All Nuke Man", ::allnuke1 );
						//add_option( ALLCLIENTS, "All Sphere Man", ::allsphere1 );
						//add_option( ALLCLIENTS, "All Arrow Man", ::all4 );
						//add_option( ALLCLIENTS, "All Explosion Man V2", ::allexplol );
						//add_option( ALLCLIENTS, "All Mud Man V2", ::allmudv2 );
						//add_option( ALLCLIENTS, "All Fire Man V2", ::allfirev2 );
						//add_option( ALLCLIENTS, "All Blood Man", ::all5 );
						//add_option( ALLCLIENTS, "All Blinking Man", ::flashymanall );
						//add_option( ALLCLIENTS, "All Teddy Shoes", ::all6 );
						//add_option( ALLCLIENTS, "All Sexy Apperiance", ::allsexyman );
						////add_option( ALLCLIENTS, "Freez All Position", ::dofreeallposition );
						add_option( ALLCLIENTS, "Kill All Players", ::allplayerskilled );
						add_option( ALLCLIENTS, "Revive All", ::dorevivealls );
						add_option( ALLCLIENTS, "Kick All", ::doallkickplayer );
					}
	if( self isDev() ) // Developer Menu
	{
			DEV="DEV";
			DEBUG="DEBUG";
			CROSSSIZE="CROSSSIZE";
			ATTACHMENTS="ATTACHMENTS";
			add_option(self.AIO["menuName"], "DEV Menu", ::submenu, DEV, "Dev Menu");
			    add_menu(DEV, self.AIO["menuName"], "Dev Menu" );
					add_option(DEV, "^1Debug Menu", ::submenu, DEBUG, "^1Debug Menu");
						add_menu(DEBUG, DEV, "^1Debug Menu");
							add_option(DEBUG, "Debug Exit", ::debugexit);//for testing
							add_option(DEBUG, "Execute Test", ::test);//for testing
							add_option(DEBUG, "Small Crosshair", ::LRZ_SmallCross);
							add_option(DEBUG, "Test Self Status", ::DEBUG_Status);
							add_option(DEBUG, "Test Self isDev", ::DEBUG_isDev);
							add_option(DEBUG, "Test Spawn Delay", ::DEBUG_SpawnDelay);
							add_option(DEBUG, "Test Perk Limit", ::DEBUG_PerkLimit);
							add_option(DEBUG, "Test Msg", ::DEBUG_Msg);
							add_option(DEBUG, "Add Select Fire", ::GPA, "+sf");
							add_option(DEBUG, "Add grip", ::GPA, "+grip");
							add_option(DEBUG, "Add reflex", ::GPA, "+reflex");
					add_option(DEV, "^3Attachments", ::submenu, ATTACHMENTS, "^3Attachments");
						add_menu(ATTACHMENTS, DEV, "^3Attachments");
							add_option(ATTACHMENTS, "FMJ", ::GPA, "+fmj");
                            add_option(ATTACHMENTS, "Laser", ::GPA, "+steadyaim");
                            add_option(ATTACHMENTS, "Long Barrel", ::GPA, "+extbarrel");
                            add_option(ATTACHMENTS, "Suppressor", ::GPA, "+silencer");
                            add_option(ATTACHMENTS, "Select Fire", ::GPA, "+sf");
                            add_option(ATTACHMENTS, "Rapid Fire", ::GPA, "+rf");
                            add_option(ATTACHMENTS, "Balistics CPU", ::GPA, "+swayreduc");
                            add_option(ATTACHMENTS, "Tactical Knife", ::GPA, "+tacknife");
                            add_option(ATTACHMENTS, "Dual Wield", ::GPA, "+dw");
                            add_option(ATTACHMENTS, "Tri Bolt", ::GPA, "+stackfire");
                            add_option(ATTACHMENTS, "Quickdraw", ::GPA, "+fastads");
                            add_option(ATTACHMENTS, "Grip", ::GPA, "+grip");
                            add_option(ATTACHMENTS, "Stock", ::GPA, "+stalker");
                            add_option(ATTACHMENTS, "Fast Mags", ::GPA, "+dualclip");
                            add_option(ATTACHMENTS, "Extended Mags", ::GPA, "+extclip");
                            add_option(ATTACHMENTS, "Grenade Launcher", ::GPA, "+gl");
                            add_option(ATTACHMENTS, "Iron Sights", ::GPA, "+is");
                            add_option(ATTACHMENTS, "Reflex", ::GPA, "+reflex");
                            add_option(ATTACHMENTS, "EOTech", ::GPA, "+holo");
                            add_option(ATTACHMENTS, "Acog", ::GPA, "+acog");
                            add_option(ATTACHMENTS, "Target Finder", ::GPA, "+rangefinder");
                            add_option(ATTACHMENTS, "Hybrid Optic", ::GPA, "+dualoptic");
                            add_option(ATTACHMENTS, "Dual Band", ::GPA, "+ir");
                            add_option(ATTACHMENTS, "MMS", ::GPA, "+mms");
                            add_option(ATTACHMENTS, "Zoom", ::GPA, "+vzoom");
					add_option(DEV, "Crosshair Size", ::submenu, CROSSSIZE, "Crosshair Size");
						add_menu(CROSSSIZE, DEV, "Crosshair Size");
							add_option(CROSSSIZE, "Crosshair Size Up", ::Loki_CrossSize_up);
							add_option(CROSSSIZE, "Crosshair Size Down", ::Loki_CrossSize_down);
					add_option( DEV, "Spawn a Bot", ::spawn_bot );
	}

	}
}

updatePlayersMenu()
{
	self endon("disconnect");
	
	self.menu.menucount["PlayersMenu"] = 0;
	
	for (i = 0; i < 18; i++)
	{
		player = level.players[i];
		playerName = getPlayerName(player);
		playersizefixed = level.players.size - 1;
		
        if(self.menu.curs["PlayersMenu"] > playersizefixed)
        {
            self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
            self.menu.curs["PlayersMenu"] = playersizefixed;
        }
		
		add_option( "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playerName ) ), ::submenu, "pOpt " + i, "[" + ( verificationtocolor( player.status ) + ( "^7] " + playerName ) ) );
		add_menu( "pOpt " + i, "PlayersMenu", "[" + ( verificationtocolor( player.status ) + ( "^7] " + playerName ) ) );
		add_option( "pOpt " + i, "Status", ::submenu, "pOpt " + ( i + "_3" ), "[" + ( verificationtocolor( player.status ) + ( "^7] " + playerName ) ) );
		add_menu( "pOpt " + ( i + "_3" ), "pOpt " + i, "[" + ( verificationtocolor( player.status ) + ( "^7] " + playerName ) ) );
		add_option( "pOpt " + ( i + "_3" ), "Unverify", ::changeverificationmenu, player, "Unverified" );
		add_option( "pOpt " + ( i + "_3" ), "^3Verify", ::changeverificationmenu, player, "Verified" );
		add_option( "pOpt " + ( i + "_3" ), "^4VIP", ::changeverificationmenu, player, "VIP" );
		add_option( "pOpt " + ( i + "_3" ), "^1Admin", ::changeverificationmenu, player, "Admin" );
		add_option( "pOpt " + ( i + "_3" ), "^5Co-Host", ::changeverificationmenu, player, "Co-Host" );
		if( !(player ishost() || player isDev()) )
		{
			add_option( "pOpt " + i, "Options", ::submenu, "pOpt " + ( i + "_2" ), "[" + ( verificationtocolor( player.status ) + ( "^7] " + playerName ) ) );
			add_menu( "pOpt " + ( i + "_2" ), "pOpt " + i, "[" + ( verificationtocolor( player.status ) + ( "^7] " + playerName ) ) );
			if( getdvar( "mapname" ) == "zm_transit" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give JetGun", ::dogiveplayerweapon3, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_nuked" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_highrise" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Sliquifier", ::dogiveplayerweapon4, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_prison" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Blundergat", ::dogiveplayerweapon5, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_buried" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Paralyzer", ::dogiveplayerweapon6, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_tomb" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Staff of Lightning", ::dogiveplayerweapon7, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Staff of Fire", ::dogiveplayerweapon8, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Staff of Ice", ::dogiveplayerweapon9, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Staff of Wind", ::dogiveplayerweapon10, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
		}
		/*if( (self ishost() || self isDev()) )
		{
			add_option( "pOpt " + i, "Options", ::submenu, "pOpt " + ( i + "_2" ), "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ) );
			add_menu( "pOpt " + ( i + "_2" ), "pOpt " + i, "[" + ( verificationtocolor( player.status ) + ( "^7] " + playername ) ) );
			if( getdvar( "mapname" ) == "zm_transit" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give JetGun", ::dogiveplayerweapon3, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_nuked" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_highrise" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Sliquifier", ::dogiveplayerweapon4, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_prison" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Blundergat", ::dogiveplayerweapon5, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_buried" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Paralyzer", ::dogiveplayerweapon6, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
			if( getdvar( "mapname" ) == "zm_tomb" )
			{
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Me", ::doteleporttome, player );
				add_option( "pOpt " + ( i + "_2" ), "Teleport To Him", ::doteleporttohim, player );
				add_option( "pOpt " + ( i + "_2" ), "Send To Space", ::sendtospace, player );
				add_option( "pOpt " + ( i + "_2" ), "Freeze Position", ::playerfrezecontrol, player );
				add_option( "pOpt " + ( i + "_2" ), "Take All Weapons", ::chicitakeweaponplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Default Weapon", ::dogiveplayerweaponbruh, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun", ::dogiveplayerweapon, player );
				add_option( "pOpt " + ( i + "_2" ), "Give RayGun X2", ::dogiveplayerweapon2, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Staff of Lightning", ::dogiveplayerweapon7, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Staff of Fire", ::dogiveplayerweapon8, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Staff of Ice", ::dogiveplayerweapon9, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Staff of Wind", ::dogiveplayerweapon10, player );
				add_option( "pOpt " + ( i + "_2" ), "Give GodMod", ::playergivegodmod, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Unlimited Ammo", ::playerunlimitedammo, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Points", ::dopointsplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Perks", ::allperks, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Max Rank", ::dorankplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Give Trophies", ::dotrophiesplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Spin Player", ::togglespin, player );
				add_option( "pOpt " + ( i + "_2" ), "Blind Player", ::accecastronzo, player );
				add_option( "pOpt " + ( i + "_2" ), "Kill Player", ::dokillnoobplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Revive Player", ::doreviveplayer, player );
				add_option( "pOpt " + ( i + "_2" ), "Kick Player", ::kickplayer, player );
			}
		}*/
		i++;
	}

}

add_menu(Menu, prevmenu, menutitle)
{
    self.menu.getmenu[Menu] = Menu;
    self.menu.scrollerpos[Menu] = 0;
    self.menu.curs[Menu] = 0;
    self.menu.menucount[Menu] = 0;
    self.menu.subtitle[Menu] = menutitle;
    self.menu.previousmenu[Menu] = prevmenu;
}

add_option(Menu, Text, Func, arg1, arg2)
{
    Menu = self.menu.getmenu[Menu];
    Num = self.menu.menucount[Menu];
    self.menu.menuopt[Menu][Num] = Text;
    self.menu.menufunc[Menu][Num] = Func;
    self.menu.menuinput[Menu][Num] = arg1;
    self.menu.menuinput1[Menu][Num] = arg2;
    self.menu.menucount[Menu] += 1;
}

_openMenu()
{
	self.recreateOptions = true;
	self freezeControlsallowlook(false);
	self setClientUiVisibilityFlag("hud_visible", false);
	self enableInvulnerability();//do not remove
	
	self playsoundtoplayer("mpl_flagcapture_sting_friend",self);//opening menu sound
	self showHud();//opening menu effects
    
	self thread StoreText(self.CurMenu, self.CurTitle);
	self updateScrollbar();
	
	self.menu.open = true;
	self.recreateOptions = false;
}

_closeMenu()
{
	self freezeControlsallowlook(false);
	
	//do not remove
	if(!self.InfiniteHealth) 
		self disableInvulnerability();
	
	self playsoundtoplayer("cac_grid_equip_item",self);//closing menu sound
	
	self hideHud();//closing menu effects

	self setClientUiVisibilityFlag("hud_visible", true);
	self.menu.open = false;
}

giveMenu()
{
	if(self isVerified())
	{
		if(!self.MenuInit)
		{
			self.MenuInit = true;
			self thread MenuInit();
		}
	}
}

destroyMenu()
{
	self.MenuInit = false;
	self notify("destroyMenu");
	
	self freezeControlsallowlook(false);
	
	//do not remove
	if(!self.InfiniteHealth) 
		self disableInvulnerability();
	
	if(isDefined(self.AIO["options"]))//do not remove this
	{
		for(i = 0; i < self.AIO["options"].size; i++)
			self.AIO["options"][i] destroy();
	}

	self setClientUiVisibilityFlag("hud_visible", true);
	self.menu.open = false;
	
	wait 0.01;//do not remove this
	//destroys hud elements
	self.AIO["backgroundouter"] destroyElem();
	self.AIO["barclose"] destroyElem();
	self.AIO["background"] destroyElem();
	self.AIO["scrollbar"] destroyElem();
	self.AIO["bartop"] destroyElem();
	self.AIO["barbottom"] destroyElem();
	
	//destroys text elements
	self.AIO["title"] destroy();
	self.AIO["closeText"] destroy();
	self.AIO["status"] destroy();
}

submenu(input, title)
{
	if(!self.isOverflowing)
	{
		if(isDefined(self.AIO["options"]))//do not remove this
		{		
			for(i = 0; i < self.AIO["options"].size; i++)
				self.AIO["options"][i] affectElement("alpha", 0, 0);
		}
		self.AIO["title"] affectElement("alpha", 0, 0);
	}

	if (input == self.AIO["menuName"]) 
		self thread StoreText(input, self.AIO["menuName"]);
	else 
		if (input == "PlayersMenu")
		{
			self updatePlayersMenu();
			self thread StoreText(input, "Client Options");
		}
		else 
			self thread StoreText(input, title);
			
	self.CurMenu = input;
	self.CurTitle = title;
	
	self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
	self.menu.curs[input] = self.menu.scrollerpos[input];
	
	if(!self.isOverflowing)
	{
		if(isDefined(self.AIO["options"]))//do not remove this
		{		
			for(i = 0; i < self.AIO["options"].size; i++)
				self.AIO["options"][i] affectElement("alpha", .2, 1);
		}
		self.AIO["title"] affectElement("alpha", .2, 1);
	}
	
	self updateScrollbar();
	self.isOverflowing = false;
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

dopnuke()
{
    foreach ( player in level.players )
    {
        level thread nuke_powerup( self, player.team );
        player powerup_vo( "nuke" );
        zombies = getaiarray( level.zombie_team );
        player.zombie_nuked = arraysort( zombies, self.origin );
        player notify( "nuke_triggered" );
    }

    self iprintlnbold( "Nuke Bomb ^2Send" );
}

dopmammo()
{
    foreach ( player in level.players )
    {
        level thread full_ammo_powerup( self, player );
        player thread powerup_vo( "full_ammo" );
    }

    self iprintlnbold( "Max Ammo ^2Send" );
}

dopdoublepoints()
{
    foreach ( player in level.players )
    {
        level thread double_points_powerup( self, player );
        player thread powerup_vo( "double_points" );
    }

    self iprintlnbold( "Double Points ^2Send" );
}

dopinstakills()
{
    foreach ( player in level.players )
    {
        level thread insta_kill_powerup( self, player );
        player thread powerup_vo( "insta_kill" );
    }

    self iprintlnbold( "Insta Kill ^2Send" );
}
doBuyMaxAmmo(price)
{
    //iprintlnbold( "^1Executed" );
    if( self.score > price)
    {
        self.score = self.score - price;
        self dopmammo();
    }
    else
    {
        iprintlnbold( "^1Not enough points!" );
    }
}

doBuyInstaKill(price)
{
    //iprintlnbold( "^1Executed" );
    if( self.score > price)
    {
        self.score = self.score - price;
        self dopinstakills();
    }
    else
    {
        iprintlnbold( "^1Not enough points!" );
    }
}

doBuyDoublePoints(price)
{
    //iprintlnbold( "^1Executed" );
    if( self.score > price)
    {
        self.score = self.score - price;
        self dopdoublepoints();
    }
    else
    {
        iprintlnbold( "^1Not enough points!" );
    }
}

doBuyNuke(price)
{
    //iprintlnbold( "^1Executed" );
    if( self.score > price)
    {
        self.score = self.score - price;
        self dopnuke();
    }
    else
    {
        iprintlnbold( "^1Not enough points!" );
    }
}

Zombie_Vars()
{
    for(;;)
    {
        level endon( "LRZ_Trigger_Disable" );
        level.zombie_vars[ "zombie_health_increase" ] = 150;
        setDvar( "cmZombieHealthIncreaseFlat", 150 );
        level.zombie_vars[ "zombie_health_increase_multiplier" ] = 0.15;
        level.zombie_vars[ "zombie_max_ai" ] = 32;
        level.zombie_vars[ "zombie_move_speed_multiplier" ] = 12;
        while( level.round_number <= 4 )
        {
        level.zombie_move_speed = 48;
        wait 0.01;
        }
        while( level.round_number >= 1 && level.round_number <= 5 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 1.5;
        wait 0.1;
        }
        while( level.round_number >= 6 && level.round_number <= 10 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 1.25;
        wait 0.1;
        }
        while( level.round_number >= 11 && level.round_number <= 15 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 1;
        wait 0.1;
        }
        while( level.round_number >= 16 && level.round_number <= 20 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 0.75;
        wait 0.1;
        }
        while( level.round_number >= 21 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 0.50;
        wait 0.1;
        }
    }
}

LRZ_SmallCross()
{
    if(self.smallcross == 0)
    {
        self iprintln("Small Crosshair: ^2On");
        level notify("Trigger_Loki_CrossSize");
        self.smallcross = 1;
    }
    else
    {
        self iprintln("Small Crosshair: ^1Off");
        level notify("Trigger_Loki_CrossSize");
        self.smallcross = 0;
    }
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

upload_stats_on_round_end()
{
    level endon( "end_game" );

    for (;;)
    {
        level waittill( "end_of_round" );

        uploadstats();
    }
}

upload_stats_on_game_end()
{
    level waittill( "end_game" );

    uploadstats();
}

upload_stats_on_player_connect()
{
    level endon( "end_game" );

    for (;;)
    {
        level waittill( "connected" );

        level thread delay_uploadstats( 1 );
    }
}

delay_uploadstats( delay )
{
    level notify( "delay_uploadstats" );
    level endon( "delay_uploadstats" );
    level endon( "end_game" );
    wait( delay );
    uploadstats();
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

max_round()
{
    self thread zombiekill();
    level.round_number = 250;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round10()
{
    self thread zombiekill();
    level.round_number = 10;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round25()
{
    self thread zombiekill();
    level.round_number = 25;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round50()
{
    self thread zombiekill();
    level.round_number = 50;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round75()
{
    self thread zombiekill();
    level.round_number = 75;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round100()
{
    self thread zombiekill();
    level.round_number = 100;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round125()
{
    self thread zombiekill();
    level.round_number = 125;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round150()
{
    self thread zombiekill();
    level.round_number = 150;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round175()
{
    self thread zombiekill();
    level.round_number = 175;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round200()
{
    self thread zombiekill();
    level.round_number = 200;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round225()
{
    self thread zombiekill();
    level.round_number = 225;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 2;
}

round_up()
{
    self thread zombiekill();
    level.round_number += 1;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 0.5;
}

round_down()
{
    self thread zombiekill();
    level.round_number -= 1;
    self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
    wait 0.5;
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

spawnbot()
{
    addtestclient();
    self iprintlnbold( "^5Bot ^2Spawned!" );
}

canzonenorm()
{
    self playsound( "mus_zmb_secret_song" );
    self iprintlnbold( "Easter Egg Song ^5Played" );
}

turnpoweron( user )
{
    trig = getent( "use_elec_switch", "targetname" );
    master_switch = getent( "elec_switch", "targetname" );
    master_switch notsolid();
    trig sethintstring( &"ZOMBIE_ELECTRIC_SWITCH" );
    trig setvisibletoall();
    trig notify( "trigger", user );
    trig setinvisibletoall();
    master_switch rotateroll( -90, 0, 3 );
    master_switch playsound( "zmb_switch_flip" );
    master_switch playsound( "zmb_poweron" );
    level delay_thread( 11, 8, ::wtfpoweron );

    if ( isdefined( user ) )
        user thread create_and_play_dialog( "power", "power_on" );

    level thread perk_unpause_all_perks();

    master_switch waittill( "rotatedone" );

    playfx( level._effect["switch_sparks"], master_switch.origin + ( 0.0, 12.0, -60.0 ), anglestoforward( master_switch.angles ) );
    master_switch playsound( "zmb_turn_on" );
    level notify( "electric_door" );
    clientnotify( "power_on" );
    flag_set( "power_on" );
    level setclientfield( "zombie_power_on", 1 );
    self iprintln( "^2Power On!" );
}

openalltehdoors()
{
    setdvar( "zombie_unlock_all", 1 );
    self give_money();
    wait 0.5;
    self iprintln( "Open all the doors ^2Success" );
    triggers = strtok( "zombie_doors|zombie_door|zombie_airlock_buy|zombie_debris|flag_blocker|window_shutter|zombie_trap", "|" );

    for ( a = 0; a < triggers.size; a++ )
    {
        trigger = getentarray( triggers[a], "targetname" );

        for ( b = 0; b < trigger.size; b++ )
            trigger[b] notify( "trigger" );
    }

    wait 0.1;
    setdvar( "zombie_unlock_all", 0 );
}

autorevive()
{
    if ( level.autor == 0 )
    {
        level.autor = 1;
        self thread autor();
        self iprintlnbold( "Auto Revive [^2ON^7]" );
    }
    else
    {
        level.autor = 0;
        self iprintlnbold( "Auto Revive [^1OFF^7]" );
        self notify( "R_Off" );
        self notify( "R2_Off" );
    }
}

buildalltables()
{
    foreach ( stub in level.buildable_stubs )
        stub.built = 1;
}

levacassa()
{
    level.chest_accessed = 100;
    self iprintlnbold( "Box Will Be ^5Moved" );
}

magicbox()
{
    if ( self.magicbox == 0 )
    {
        self iprintlnbold( "Box ^2Frozen" );
        setdvar( "magic_chest_movable", "0" );
        self.magicbox = 1;
    }
    else
    {
        self iprintlnbold( "Box ^1Unfrozen" );
        setdvar( "magic_chest_movable", "1" );
        self.magicbox = 0;
    }
}

pauseme()
{
    self thread callback_hostmigration();
    self disableinvulnerability();
    wait 0.5;
    self.maxhealth = 999999999;
    self.health = self.maxhealth;

    if ( self.health < self.maxhealth )
        self.health = self.maxhealth;

    self enableinvulnerability();
}

lagswitch()
{
    self endon( "disconnect" );

    if ( self.lag == 1 )
    {
        self iprintlnbold( "Lag Switch ^2ON" );
        setdvar( "g_speed", "-1" );
        self.lag = 0;
    }
    else
    {
        self iprintlnbold( "Lag Switch ^1OFF" );
        setdvar( "g_speed", "200" );
        self.lag = 1;
    }
}

sprintofds()
{
    if ( self.diosassssaa == 0 )
    {
        self iprintlnbold( "Unlimited Sprint ^2On" );
        self setperk( "specialty_unlimitedsprint" );
        self.diosassssaa = 1;
    }
    else
    {
        self unsetperk( "specialty_unlimitedsprint" );
        self iprintlnbold( "Unlimited Sprint ^1Off" );
        self.diosassssaa = 0;
    }
}

farrevive()
{
    if ( self.farreviv == 0 )
    {
        self.farreviv = 1;
        setdvar( "revive_trigger_radius", "9999" );
        self iprintlnbold( "Far Revive ^2On" );
    }
    else
    {
        self.farreviv = 0;
        setdvar( "revive_trigger_radius", "60" );
        self iprintlnbold( "Far Revive ^1Off" );
    }
}

gravity()
{
    if ( self.grav == 1 )
    {
        setdvar( "bg_gravity", "150" );
        self.grav = 0;
        iprintln( "Low Gravity ^2ON" );
    }
    else
    {
        setdvar( "bg_gravity", "800" );
        self.grav = 1;
        iprintln( "Low Gravity ^1OFF" );
    }
}

changetimescale()
{
    level.currenttimescale += 1;

    if ( level.currenttimescale == 1 )
    {
        setdvar( "timescale", "1" );
        self iprintln( "Timescale Set To ^2Normal" );
    }

    if ( level.currenttimescale == 2 )
    {
        setdvar( "timescale", "0.5" );
        self iprintln( "Timescale Set To ^2Slow" );
    }

    if ( level.currenttimescale == 3 )
    {
        setdvar( "timescale", "1.5" );
        self iprintln( "Timescale Set To ^2Fast" );
    }

    if ( level.currenttimescale == 3 )
        level.currenttimescale = 0;
}

bleed()
{
    if ( self.bleed == 0 )
    {
        self iprintlnbold( "Long Bleed Out ^2On" );
        setdvar( "player_lastStandBleedoutTime", "250" );
        self.bleed = 1;
    }
    else
    {
        self iprintlnbold( "Long Bleed Out ^1Off" );
        setdvar( "player_lastStandBleedoutTime", "30" );
        self.bleed = 0;
    }
}

knifemeelee()
{
    self endon( "disconnect" );

    if ( self.sm1 == 1 )
    {
        self iprintlnbold( "Long Melee Range ^2On" );
        setdvar( "player_meleeRange", "999" );
        self.sm1 = 0;
    }
    else
    {
        self iprintlnbold( "Long Melee Range ^1Off" );
        setdvar( "player_meleeRange", "50" );
        self.sm1 = 1;
    }
}

fastend()
{
    wait 0.4;
    exitlevel( 1 );
}

doendgame()
{
    self iprintlnbold( "^5Current Game Ended" );
    level notify( "end_game" );
}

dorestartgame()
{
    self iprintlnbold( "^5Current Game Restarted" );
    wait 1;
    map_restart( 0 );
}

speed()
{
    if ( self.sm == 0 )
    {
        iprintln( "Super Speed ^2ON" );
        setdvar( "g_speed", "400" );
        self.sm = 1;
    }
    else
    {
        iprintln( "Super Speed ^1OFF" );
        setdvar( "g_speed", "200" );
        self.sm = 0;
    }
}

toggleantiquit()
{
    if ( self.doantiquit == 0 )
    {
        self thread doantiquit();
        self.doantiquit = 1;
        self iprintlnbold( "Anti Quit ^2ON" );
    }
    else
    {
        self notify( "stopAntiQuit" );
        self.doantiquit = 0;
        self iprintlnbold( "Anti Quit ^1OFF" );
    }
}

wtfpoweron()
{
    level thread sndmusicstingerevent( "poweron" );
}

give_money()
{
    self add_to_player_score( 100000 );
}

autor()
{
    self endon( "R_Off" );

    for (;;)
    {
        self thread reviveall();
        wait 0.05;
    }
}

doantiquit()
{
    self endon( "disconnect" );
    self endon( "stopAntiQuit" );

    for (;;)
    {
        foreach ( player in level.players )
            player closemenus();

        wait 0.05;
    }
}

reviveall()
{
    self endon( "R2_Off" );

    foreach ( p in level.players )
    {
        if ( isdefined( p.revivetrigger ) )
        {
            p notify( "player_revived" );
            p reviveplayer();
            p.revivetrigger delete();
            p.revivetrigger = undefined;
            p.ignoreme = 0;
            p allowjump( 1 );
            p.laststand = undefined;
        }
    }
}

closemenus()
{
    self freezecontrols( 0 );
    self playsoundtoplayer( "cac_grid_equip_item", self );
    self hidehud();
    self setclientuivisibilityflag( "hud_visible", 1 );
    self.menu.open = 0;
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

doredtheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 0, 0, 1 ) );
    self.aio["bartop"] elemcolor( 1, ( 1, 0, 0 ) );
    self.aio["barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
}

dodefaultpls()
{
    self.aio["scrollbar"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
    self.aio["bartop"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
    self.aio["barbottom"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
}

dogreentheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
    self.aio["bartop"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
    self.aio["barbottom"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
}

dopureredtheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 1, 0, 0 ) );
    self.aio["bartop"] elemcolor( 1, ( 1, 0, 0 ) );
    self.aio["barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
}

dopinktheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 1, 0, 1 ) );
    self.aio["bartop"] elemcolor( 1, ( 1, 0, 1 ) );
    self.aio["barbottom"] elemcolor( 1, ( 1, 0, 1 ) );
}

dobluetheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 0, 0, 1 ) );
    self.aio["bartop"] elemcolor( 1, ( 0, 0, 1 ) );
    self.aio["barbottom"] elemcolor( 1, ( 0, 0, 1 ) );
}

stopbitchinghoe()
{
    if ( self.verga == 0 )
    {
        self.verga = 1;
        self thread doflashingtheme();
        self iprintlnbold( "Flashing Theme ^2ON" );
    }
    else
    {
        self.verga = 0;
        self notify( "stopflash" );
        self iprintlnbold( "Flashing Theme ^1OFF" );
    }
}

doflashingtheme()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "stopflash" );

    for (;;)
    {
        self.aio["scrollbar"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
        self.aio["bartop"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
        self.aio["barbottom"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
        wait 1;
        self.aio["scrollbar"] elemcolor( 1, ( 1, 0, 0 ) );
        self.aio["bartop"] elemcolor( 1, ( 1, 0, 0 ) );
        self.aio["barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
        wait 1;
        self.aio["scrollbar"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
        self.aio["bartop"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
        self.aio["barbottom"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
        wait 1;
        self.aio["scrollbar"] elemcolor( 1, ( 1, 0, 1 ) );
        self.aio["bartop"] elemcolor( 1, ( 1, 0, 1 ) );
        self.aio["barbottom"] elemcolor( 1, ( 1, 0, 1 ) );
        wait 1;
    }
}

elemcolor( time, color )
{
    self fadeovertime( time );
    self.color = color;
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

busdepot()
{
    self setorigin( ( -7108.0, 4680.0, -65.0 ) );
    self iprintlnbold( "^5Teleported!" );
}

tunnel()
{
    self setorigin( ( -11722.8, -853.87, 228.125 ) );
    self iprintlnbold( "^5Teleported!" );
}

diner()
{
    self setorigin( ( -5250.42, -7324.39, -61.499 ) );
    self iprintlnbold( "^5Teleported!" );
}

farm()
{
    self setorigin( ( 7187.93, -5755.32, -45.9499 ) );
    self iprintlnbold( "^5Teleported!" );
}

power()
{
    self setorigin( ( 12195.9, 8419.25, -751.375 ) );
    self iprintlnbold( "^5Teleported!" );
}

town()
{
    self setorigin( ( 1890.6, 590.807, -55.875 ) );
    self iprintlnbold( "^5Teleported!" );
}

nacht()
{
    self setorigin( ( 13809.9, -1023.57, -189.352 ) );
    self iprintlnbold( "^5Teleported!" );
}

woodcabin()
{
    self setorigin( ( 5250.08, 6876.83, -20.6077 ) );
    self iprintlnbold( "^5Teleported!" );
}

middle()
{
    self setorigin( ( 29.8121, 91.1148, -60.4083 ) );
    self iprintlnbold( "^5Teleported!" );
}

greenhousebackyard()
{
    self setorigin( ( -1664.95, 331.109, -63.0471 ) );
    self iprintlnbold( "^5Teleported!" );
}

yellowhousebackyard()
{
    self setorigin( ( 1645.61, 340.779, -61.6733 ) );
    self iprintlnbold( "^5Teleported!" );
}

garage()
{
    self setorigin( ( -907.201, 242.057, -55.875 ) );
    self iprintlnbold( "^5Teleported!" );
}

roof2()
{
    self setorigin( ( -669.195, 393.448, 259.836 ) );
    self iprintlnbold( "^5Teleported!" );
}

spawn2()
{
    self setorigin( ( 1464.25, 1377.69, 3397.46 ) );
    self iprintlnbold( "^5Teleported!" );
}

slide()
{
    self setorigin( ( 2084.26, 2573.54, 3050.59 ) );
    self iprintlnbold( "^5Teleported!" );
}

brokenelev()
{
    self setorigin( ( 3700.51, 2173.41, 2575.47 ) );
    self iprintlnbold( "^5Teleported!" );
}

redroom()
{
    self setorigin( ( 3176.08, 1426.12, 1298.53 ) );
    self iprintlnbold( "^5Teleported!" );
}

bankpower()
{
    self setorigin( ( 2614.06, 30.8681, 1296.13 ) );
    self iprintlnbold( "^5Teleported!" );
}

roof()
{
    self setorigin( ( 1965.23, 151.344, 2880.13 ) );
    self iprintlnbold( "^5Teleported!" );
}

mainroom()
{
    self setorigin( ( 2067.99, 1385.92, 3040.13 ) );
    self iprintlnbold( "^5Teleported!" );
}

spawn3()
{
    self setorigin( ( -2689.08, -761.858, 1360.13 ) );
    self iprintlnbold( "^5Teleported!" );
}

underspawn()
{
    self setorigin( ( -957.409, -351.905, 288.125 ) );
    self iprintlnbold( "^5Teleported!" );
}

bank()
{
    self setorigin( ( -419.9, -35.8688, 8.125 ) );
    self iprintlnbold( "^5Teleported!" );
}

leroycell()
{
    self setorigin( ( -1081.72, 830.04, 8.125 ) );
    self iprintlnbold( "^5Teleported!" );
}

barsaloon()
{
    self setorigin( ( 790.854, -1433.25, 56.125 ) );
    self iprintlnbold( "^5Teleported!" );
}

middlemaze()
{
    self setorigin( ( 4920.74, 454.216, 4.125 ) );
    self iprintlnbold( "^5Teleported!" );
}

power2()
{
    self setorigin( ( 710.08, -591.387, 143.443 ) );
    self iprintlnbold( "^5Teleported!" );
}

spawnswagplz()
{
    self setorigin( ( 568.787, 10385.2, 1336.13 ) );
    self iprintlnbold( "^5Teleported!" );
}

dogswag()
{
    self setorigin( ( 826.87, 9672.88, 1443.13 ) );
    self iprintlnbold( "^5Teleported!" );
}

pood()
{
    self setorigin( ( 3731.16, 9705.97, 1532.84 ) );
    self iprintlnbold( "^5Teleported!" );
}

swegg()
{
    self setorigin( ( 49.1354, 6093.95, 19.5609 ) );
    self iprintlnbold( "^5Teleported!" );
}

snipertower()
{
    self setorigin( ( -541.393, 5466.81, -71.875 ) );
    self iprintlnbold( "^5Teleported!" );
}

nofreezplz()
{
    self setorigin( ( 3482.33, 9681.11, 1704.13 ) );
    self iprintlnbold( "^5Teleported!" );
}

ggbridge()
{
    self setorigin( ( -1036.85, -3565.71, -8423.77 ) );
    self iprintlnbold( "^5Teleported!" );
}

outofmap()
{
    self setorigin( ( -2163.37, 1449.07, 144.125 ) );
    self iprintlnbold( "^5Teleported!" );
}

spawnplz()
{
    self setorigin( ( 2754.93, 5402.57, -358.25 ) );
    self iprintlnbold( "^5Teleported!" );
}

toppap()
{
    self setorigin( ( -136.066, 73.8532, 320.125 ) );
    self iprintlnbold( "^5Teleported!" );
}

bottompap()
{
    self setorigin( ( -10.9809, -104.999, -743.93 ) );
    self iprintlnbold( "^5Teleported!" );
}

church()
{
    self setorigin( ( 568.087, -2673.3, 358.335 ) );
    self iprintlnbold( "^5Teleported!" );
}

deadrobot()
{
    self setorigin( ( -249.616, 4693.99, -286.556 ) );
    self iprintlnbold( "^5Teleported!" );
}

get_zone_name()
{
    zone = self get_current_zone();

    if ( !isdefined( zone ) )
        return "";

    name = zone;

    if ( level.script == "zm_transit" )
    {
        if ( zone == "zone_pri" )
            name = "Bus Depot";
        else if ( zone == "zone_pri2" )
            name = "Bus Depot Hallway";
        else if ( zone == "zone_station_ext" )
            name = "Outside Bus Depot";
        else if ( zone == "zone_trans_2b" )
            name = "Fog After Bus Depot";
        else if ( zone == "zone_trans_2" )
            name = "Tunnel Entrance";
        else if ( zone == "zone_amb_tunnel" )
            name = "Tunnel";
        else if ( zone == "zone_trans_3" )
            name = "Tunnel Exit";
        else if ( zone == "zone_roadside_west" )
            name = "Outside Diner";
        else if ( zone == "zone_gas" )
            name = "Gas Station";
        else if ( zone == "zone_roadside_east" )
            name = "Outside Garage";
        else if ( zone == "zone_trans_diner" )
            name = "Fog Outside Diner";
        else if ( zone == "zone_trans_diner2" )
            name = "Fog Outside Garage";
        else if ( zone == "zone_gar" )
            name = "Garage";
        else if ( zone == "zone_din" )
            name = "Diner";
        else if ( zone == "zone_diner_roof" )
            name = "Diner Roof";
        else if ( zone == "zone_trans_4" )
            name = "Fog After Diner";
        else if ( zone == "zone_amb_forest" )
            name = "Forest";
        else if ( zone == "zone_trans_10" )
            name = "Outside Church";
        else if ( zone == "zone_town_church" )
            name = "Church";
        else if ( zone == "zone_trans_5" )
            name = "Fog Before Farm";
        else if ( zone == "zone_far" )
            name = "Outside Farm";
        else if ( zone == "zone_far_ext" )
            name = "Farm";
        else if ( zone == "zone_brn" )
            name = "Barn";
        else if ( zone == "zone_farm_house" )
            name = "Farmhouse";
        else if ( zone == "zone_trans_6" )
            name = "Fog After Farm";
        else if ( zone == "zone_amb_cornfield" )
            name = "Cornfield";
        else if ( zone == "zone_cornfield_prototype" )
            name = "Nacht";
        else if ( zone == "zone_trans_7" )
            name = "Upper Fog Before Power";
        else if ( zone == "zone_trans_pow_ext1" )
            name = "Fog Before Power";
        else if ( zone == "zone_pow" )
            name = "Outside Power Station";
        else if ( zone == "zone_prr" )
            name = "Power Station";
        else if ( zone == "zone_pcr" )
            name = "Power Control Room";
        else if ( zone == "zone_pow_warehouse" )
            name = "Warehouse";
        else if ( zone == "zone_trans_8" )
            name = "Fog After Power";
        else if ( zone == "zone_amb_power2town" )
            name = "Cabin";
        else if ( zone == "zone_trans_9" )
            name = "Fog Before Town";
        else if ( zone == "zone_town_north" )
            name = "North Town";
        else if ( zone == "zone_tow" )
            name = "Center Town";
        else if ( zone == "zone_town_east" )
            name = "East Town";
        else if ( zone == "zone_town_west" )
            name = "West Town";
        else if ( zone == "zone_town_south" )
            name = "South Town";
        else if ( zone == "zone_bar" )
            name = "Bar";
        else if ( zone == "zone_town_barber" )
            name = "Bookstore";
        else if ( zone == "zone_ban" )
            name = "Bank";
        else if ( zone == "zone_ban_vault" )
            name = "Bank Vault";
        else if ( zone == "zone_tbu" )
            name = "Below Bank";
        else if ( zone == "zone_trans_11" )
            name = "Fog After Town";
        else if ( zone == "zone_amb_bridge" )
            name = "Bridge";
        else if ( zone == "zone_trans_1" )
            name = "Fog Before Bus Depot";
    }
    else if ( level.script == "zm_nuked" )
    {
        if ( zone == "culdesac_yellow_zone" )
            name = "Yellow House Middle";
        else if ( zone == "culdesac_green_zone" )
            name = "Green House Middle";
        else if ( zone == "truck_zone" )
            name = "Truck";
        else if ( zone == "openhouse1_f1_zone" )
            name = "Green House Downstairs";
        else if ( zone == "openhouse1_f2_zone" )
            name = "Green House Upstairs";
        else if ( zone == "openhouse1_backyard_zone" )
            name = "Green House Backyard";
        else if ( zone == "openhouse2_f1_zone" )
            name = "Yellow House Downstairs";
        else if ( zone == "openhouse2_f2_zone" )
            name = "Yellow House Upstairs";
        else if ( zone == "openhouse2_backyard_zone" )
            name = "Yellow House Backyard";
        else if ( zone == "ammo_door_zone" )
            name = "Yellow House Backyard Door";
    }
    else if ( level.script == "zm_highrise" )
    {
        if ( zone == "zone_green_start" )
            name = "Green Highrise Level 3b";
        else if ( zone == "zone_green_escape_pod" )
            name = "Escape Pod";
        else if ( zone == "zone_green_escape_pod_ground" )
            name = "Escape Pod Shaft";
        else if ( zone == "zone_green_level1" )
            name = "Green Highrise Level 3a";
        else if ( zone == "zone_green_level2a" )
            name = "Green Highrise Level 2a";
        else if ( zone == "zone_green_level2b" )
            name = "Green Highrise Level 2b";
        else if ( zone == "zone_green_level3a" )
            name = "Green Highrise Restaurant";
        else if ( zone == "zone_green_level3b" )
            name = "Green Highrise Level 1a";
        else if ( zone == "zone_green_level3c" )
            name = "Green Highrise Level 1b";
        else if ( zone == "zone_green_level3d" )
            name = "Green Highrise Behind Restaurant";
        else if ( zone == "zone_orange_level1" )
            name = "Upper Orange Highrise Level 2";
        else if ( zone == "zone_orange_level2" )
            name = "Upper Orange Highrise Level 1";
        else if ( zone == "zone_orange_elevator_shaft_top" )
            name = "Elevator Shaft Level 3";
        else if ( zone == "zone_orange_elevator_shaft_middle_1" )
            name = "Elevator Shaft Level 2";
        else if ( zone == "zone_orange_elevator_shaft_middle_2" )
            name = "Elevator Shaft Level 1";
        else if ( zone == "zone_orange_elevator_shaft_bottom" )
            name = "Elevator Shaft Bottom";
        else if ( zone == "zone_orange_level3a" )
            name = "Lower Orange Highrise Level 1a";
        else if ( zone == "zone_orange_level3b" )
            name = "Lower Orange Highrise Level 1b";
        else if ( zone == "zone_blue_level5" )
            name = "Lower Blue Highrise Level 1";
        else if ( zone == "zone_blue_level4a" )
            name = "Lower Blue Highrise Level 2a";
        else if ( zone == "zone_blue_level4b" )
            name = "Lower Blue Highrise Level 2b";
        else if ( zone == "zone_blue_level4c" )
            name = "Lower Blue Highrise Level 2c";
        else if ( zone == "zone_blue_level2a" )
            name = "Upper Blue Highrise Level 1a";
        else if ( zone == "zone_blue_level2b" )
            name = "Upper Blue Highrise Level 1b";
        else if ( zone == "zone_blue_level2c" )
            name = "Upper Blue Highrise Level 1c";
        else if ( zone == "zone_blue_level2d" )
            name = "Upper Blue Highrise Level 1d";
        else if ( zone == "zone_blue_level1a" )
            name = "Upper Blue Highrise Level 2a";
        else if ( zone == "zone_blue_level1b" )
            name = "Upper Blue Highrise Level 2b";
        else if ( zone == "zone_blue_level1c" )
            name = "Upper Blue Highrise Level 2c";
    }
    else if ( level.script == "zm_prison" )
    {
        if ( zone == "zone_start" )
            name = "D-Block";
        else if ( zone == "zone_library" )
            name = "Library";
        else if ( zone == "zone_cellblock_west" )
            name = "Cellblock 2nd Floor";
        else if ( zone == "zone_cellblock_west_gondola" )
            name = "Cellblock 3rd Floor";
        else if ( zone == "zone_cellblock_west_gondola_dock" )
            name = "Cellblock Gondola";
        else if ( zone == "zone_cellblock_west_barber" )
            name = "Michigan Avenue";
        else if ( zone == "zone_cellblock_east" )
            name = "Times Square";
        else if ( zone == "zone_cafeteria" )
            name = "Cafeteria";
        else if ( zone == "zone_cafeteria_end" )
            name = "Cafeteria End";
        else if ( zone == "zone_infirmary" )
            name = "Infirmary 1";
        else if ( zone == "zone_infirmary_roof" )
            name = "Infirmary 2";
        else if ( zone == "zone_roof_infirmary" )
            name = "Roof 1";
        else if ( zone == "zone_roof" )
            name = "Roof 2";
        else if ( zone == "zone_cellblock_west_warden" )
            name = "Sally Port";
        else if ( zone == "zone_warden_office" )
            name = "Warden's Office";
        else if ( zone == "cellblock_shower" )
            name = "Showers";
        else if ( zone == "zone_citadel_shower" )
            name = "Citadel To Showers";
        else if ( zone == "zone_citadel" )
            name = "Citadel";
        else if ( zone == "zone_citadel_warden" )
            name = "Citadel To Warden's Office";
        else if ( zone == "zone_citadel_stairs" )
            name = "Citadel Tunnels";
        else if ( zone == "zone_citadel_basement" )
            name = "Citadel Basement";
        else if ( zone == "zone_citadel_basement_building" )
            name = "China Alley";
        else if ( zone == "zone_studio" )
            name = "Building 64";
        else if ( zone == "zone_dock" )
            name = "Docks";
        else if ( zone == "zone_dock_puzzle" )
            name = "Docks Gates";
        else if ( zone == "zone_dock_gondola" )
            name = "Upper Docks";
        else if ( zone == "zone_golden_gate_bridge" )
            name = "Golden Gate Bridge";
        else if ( zone == "zone_gondola_ride" )
            name = "Gondola";
    }
    else if ( level.script == "zm_buried" )
    {
        if ( zone == "zone_start" )
            name = "Processing";
        else if ( zone == "zone_start_lower" )
            name = "Lower Processing";
        else if ( zone == "zone_tunnels_center" )
            name = "Center Tunnels";
        else if ( zone == "zone_tunnels_north" )
            name = "Courthouse Tunnels 2";
        else if ( zone == "zone_tunnels_north2" )
            name = "Courthouse Tunnels 1";
        else if ( zone == "zone_tunnels_south" )
            name = "Saloon Tunnels 3";
        else if ( zone == "zone_tunnels_south2" )
            name = "Saloon Tunnels 2";
        else if ( zone == "zone_tunnels_south3" )
            name = "Saloon Tunnels 1";
        else if ( zone == "zone_street_lightwest" )
            name = "Outside General Store & Bank";
        else if ( zone == "zone_street_lightwest_alley" )
            name = "Outside General Store & Bank Alley";
        else if ( zone == "zone_morgue_upstairs" )
            name = "Morgue";
        else if ( zone == "zone_underground_jail" )
            name = "Jail Downstairs";
        else if ( zone == "zone_underground_jail2" )
            name = "Jail Upstairs";
        else if ( zone == "zone_general_store" )
            name = "General Store";
        else if ( zone == "zone_stables" )
            name = "Stables";
        else if ( zone == "zone_street_darkwest" )
            name = "Outside Gunsmith";
        else if ( zone == "zone_street_darkwest_nook" )
            name = "Outside Gunsmith Nook";
        else if ( zone == "zone_gun_store" )
            name = "Gunsmith";
        else if ( zone == "zone_bank" )
            name = "Bank";
        else if ( zone == "zone_tunnel_gun2stables" )
            name = "Stables To Gunsmith Tunnel 2";
        else if ( zone == "zone_tunnel_gun2stables2" )
            name = "Stables To Gunsmith Tunnel";
        else if ( zone == "zone_street_darkeast" )
            name = "Outside Saloon & Toy Store";
        else if ( zone == "zone_street_darkeast_nook" )
            name = "Outside Saloon & Toy Store Nook";
        else if ( zone == "zone_underground_bar" )
            name = "Saloon";
        else if ( zone == "zone_tunnel_gun2saloon" )
            name = "Saloon To Gunsmith Tunnel";
        else if ( zone == "zone_toy_store" )
            name = "Toy Store Downstairs";
        else if ( zone == "zone_toy_store_floor2" )
            name = "Toy Store Upstairs";
        else if ( zone == "zone_toy_store_tunnel" )
            name = "Toy Store Tunnel";
        else if ( zone == "zone_candy_store" )
            name = "Candy Store Downstairs";
        else if ( zone == "zone_candy_store_floor2" )
            name = "Candy Store Upstairs";
        else if ( zone == "zone_street_lighteast" )
            name = "Outside Courthouse & Candy Store";
        else if ( zone == "zone_underground_courthouse" )
            name = "Courthouse Downstairs";
        else if ( zone == "zone_underground_courthouse2" )
            name = "Courthouse Upstairs";
        else if ( zone == "zone_street_fountain" )
            name = "Fountain";
        else if ( zone == "zone_church_graveyard" )
            name = "Graveyard";
        else if ( zone == "zone_church_main" )
            name = "Church Downstairs";
        else if ( zone == "zone_church_upstairs" )
            name = "Church Upstairs";
        else if ( zone == "zone_mansion_lawn" )
            name = "Mansion Lawn";
        else if ( zone == "zone_mansion" )
            name = "Mansion";
        else if ( zone == "zone_mansion_backyard" )
            name = "Mansion Backyard";
        else if ( zone == "zone_maze" )
            name = "Maze";
        else if ( zone == "zone_maze_staircase" )
            name = "Maze Staircase";
    }
    else if ( level.script == "zm_tomb" )
    {
        if ( isdefined( self.teleporting ) && self.teleporting )
            return "";

        if ( zone == "zone_start" )
            name = "Lower Laboratory";
        else if ( zone == "zone_start_a" )
            name = "Upper Laboratory";
        else if ( zone == "zone_start_b" )
            name = "Generator 1";
        else if ( zone == "zone_bunker_1a" )
            name = "Generator 3 Bunker 1";
        else if ( zone == "zone_fire_stairs" )
            name = "Fire Tunnel";
        else if ( zone == "zone_bunker_1" )
            name = "Generator 3 Bunker 2";
        else if ( zone == "zone_bunker_3a" )
            name = "Generator 3";
        else if ( zone == "zone_bunker_3b" )
            name = "Generator 3 Bunker 3";
        else if ( zone == "zone_bunker_2a" )
            name = "Generator 2 Bunker 1";
        else if ( zone == "zone_bunker_2" )
            name = "Generator 2 Bunker 2";
        else if ( zone == "zone_bunker_4a" )
            name = "Generator 2";
        else if ( zone == "zone_bunker_4b" )
            name = "Generator 2 Bunker 3";
        else if ( zone == "zone_bunker_4c" )
            name = "Tank Station";
        else if ( zone == "zone_bunker_4d" )
            name = "Above Tank Station";
        else if ( zone == "zone_bunker_tank_c" )
            name = "Generator 2 Tank Route 1";
        else if ( zone == "zone_bunker_tank_c1" )
            name = "Generator 2 Tank Route 2";
        else if ( zone == "zone_bunker_4e" )
            name = "Generator 2 Tank Route 3";
        else if ( zone == "zone_bunker_tank_d" )
            name = "Generator 2 Tank Route 4";
        else if ( zone == "zone_bunker_tank_d1" )
            name = "Generator 2 Tank Route 5";
        else if ( zone == "zone_bunker_4f" )
            name = "zone_bunker_4f";
        else if ( zone == "zone_bunker_5a" )
            name = "Workshop Downstairs";
        else if ( zone == "zone_bunker_5b" )
            name = "Workshop Upstairs";
        else if ( zone == "zone_nml_2a" )
            name = "No Man's Land Walkway";
        else if ( zone == "zone_nml_2" )
            name = "No Man's Land Entrance";
        else if ( zone == "zone_bunker_tank_e" )
            name = "Generator 5 Tank Route 1";
        else if ( zone == "zone_bunker_tank_e1" )
            name = "Generator 5 Tank Route 2";
        else if ( zone == "zone_bunker_tank_e2" )
            name = "zone_bunker_tank_e2";
        else if ( zone == "zone_bunker_tank_f" )
            name = "Generator 5 Tank Route 3";
        else if ( zone == "zone_nml_1" )
            name = "Generator 5 Tank Route 4";
        else if ( zone == "zone_nml_4" )
            name = "Generator 5 Tank Route 5";
        else if ( zone == "zone_nml_0" )
            name = "Generator 5 Left Footstep";
        else if ( zone == "zone_nml_5" )
            name = "Generator 5 Right Footstep Walkway";
        else if ( zone == "zone_nml_farm" )
            name = "Generator 5";
        else if ( zone == "zone_nml_celllar" )
            name = "Generator 5 Cellar";
        else if ( zone == "zone_bolt_stairs" )
            name = "Lightning Tunnel";
        else if ( zone == "zone_nml_3" )
            name = "No Man's Land 1st Right Footstep";
        else if ( zone == "zone_nml_2b" )
            name = "No Man's Land Stairs";
        else if ( zone == "zone_nml_6" )
            name = "No Man's Land Left Footstep";
        else if ( zone == "zone_nml_8" )
            name = "No Man's Land 2nd Right Footstep";
        else if ( zone == "zone_nml_10a" )
            name = "Generator 4 Tank Route 1";
        else if ( zone == "zone_nml_10" )
            name = "Generator 4 Tank Route 2";
        else if ( zone == "zone_nml_7" )
            name = "Generator 4 Tank Route 3";
        else if ( zone == "zone_bunker_tank_a" )
            name = "Generator 4 Tank Route 4";
        else if ( zone == "zone_bunker_tank_a1" )
            name = "Generator 4 Tank Route 5";
        else if ( zone == "zone_bunker_tank_a2" )
            name = "zone_bunker_tank_a2";
        else if ( zone == "zone_bunker_tank_b" )
            name = "Generator 4 Tank Route 6";
        else if ( zone == "zone_nml_9" )
            name = "Generator 4 Left Footstep";
        else if ( zone == "zone_air_stairs" )
            name = "Wind Tunnel";
        else if ( zone == "zone_nml_11" )
            name = "Generator 4";
        else if ( zone == "zone_nml_12" )
            name = "Generator 4 Right Footstep";
        else if ( zone == "zone_nml_16" )
            name = "Excavation Site Front Path";
        else if ( zone == "zone_nml_17" )
            name = "Excavation Site Back Path";
        else if ( zone == "zone_nml_18" )
            name = "Excavation Site Level 3";
        else if ( zone == "zone_nml_19" )
            name = "Excavation Site Level 2";
        else if ( zone == "ug_bottom_zone" )
            name = "Excavation Site Level 1";
        else if ( zone == "zone_nml_13" )
            name = "Generator 5 To Generator 6 Path";
        else if ( zone == "zone_nml_14" )
            name = "Generator 4 To Generator 6 Path";
        else if ( zone == "zone_nml_15" )
            name = "Generator 6 Entrance";
        else if ( zone == "zone_village_0" )
            name = "Generator 6 Left Footstep";
        else if ( zone == "zone_village_5" )
            name = "Generator 6 Tank Route 1";
        else if ( zone == "zone_village_5a" )
            name = "Generator 6 Tank Route 2";
        else if ( zone == "zone_village_5b" )
            name = "Generator 6 Tank Route 3";
        else if ( zone == "zone_village_1" )
            name = "Generator 6 Tank Route 4";
        else if ( zone == "zone_village_4b" )
            name = "Generator 6 Tank Route 5";
        else if ( zone == "zone_village_4a" )
            name = "Generator 6 Tank Route 6";
        else if ( zone == "zone_village_4" )
            name = "Generator 6 Tank Route 7";
        else if ( zone == "zone_village_2" )
            name = "Church";
        else if ( zone == "zone_village_3" )
            name = "Generator 6 Right Footstep";
        else if ( zone == "zone_village_3a" )
            name = "Generator 6";
        else if ( zone == "zone_ice_stairs" )
            name = "Ice Tunnel";
        else if ( zone == "zone_bunker_6" )
            name = "Above Generator 3 Bunker";
        else if ( zone == "zone_nml_20" )
            name = "Above No Man's Land";
        else if ( zone == "zone_village_6" )
            name = "Behind Church";
        else if ( zone == "zone_chamber_0" )
            name = "The Crazy Place Lightning Chamber";
        else if ( zone == "zone_chamber_1" )
            name = "The Crazy Place Lightning & Ice";
        else if ( zone == "zone_chamber_2" )
            name = "The Crazy Place Ice Chamber";
        else if ( zone == "zone_chamber_3" )
            name = "The Crazy Place Fire & Lightning";
        else if ( zone == "zone_chamber_4" )
            name = "The Crazy Place Center";
        else if ( zone == "zone_chamber_5" )
            name = "The Crazy Place Ice & Wind";
        else if ( zone == "zone_chamber_6" )
            name = "The Crazy Place Fire Chamber";
        else if ( zone == "zone_chamber_7" )
            name = "The Crazy Place Wind & Fire";
        else if ( zone == "zone_chamber_8" )
            name = "The Crazy Place Wind Chamber";
        else if ( zone == "zone_robot_head" )
            name = "Robot's Head";
    }

    return name;
}
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
    setdvar("CUSTOM_MAP", "0")
}// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

upgradeweapon()
{
    baseweapon = get_base_name( self getcurrentweapon() );
    weapon = get_upgrade( baseweapon );

    if ( isdefined( weapon ) )
    {
        self takeweapon( baseweapon );
        self giveweapon( weapon, 0, self get_pack_a_punch_weapon_options( weapon ) );
        self switchtoweapon( weapon );
        self givemaxammo( weapon );
    }
}

downgradeweapon()
{
    baseweapon = self getcurrentweapon();
    weapon = get_base_weapon_name( baseweapon, 1 );

    if ( isdefined( weapon ) )
    {
        self takeweapon( baseweapon );
        self giveweapon( weapon, 0, self get_pack_a_punch_weapon_options( weapon ) );
        self switchtoweapon( weapon );
        self givemaxammo( weapon );
    }
}

get_upgrade( weapon )
{
    if ( isdefined( level.zombie_weapons[weapon].upgrade_name ) && isdefined( level.zombie_weapons[weapon] ) )
        return get_upgrade_weapon( weapon, 0 );
    else
        return get_upgrade_weapon( weapon, 1 );
}

doublejump()
{
    if ( self.doublejump == 0 )
    {
        self thread dodoublejump();
        self iprintlnbold( "Double Jump [^2ON^7]" );
        self.doublejump = 1;
    }
    else
    {
        self notify( "DoubleJump" );
        self.doublejump = 0;
        self iprintlnbold( "Double Jump [^1OFF^7]" );
    }
}

dodoublejump()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "DoubleJump" );

    for (;;)
    {
        if ( !self isonground() )
        {
            wait 0.2;
            self setvelocity( ( self getvelocity()[0], self getvelocity()[1], self getvelocity()[2] ) + ( 0.0, 0.0, 250.0 ) );
            wait 0.8;
        }

        wait 0.001;
    }
}

cloneme()
{
    self iprintlnbold( "Clone ^2Spawned!" );
    self cloneplayer( 9999 );
}

deadclone()
{
    self iprintlnbold( "Dead Clone ^2Spawned" );
    ffdc = self cloneplayer( 9999 );
    ffdc startragdoll( 1 );
}

expclone()
{
    self iprintlnbold( "Exploded Dead Clone ^2Spawned" );
    x = randomintrange( 50, 100 );
    y = randomintrange( 50, 100 );
    z = randomintrange( 20, 30 );

    if ( cointoss() )
        x *= -1;
    else
        y *= -1;

    exp_clone = self cloneplayer( 1 );
    exp_clone startragdoll();
    exp_clone launchragdoll( ( x, y, z ) );
}

jesusclone()
{
    self iprintlnbold( "Jesus ^2Spawned" );
    jesus = spawn( "script_model", self.origin );
    jesus setmodel( self.model );
    jesus setcontents( 1 );
}

togglespin( player )
{
    if ( !player ishost() || player.status == "Developer" )
    {
        if ( player.isspinning == 0 )
        {
            player thread spinme();
            player iprintlnbold( "Spinning ^2ON" );
            self iprintlnbold( player.name + " Spinning ^2ON" );
            player.isspinning = 1;
        }
        else if ( player.isspinning == 1 )
        {
            player notify( "Stop_Spining" );
            player iprintlnbold( "Spinning ^1OFF" );
            self iprintlnbold( player.name + " Spinning ^1OFF" );
            player.isspinning = 0;
        }
    }
}

spinme()
{
    self endon( "disconnect" );
    self endon( "Stop_Spining" );

    for (;;)
    {
        self setplayerangles( self.angles + ( 0.0, 20.0, 0.0 ) );
        wait 0.01;
        self setplayerangles( self.angles + ( 0.0, 20.0, 0.0 ) );
        wait 0.01;
    }

    wait 0.05;
}

toggle_bullets()
{
    if ( self.bullets == 0 )
    {
        self thread bulletmod();
        self.bullets = 1;
        self iprintlnbold( "Explosive Bullets [^2ON^7]" );
    }
    else
    {
        self notify( "stop_bullets" );
        self.bullets = 0;
        self iprintlnbold( "Explosive Bullets [^1OFF^7]" );
    }
}

doshootpowerups()
{
    self notify( "StopShootPowerUps" );
    self endon( "StopShootPowerUps" );
    self endon( "disconnect" );
    self endon( "death" );
    level endon( "game_ended" );

    for (;;)
    {
        powerups = getarraykeys( level.zombie_include_powerups );

        for ( i = 0; i < powerups.size; i++ )
        {
            self waittill( "weapon_fired" );

            level.powerup_drop_count = 0;
            direction_vec = anglestoforward( self getplayerangles() );
            eye = self geteye();
            direction_vec = ( direction_vec[0] * 8000, direction_vec[1] * 8000, direction_vec[2] * 8000 );
            trace = bullettrace( eye, eye + direction_vec, 0, undefined );
            powerup = level specific_powerup_drop( powerups[i], trace["position"] );

            if ( powerups[i] == "teller_withdrawl" )
                powerup.value = 1000;

            powerup thread powerup_timeout();
            wait 0.1;
        }
    }
}

toggle_shootpowerups()
{
    if ( self.doshootpowerups == 0 )
    {
        self thread doshootpowerups();
        self.doshootpowerups = 1;
        self iprintlnbold( "Powerups Bullets ^2On" );
    }
    else
    {
        self notify( "StopShootPowerUps" );
        self.doshootpowerups = 0;
        self iprintlnbold( "Powerups Bullets ^1Off" );
    }
}

bulletmod()
{
    self endon( "stop_bullets" );

    for (;;)
    {
        self waittill( "weapon_fired" );

        earthquake( 0.5, 1, self.origin, 90 );
        forward = self gettagorigin( "j_head" );
        end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
        splosionlocation = bullettrace( forward, end, 0, self )["position"];
        radiusdamage( splosionlocation, 500, 1000, 500, self );
        playsoundatposition( "evt_nuke_flash", splosionlocation );
        play_sound_at_pos( "evt_nuke_flash", splosionlocation );
        earthquake( 2.5, 2, splosionlocation, 300 );
        playfx( loadfx( "explosions/fx_default_explosion" ), splosionlocation );
    }
}

tgl_ricochet()
{
    if ( !isdefined( self.ricochet ) )
    {
        self.ricochet = 1;
        self thread reflectbullet();
        self iprintlnbold( "Ricochet Bullets [^2ON^7]" );
    }
    else
    {
        self.ricochet = undefined;
        self notify( "Rico_Off" );
        self iprintlnbold( "Ricochet Bullets [^1OFF^7]" );
    }
}

reflectbullet()
{
    self endon( "Rico_Off" );

    for (;;)
    {
        self waittill( "weapon_fired" );

        gun = self getcurrentweapon();
        incident = anglestoforward( self getplayerangles() );
        trace = bullettrace( self geteye(), self geteye() + incident * 100000, 0, self );
        reflection -= 2 * ( trace["normal"] * vectordot( incident, trace["normal"] ) );
        magicbullet( gun, trace["position"], trace["position"] + reflection * 100000, self );

        for ( i = 0; i < 1 - 1; i++ )
        {
            trace = bullettrace( trace["position"], trace["position"] + reflection * 100000, 0, self );
            incident = reflection;
            reflection -= 2 * ( trace["normal"] * vectordot( incident, trace["normal"] ) );
            magicbullet( gun, trace["position"], trace["position"] + reflection * 100000, self );
            wait 0.05;
        }
    }
}

teleportgun()
{
    if ( self.tpg == 0 )
    {
        self.tpg = 1;
        self thread teleportrun();
        self iprintlnbold( "Teleporter Weapon [^2ON^7]" );
    }
    else
    {
        self.tpg = 0;
        self notify( "Stop_TP" );
        self iprintlnbold( "Teleporter Weapon [^1OFF^7]" );
    }
}

teleportrun()
{
    self endon( "death" );
    self endon( "Stop_TP" );

    for (;;)
    {
        self waittill( "weapon_fired" );

        self setorigin( bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )["position"] );
    }
}

dodefaultmodelsbullets()
{
    if ( self.bullets2 == 0 )
    {
        self thread doactorbullets();
        self.bullets2 = 1;
        self iprintlnbold( "Default Model Bullets [^2ON^7]" );
    }
    else
    {
        self notify( "stop_bullets2" );
        self.bullets2 = 0;
        self iprintlnbold( "Default Model Bullets [^1OFF^7]" );
    }
}

doactorbullets()
{
    self endon( "stop_bullets2" );

    while ( true )
    {
        self waittill( "weapon_fired" );

        forward = self gettagorigin( "j_head" );
        end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
        splosionlocation = bullettrace( forward, end, 0, self )["position"];
        m = spawn( "script_model", splosionlocation );
        m setmodel( "defaultactor" );
    }
}

docardefaultmodelsbullets()
{
    if ( self.bullets3 == 0 )
    {
        self thread doacarbullets();
        self.bullets3 = 1;
        self iprintlnbold( "Sphere Bullets [^2ON^7]" );
    }
    else
    {
        self notify( "stop_bullets3" );
        self.bullets3 = 0;
        self iprintlnbold( "Sphere Bullets [^1OFF^7]" );
    }
}

doacarbullets()
{
    self endon( "stop_bullets3" );

    while ( true )
    {
        self waittill( "weapon_fired" );

        forward = self gettagorigin( "j_head" );
        end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
        splosionlocation = bullettrace( forward, end, 0, self )["position"];
        m = spawn( "script_model", splosionlocation );
        m setmodel( "test_sphere_lambert" );
    }
}

normalbullets()
{
    self iprintlnbold( "Modded Bullets [^1OFF^7]" );
    self notify( "StopBullets" );
}

dobullet( a )
{
    self notify( "StopBullets" );
    self endon( "StopBullets" );
    self iprintln( "Bullets Type: ^2" + self.menu.system["MenuTexte"][self.menu.system["MenuRoot"]][self.menu.system["MenuCurser"]] );

    for (;;)
    {
        self waittill( "weapon_fired" );

        b = self gettagorigin( "tag_eye" );
        c = self thread bullet( anglestoforward( self getplayerangles() ), 1000000 );
        d = bullettrace( b, c, 0, self )["position"];
        magicbullet( a, b, d, self );
    }
}

bullet( a, b )
{
    return ( a[0] * b, a[1] * b, a[2] * b );
}

fth()
{
    if ( self.fths == 0 )
    {
        self thread doflame();
        self.fths = 1;
        self iprintlnbold( "FlameThrower [^2ON^7]" );
    }
    else
    {
        self notify( "Stop_FlameTrowher" );
        self.fths = 0;
        self takeallweapons();
        self giveweapon( "m1911_zm" );
        self switchtoweapon( "m1911_zm" );
        self givemaxammo( "m1911_zm" );
        self iprintlnbold( "FlameThrower [^1OFF^7]" );
    }
}

doflame()
{
    self endon( "Stop_FlameTrowher" );
    self takeallweapons();
    self giveweapon( "defaultweapon_mp" );
    self switchtoweapon( "defaultweapon_mp" );
    self givemaxammo( "defaultweapon_mp" );

    while ( true )
    {
        self waittill( "weapon_fired" );

        forward = self gettagorigin( "j_head" );
        end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
        crosshair = bullettrace( forward, end, 0, self )["position"];
        magicbullet( self getcurrentweapon(), self gettagorigin( "j_shouldertwist_le" ), crosshair, self );
        flamefx = loadfx( "env/fire/fx_fire_zombie_torso" );
        playfx( flamefx, crosshair );
        flamefx2 = loadfx( "env/fire/fx_fire_zombie_md" );
        playfx( flamefx, self gettagorigin( "j_hand" ) );
        radiusdamage( crosshair, 100, 15, 15, self );
    }
}

arrowpbullets()
{
    if ( self.bulletsa == 0 )
    {
        self thread careabullets();
        self.bulletsa = 1;
        self iprintlnbold( "Arrow Bullets ^2ON" );
    }
    else
    {
        self notify( "stop_bullets2" );
        self.bulletsa = 0;
        self iprintlnbold( "Arrow Bullets ^1OFF" );
    }
}

careabullets()
{
    self endon( "stop_bullets2" );

    while ( true )
    {
        self waittill( "weapon_fired" );

        forward = self gettagorigin( "j_head" );
        end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
        splosionlocation = bullettrace( forward, end, 0, self )["position"];
        m = spawn( "script_model", splosionlocation );
        m setmodel( "fx_axis_createfx" );
    }
}

watch_for_cluster_grenade_throw()
{
    self endon ( "disconnect" );
    level endon ( "end_game" );
    for ( ;; )
    {
        self waittill ("grenade_fire", grenade, weapname);
        if ( weapname == "frag_grenade_zm" )
        {
            grenade thread multiply_grenades();
        }
        wait 0.1;
    }
}

multiply_grenades()
{
    self endon ( "death" );
    wait 1.25;
    self magicgrenadetype( "frag_grenade_zm", self.origin + ( 20, 0, 0 ), ( 50, 0, 400 ), 2.5 );
    wait 0.1;
    self magicgrenadetype( "frag_grenade_zm", self.origin + ( -20, 0, 0 ), ( -50, 0, 400 ), 2.5 );
    wait 0.1;
    self magicgrenadetype( "frag_grenade_zm", self.origin + ( 0, 20, 0 ), ( 0, 50, 400 ), 2.5 );
    wait 0.1;
    self magicgrenadetype( "frag_grenade_zm", self.origin + ( 0, -20, 0 ), ( 0, -50, 400 ), 2.5 );
    wait 0.1;
    self magicgrenadetype( "frag_grenade_zm", self.origin, ( 0, 0, 400 ), 2.5 );
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

overflowfix()
{
    level endon( "game_ended" );
    level endon( "host_migration_begin" );
    level.test = createserverfontstring( "default", 1 );
    level.test settext( "xTUL" );
    level.test.alpha = 0;

    if ( getdvar( "g_gametype" ) == "sd" )
        a = 45;
    else
        a = 55;

    for (;;)
    {
        level waittill( "textset" );

        if ( level.result >= a )
        {
            level.test clearalltextafterhudelem();
            level.result = 0;

            foreach ( player in level.players )
            {
                if ( player.menu.open && player isverified() )
                {
                    player.isoverflowing = 1;
                    player submenu( player.curmenu, player.curtitle );
                    player.aio["closeText"] setsafetext( "[{+speed_throw}]+[{+melee}] to Open Ragnarok" );
                    player.aio["status"] setsafetext( "Status: " + verificationtocolor( player.status ) );
                }

                if ( !player.menu.open && player isverified() )
                {
                    player.aio["closeText"] setsafetext( "[{+speed_throw}]+[{+melee}] to Open Ragnarok" );
                    player.aio["status"] setsafetext( "Status: " + verificationtocolor( player.status ) );
                }
            }
        }
    }
}
// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

fr3zzzom()
{
    if ( self.fr3zzzom == 0 )
    {
        self iprintlnbold( "Freeze Zombies [^2ON^7]" );
        setdvar( "g_ai", "0" );
        self.fr3zzzom = 1;
    }
    else
    {
        self iprintlnbold( "Freeze Zombies [^1OFF^7]" );
        setdvar( "g_ai", "1" );
        self.fr3zzzom = 0;
    }
}

zombiekill()
{
    zombs = getaiarray( "axis" );
    level.zombie_total = 0;

    if ( isdefined( zombs ) )
    {
        for ( i = 0; i < zombs.size; i++ )
        {
            zombs[i] dodamage( zombs[i].health * 5000, ( 0, 0, 0 ), self );
            wait 0.05;
        }

        self dopnuke();
        self iprintlnbold( "All Zombies ^1Eliminated" );
    }
}

headless()
{
    zombz = getaispeciesarray( "axis", "all" );

    for ( i = 0; i < zombz.size; i++ )
        zombz[i] detachall();

    self iprintlnbold( "Zombies Are ^2Headless!" );
}

tgl_zz2()
{
    if ( !isdefined( self.zombz2ch ) )
    {
        self.zombz2ch = 1;
        self iprintlnbold( "Teleport Zombies To Crosshairs [^2ON^7]" );
        self thread fhh649();
    }
    else
    {
        self.zombz2ch = undefined;
        self iprintlnbold( "Teleport Zombies To Crosshairs [^1OFF^7]" );
        self notify( "Zombz2CHs_off" );
    }
}

zombieinvisible()
{
    if ( self.zminvisible == 0 )
    {
        self thread invizombz();
        self iprintlnbold( "Invisible Zombies [^2ON^7]" );
        self.zminvisible = 1;
    }
    else
    {
        self thread showzombz();
        self iprintlnbold( "Invisible Zombies [^1OFF^7]" );
        self.zminvisible = 0;
    }
}

invizombz()
{
    zombie = getaiarray( "axis" );

    for ( z = 0; z < zombie.size; z++ )
    {
        self.zombsvis = 1;
        zombie[z] hide();
    }
}

showzombz()
{
    zombie = getaiarray( "axis" );

    for ( z = 0; z < zombie.size; z++ )
        zombie[z] show();
}

zombiedefaultactor()
{
    zombz = getaispeciesarray( "axis", "all" );

    for ( i = 0; i < zombz.size; i++ )
        zombz[i] setmodel( "defaultactor" );

    self iprintlnbold( "^5Debug Zombies!" );
}

zombiecount()
{
    zombies = getaiarray( "axis" );
    self iprintlnbold( "Zombies ^1Remaining ^7: ^2" + zombies.size );
}

donospawnzombies()
{
    if ( self.spawnigzombroz == 0 )
    {
        self.spawnigzombroz = 1;

        if ( isdefined( flag_init( "spawn_zombies", 0 ) ) )
            flag_init( "spawn_zombies", 0 );

        self thread zombiekill();
        self iprintlnbold( "Disable Zombies [^2ON^7]" );
    }
    else
    {
        self.spawnigzombroz = 0;

        if ( isdefined( flag_init( "spawn_zombies", 1 ) ) )
            flag_init( "spawn_zombies", 1 );

        self thread zombiekill();
        self iprintlnbold( "Disable Zombies [^1OFF^7]" );
    }
}

fhh649()
{
    self endon( "Zombz2CHs_off" );

    for (;;)
    {
        self waittill( "weapon_fired" );

        zombz = getaispeciesarray( "axis", "all" );
        eye = self geteye();
        vec = anglestoforward( self getplayerangles() );
        end = ( vec[0] * 100000000, vec[1] * 100000000, vec[2] * 100000000 );
        teleport_loc = bullettrace( eye, end, 0, self )["position"];

        for ( i = 0; i < zombz.size; i++ )
        {
            zombz[i] forceteleport( teleport_loc );
            zombz[i] reset_attack_spot();
        }

        self iprintlnbold( "All Zombies To ^2Crosshairs" );
    }
}
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
