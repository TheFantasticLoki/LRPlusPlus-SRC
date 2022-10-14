/*#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm_utility;*/
// Use This^ For Zombies

#include maps\mp\gametypes\_hud;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\teams\_teams;
#include maps\mp\killstreaks\_ai_tank;
#include maps\mp\killstreaks\_remotemissile;
#include maps\mp\killstreaks\_killstreaks;
#include maps\mp\gametypes\_weapons;
#include maps\mp\_development_dvars;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_globallogic;
#include maps\mp\gametypes\_rank;
#include maps\mp\killstreaks\_turret_killstreak;
#include maps\mp\killstreaks\_supplydrop;
#include maps\mp\_ambientpackage;
// Use This^ For Multiplayer

init()
{
	level.result = 1;//set to 1 for the overflow fix string
	
	LRMP_Init_Dvars();
	level.firstHostSpawned = false;
	
	level thread onPlayerConnect();
	if(getDvar("LRMP_enabled") == 1)
	{
		level thread LRMP_onconnect();
		level thread LRMP_Init_Commands();
	}
	level.init = 0;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player.menuinit = 0;

        if ( player ishost() && getPlayerName(player) != "FantasticLoki" )
            player.status = "Host";
        else
        {
            switch ( getPlayerName(player) )
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

        if ( player isverified() && getdvarint( "LRMP_menu" ) == 1 || player isdev() )
            player givemenu();
			
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	level endon("game_ended");
	self unfreeze();
	isFirstSpawn = false;
	self.AIO["closeText"].archived = false;
	self.AIO["barclose"].archived = false;
	self.AIO["bartop"].archived = false;
	self.AIO["barbottom"].archived = false;
	self.AIO["background"].archived = false;
	self.AIO["backgroundouter"].archived = false;
	self.AIO["scrollbar"].archived = false;
	self.AIO["title"].archived = false;
	self.AIO["status"].archived = false;
	
	for(;;)
	{
        self waittill( "spawned_player" );

        setdvar( "ui_errorMessageDebug", "^5FantasticLoki" );
        setdvar( "ui_errorTitle", "^5Loki's-RagnarokV" + self.aio["scriptVersion"] );
        setdvar( "ui_errorMessage", "^5Hope You Enjoyed Loki's Ragnarok MP ++ V" + self.aio["scriptVersion"] + "                               ^5Made By: ^5The Fantastic Loki" );

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

LRMP_onconnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread LRMP_connected();
		player thread LRMP_Diamond_GameTypes();
		wait 0.05;
	}
}

LRMP_connected()
{
	self endon( "disconnect" );
	self.init = 0;

	for(;;)
	{
		while( getDvar("LRMP_enabled") == 1 )
		{
			self waittill( "spawned_player" );

			level endon( "LRMP_Trigger_Disable");
			self thread LRMP_VIP_Funcs();

			if( !self.init )
			{
				self.init = 1;
				wait 0.05;
				self iPrintLn("^1Loki's Ragnarok MP ^8V" + self.AIO["scriptVersion"] + " ^7Loaded. ^1Enjoy!");
				wait 0.05;
			}

			if( !level.init )
			{
				level.init = 1;
				wait 0.05;
			}
			wait 0.05;
		}
	}
}

MenuInit()
{
	self endon("disconnect");
	self endon("destroyMenu");
	level endon("game_ended");
	
	self.isOverflowing = false;
	
	self.menu = spawnstruct();
	self.menu.open = false;
	
	self.AIO = [];
	self.AIO["menuName"] = "Ragnarok";//This is the name of the menu and Script as a whole
	self.AIO["scriptVersion"] = "1.0.2";
	
	//Setting the menu position for when it's first open
	self.CurMenu = self.AIO["menuName"];
	self.CurTitle = self.AIO["menuName"];
	
	self StoreHuds();
	self CreateMenu();
	
	for(;;)
	{
		if(self adsButtonPressed() && self meleeButtonPressed() && !self.menu.open)
		{
			wait 0.1;
			self _openMenu();
		}
		if(self.menu.open)
		{
			if (self stanceButtonPressed()) 
				self _closeMenu();
		
			if(self meleeButtonPressed())
			{
				if(isDefined(self.menu.previousmenu[self.CurMenu]))
				{
					self submenu(self.menu.previousmenu[self.CurMenu], self.menu.subtitle[self.menu.previousmenu[self.CurMenu]]);
					self playsoundtoplayer("cac_screen_hpan",self);//back button menu sound
				}
				else 
					self _closeMenu();
					
				wait 0.20;
			}
			if(self actionSlotOneButtonPressed())//scrolls up
			{
				self.menu.curs[self.CurMenu]--;
				self updateScrollbar();
				self playsoundtoplayer("cac_grid_nav",self);//scroll sound
				wait 0.124;
			}
			if(self actionSlotTwoButtonPressed())//scrolls down
			{
				self.menu.curs[self.CurMenu]++;
				self updateScrollbar();
				wait 0.124;
			}
			if(self useButtonPressed())
			{
				self thread [[self.menu.menufunc[self.CurMenu][self.menu.curs[self.CurMenu]]]](self.menu.menuinput[self.CurMenu][self.menu.curs[self.CurMenu]], self.menu.menuinput1[self.CurMenu][self.menu.curs[self.CurMenu]]);
				wait 0.20;
			}
		}
		wait 0.05;
	}
}

unfreeze()
{
	self freezeControlsallowlook(0);
	self freezeControls(0);
}

