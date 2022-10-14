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
    //level.player_out_of_playable_area_monitor = 0;
    level.firsthostspawned = 0;
    init_LRZ_Dvars();
    level thread precacheassets();
    if(getDvarInt("LRZ_ZPP_enabled") == 1 && getDvar("CUSTOM_MAP") == "0")
    {
        level thread zpp_init();
        //level thread lrz_aats::init();
    }
    //level thread replaceFuncs();
    level thread onconnect();
    level thread onplayerconnect();
    level thread removeskybarrier();
    level thread upload_stats_on_round_end();
    level thread upload_stats_on_game_end();
    level thread upload_stats_on_player_connect();
    level.init = 0;
    settings();
    level thread lrz_checks();
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
	
    level thread zpp_onPlayerConnect(); //on connect
	thread zpp_initServerDvars(); //initilize server dvars (credit JezuzLizard)
	thread zpp_startCustomPerkMachines(); //custom perk machines
	    //level.afterlife_give_loadout = ::give_afterlife_loadout; //override function that gives loadout back to the player.
	level.playerDamageStub = level.callbackplayerdamage; //damage callback for phd flopper
	level.callbackplayerdamage = ::phd_flopper_dmg_check; //more damage callback stuff. everybody do the flop
	    //level.using_solo_revive = 0; //disables solo revive, fixing only 3 revives per game.
	    //level.is_forever_solo_game = 0; //changes afterlives on motd from 3 to 1
	if(getdvar("ui_zm_mapstartlocation") == "town")
        isTown(); //jezuzlizard's fix for tombstone :)
    
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
		player thread zpp_onPlayerDowned();
		player thread zpp_onPlayerRevived();
		player thread spawnIfRoundOne(); //force spawns if round 1. no more spectating one player on round 1
        wait 0.05;
	}
}

onconnect()
{
    for (;;)
    {
        level waittill( "connected", player );
        player thread VIP_Check();
        player thread max_ammo_refill_clip();
        player thread connected();
        wait 0.05;
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

        //if ( isdefined( level.player_out_of_playable_area_monitor ) )
            //level.player_out_of_playable_area_monitor = 0;
        wait 0.05;
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
        wait 0.05;
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
            wait 0.05;
            self iprintln( "^5Loki's Ragnarok Zombies++^7 is Disabled" );

            level waittill( "LRZ_Trigger_Enable" );

            wait 0.05;
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

            wait 0.05;
        }

        wait 0.05;
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
    self.aio["scriptVersion"] = "1.5.3";
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
