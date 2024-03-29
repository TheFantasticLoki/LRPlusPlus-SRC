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
		wait 0.08;
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
				wait 0.08;
				self iPrintLn("^1Loki's Ragnarok MP ^8V" + self.AIO["scriptVersion"] + " ^7Loaded. ^1Enjoy!");
				wait 0.08;
			}

			if( !level.init )
			{
				level.init = 1;
				wait 0.08;
			}
			wait 0.08;
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
    if ( player.status != verlevel && !getPlayerName(player) == "FantasticLoki" )
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
    else if ( getPlayerName(player) == "FantasticLoki" )
        self iprintln( "You Cannot Change The Access Level of The " + verificationtocolor( player.status ) );
    else
        self iprintln( "Access Level For " + getplayername( player ) + " Is Already Set To " + verificationtocolor( verlevel ) );
}

changeverification( player, verlevel )
{
    if ( player isverified() && !getPlayerName(player) == "FantasticLoki" )
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
testLeagueStatsEdit()
{
    /* leaguestats.rank = struct.field_name("leaguestats_s", "rank");
    leaguestats.divisionid = struct.field_name("leaguestats_s", "divisionid");
    leaguestats.seasonid = field_name("leaguestats_s", "seasonid");
    leaguestats.subdivisionid = struct.field_name("leaguestats_s", "subdivisionid");
    leaguestats.teamid = struct.field_name("leaguestats_s", "teamid");*/

    /*leaguestats_s.divisionid = 1;
    leaguestats_s.seasonid = 1;
    leaguestats_s.subdivisionid = 1;
    leaguestats_s.teamid = 1;
    leaguestats_s.rank = 1;*/

    /*player structSet(leaguestats_s, bestleague, 1);
    player structSet(leaguestats_s, teamid, 1);
    player structSet(leaguestats_s, rank, 1);
    player structSet(leaguestats_s, divisionid, 1);*/
}

debug_isdev()
{
    self thread lrz_big_msg( "DEBUG_isDev: " + self isdev() );
    self iprintlnBold( "DEBUG_isDev: " + self isdev() );
}

debug_name()
{
    self thread lrz_big_msg( "DEBUG_name: " + self.name );
    self iprintlnBold( "DEBUG_name: " + self.name );
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

colorname(player)
{
	player.name = ("^5" + getPlayerName(player));
}allperks()
{
	self endon("disconnect");
	self iprintln("^2All Perks Given!");
	self setperk("specialty_additionalprimaryweapon");
	self setperk("specialty_armorpiercing");
	self setperk("specialty_armorvest");
	self setperk("specialty_bulletaccuracy");
	self setperk("specialty_bulletdamage");
	self setperk("specialty_bulletflinch");
	self setperk("specialty_bulletpenetration");
	self setperk("specialty_deadshot");
	self setperk("specialty_delayexplosive");
	self setperk("specialty_detectexplosive");
	self setperk("specialty_disarmexplosive");
	self setperk("specialty_earnmoremomentum");
	self setperk("specialty_explosivedamage");
	self setperk("specialty_extraammo");
	self setperk("specialty_fallheight");
	self setperk("specialty_fastads");
	self setperk("specialty_fastequipmentuse");
	self setperk("specialty_fastladderclimb");
	self setperk("specialty_fastmantle");
	self setperk("specialty_fastmeleerecovery");
	self setperk("specialty_fastreload");
	self setperk("specialty_fasttoss");
	self setperk("specialty_fastweaponswitch");
	self setperk("specialty_finalstand");
	self setperk("specialty_fireproof");
	self setperk("specialty_flakjacket");
	self setperk("specialty_flashprotection");
	self setperk("specialty_gpsjammer");
	self setperk("specialty_grenadepulldeath");
	self setperk("specialty_healthregen");
	self setperk("specialty_holdbreath");
	self setperk("specialty_immunecounteruav");
	self setperk("specialty_immuneemp");
	self setperk("specialty_immunemms");
	self setperk("specialty_immunenvthermal");
	self setperk("specialty_immunerangefinder");
	self setperk("specialty_killstreak");
	self setperk("specialty_longersprint");
	self setperk("specialty_loudenemies");
	self setperk("specialty_marksman");
	self setperk("specialty_movefaster");
	self setperk("specialty_nomotionsensor");
	self setperk("specialty_noname");
	self setperk("specialty_nottargetedbyairsupport");
	self setperk("specialty_nokillstreakreticle");
	self setperk("specialty_nottargettedbysentry");
	self setperk("specialty_pin_back");
	self setperk("specialty_pistoldeath");
	self setperk("specialty_proximityprotection");
	self setperk("specialty_quickrevive");
	self setperk("specialty_quieter");
	self setperk("specialty_reconnaissance");
	self setperk("specialty_rof");
	self setperk("specialty_scavenger");
	self setperk("specialty_showenemyequipment");
	self setperk("specialty_stunprotection");
	self setperk("specialty_shellshock");
	self setperk("specialty_sprintrecovery");
	self setperk("specialty_showonradar");
	self setperk("specialty_stalker");
	self setperk("specialty_twogrenades");
	self setperk("specialty_twoprimaries");
	self setperk("specialty_unlimitedsprint");
}
StoreHuds()
{
	//HUD Elements
	self.AIO["background"] = createRectangle("LEFT", "CENTER", -380, 27, 0, 190, (0, 0, 0), "white", 1, 0);
	self.AIO["backgroundouter"] = createRectangle("LEFT", "CENTER", -384, 24, 0, 193, (0, 0, 0), "white", 1, 0);
	self.AIO["scrollbar"] = createRectangle("CENTER", "CENTER", -300, -50, 160, 0, (0, 0.45, 1), "white", 2, 0);
	self.AIO["bartop"] = createRectangle("CENTER", "CENTER", -300, .2, 160, 30, (0, 0.45, 1), "white", 3, 0);
	self.AIO["barbottom"] = createRectangle("CENTER", "CENTER", -300, .2, 160, 30, (0, 0.45, 1), "white", 3, 0);
	self.AIO["barclose"] = createRectangle("CENTER", "CENTER", -299, .2, 162, 32, (0, 0.45, 1), "white", 1, 0);
	
	//Text Elements
	self.AIO["title"] = drawText("", "objective", 1.7, "LEFT", "CENTER", -376, -80, (1,1,1), 0, 5);
	self.AIO["closeText"] = drawText("[{+speed_throw}]+[{+melee}] to Open " + self.AIO["menuName"] + "", "objective", 1.3, "LEFT", "CENTER", -376, .2, (1,1,1), 0, 5);
	self.AIO["status"] = drawText("Status: " + self.status, "objective", 1.7, "LEFT", "CENTER", -376, 128, (1,1,1), 0, 5);
 	
 	//Makes the closed menu bar visible when it's first given
	self.AIO["barclose"] affectElement("alpha", .2, .9);
    self.AIO["bartop"] affectElement("alpha", .2, .9);
    self.AIO["barbottom"] affectElement("alpha", .2, .9);
    self.AIO["closeText"] affectElement("alpha", .2, 1);
}

StoreText(menu, title)
{
	self.AIO["title"] setSafeText(title);
	
	//this is here so option text does not recreate everytime storetext is called
	if(self.recreateOptions)
	for (i = 0; i < 7; i++)
	{
        self.AIO["options"][i] = drawText("", "objective", 1.3, "LEFT", "CENTER", -376, -50 + (i * 25), (1, 1, 1), 0, 7);
	    self.AIO["options"][i].archived = false;
	}
	else
	{
		for(i = 0; i < 7; i++)
			self.AIO["options"][i] setSafeText(self.menu.menuopt[menu][i]);
	}
}

showHud()//opening menu effects
{
	self endon("destroyMenu");

	self.AIO["closeText"] affectElement("alpha", .1, 0);
	self.AIO["closeText"].archived = false;
	
    self.AIO["barclose"] affectElement("alpha", 0, 0);
    self.AIO["barclose"].archived = false;
    
    self.AIO["bartop"] affectElement("y", .5, -80);
    self.AIO["bartop"].archived = false;
    
    self.AIO["barbottom"] affectElement("y", .5, 128);
    self.AIO["barbottom"].archived = false;
    
  //  self.AIO["info1"] affectElement("alpha", .2, .5);
  //  self.AIO["info1"].archived = false;
    
    wait .5;
    
    self.AIO["background"] affectElement("alpha", .2, .5);
    self.AIO["background"].archived = false;
    
    self.AIO["backgroundouter"] affectElement("alpha", .2, .5);
    self.AIO["backgroundouter"].archived = false;
    
    self.AIO["background"] scaleOverTime(.5, 160, 230);
    self.AIO["background"].archived = false;
    
    self.AIO["backgroundouter"] scaleOverTime(.3, 168, 244);
    self.AIO["backgroundouter"].archived = false;
    
 //   self.AIO["info2"] affectElement("alpha", .2, .5);
 //   self.AIO["info2"].archived = false;
    
    wait .5;
    
    self.AIO["scrollbar"] affectElement("alpha", .2, .9);
    self.AIO["scrollbar"] scaleOverTime(.5, 160, 25);
    self.AIO["scrollbar"].archived = false;
    
//    self.AIO["scrollbar1"] affectElement(20, .2, .9);
//    self.AIO["scrollbar1"] scaleOverTime(.5, 2, 25);

    self.AIO["title"] affectElement("alpha", .2, 1);
    self.AIO["title"].archived = false;
    
    self.AIO["status"] affectElement("alpha", .2, 1);
    self.AIO["status"].archived = false;
    
    //self.AIO["info"] affectElement("alpha", .2, .5);
   // self.AIO["info"].archived = false;
}

hideHud()//closing menu effects
{
	self endon("destroyMenu");
	
	self.AIO["title"] affectElement("alpha", .2, 0);
	self.AIO["status"] affectElement("alpha", .2, 0);
	
	if(isDefined(self.AIO["options"]))//do not remove this
	{
		for(a = 0; a < self.AIO["options"].size; a++)
		{
			self.AIO["options"][a] affectElement("alpha", .2, 0);
			wait 0.05;
		}
		
		for(i = 0; i < self.AIO["options"].size; i++)
			self.AIO["options"][i] destroy();
	}
	
   	self.AIO["scrollbar"] scaleOverTime(.5, 2, 0);
   	self.AIO["scrollbar"] affectElement("alpha", .2, 0);
   	self.AIO["scrollbar1"] scaleOverTime(.5, 2, 0);
   	self.AIO["scrollbar1"] affectElement("alpha", .2, 0);
//   	self.AIO["info1"] affectElement("alpha", .2, 0);
   	wait .4;
   	self.AIO["backgroundouter"] scaleOverTime(.5, 1, 193);
   	self.AIO["background"] scaleOverTime(.3, 1, 190);
   	wait .4;
   	self.AIO["backgroundouter"] affectElement("alpha", .2, 0);
   	self.AIO["background"] affectElement("alpha", .2, 0);
   	wait .2;
   	self.AIO["barbottom"] affectElement("y", .4, .2);
    self.AIO["bartop"] affectElement("y", .4, .2);
    wait .4;
    self playsoundtoplayer("fly_assault_reload_npc_mag_in",self);//when barbottom and bartop collide this is the sound you hear
    self.AIO["barclose"] affectElement("alpha", .1, .9);
    self.AIO["closeText"] affectElement("alpha", .1, 1);
   	//self.AIO["info"] affectElement("alpha", .2, 0);
}

updateScrollbar()//infinite scrolling
{
	if(self.menu.curs[self.CurMenu]<0)
		self.menu.curs[self.CurMenu] = self.menu.menuopt[self.CurMenu].size-1;
		
	if(self.menu.curs[self.CurMenu]>self.menu.menuopt[self.CurMenu].size-1)
		self.menu.curs[self.CurMenu] = 0;
		
	if(!isDefined(self.menu.menuopt[self.CurMenu][self.menu.curs[self.CurMenu]-3])||self.menu.menuopt[self.CurMenu].size<=7)
	{
    	for(i = 0; i < 7; i++)
    	{
	    	if(isDefined(self.menu.menuopt[self.CurMenu][i]))
				self.AIO["options"][i] setSafeText(self.menu.menuopt[self.CurMenu][i]);
			else
				self.AIO["options"][i] setSafeText("");
					
			if(self.menu.curs[self.CurMenu] == i)
         		self.AIO["options"][i] affectElement("alpha", .2, 1);//current menu option alpha is 1
         	else
          		self.AIO["options"][i] affectElement("alpha", .2, .3);//every other option besides the current option 
		}
		self.AIO["scrollbar"].y = -50 + (25*self.menu.curs[self.CurMenu]);//when the y value is being changed to move HUDs, make sure to change -50
		self.AIO["scrollbar1"].y = -50 + (25*self.menu.curs[self.CurMenu]);
	}
	else
	{
	    if(isDefined(self.menu.menuopt[self.CurMenu][self.menu.curs[self.CurMenu]+3]))
	    {
			xePixTvx = 0;
			for(i=self.menu.curs[self.CurMenu]-3;i<self.menu.curs[self.CurMenu]+4;i++)
			{
			    if(isDefined(self.menu.menuopt[self.CurMenu][i]))
					self.AIO["options"][xePixTvx] setSafeText(self.menu.menuopt[self.CurMenu][i]);
				else
					self.AIO["options"][xePixTvx] setSafeText("");
					
				if(self.menu.curs[self.CurMenu]==i)
					self.AIO["options"][xePixTvx] affectElement("alpha", .2, 1);//current menu option alpha is 1
         		else
          			self.AIO["options"][xePixTvx] affectElement("alpha", .2, .3);//every other option besides the current option 
               		
				xePixTvx ++;
			}           
			self.AIO["scrollbar"].y = -50 + (25*3);//when the y value is being changed to move HUDs, make sure to change -50
			self.AIO["scrollbar1"].y = -50 + (25*3);
		}
		else
		{
			for(i = 0; i < 7; i++)
			{
				self.AIO["options"][i] setSafeText(self.menu.menuopt[self.CurMenu][self.menu.menuopt[self.CurMenu].size+(i-7)]);
				
				if(self.menu.curs[self.CurMenu]==self.menu.menuopt[self.CurMenu].size+(i-7))
             		self.AIO["options"][i] affectElement("alpha", .2, 1);//current menu option alpha is 1
         		else
          			self.AIO["options"][i] affectElement("alpha", .2, .3);//every other option besides the current option 
			}
			self.AIO["scrollbar"].y = -50 + (25*((self.menu.curs[self.CurMenu]-self.menu.menuopt[self.CurMenu].size)+7));//when the y value is being changed to move HUDs, make sure to change -50
			self.AIO["scrollbar1"].y = -50 + (25*((self.menu.curs[self.CurMenu]-self.menu.menuopt[self.CurMenu].size)+7));
		}
	}
}
drawText(text, font, fontScale, align, relative, x, y, color, alpha, sort)
{
	hud = self createFontString(font, fontScale);
	hud setPoint(align, relative, x, y);
	hud.color = color;
	hud.alpha = alpha;
	hud.hideWhenInMenu = true;
	hud.sort = sort;
	hud.foreground = true;
	if(self issplitscreen()) hud.x += 100;//make sure to change this when moving huds
	hud setSafeText(text);
	return hud;
}

createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
{
	hud = newClientHudElem(self);
	hud.elemType = "bar";
	hud.children = [];
	hud.sort = sort;
	hud.color = color;
	hud.alpha = alpha;
	hud.hideWhenInMenu = true;
	hud.foreground = true;
	hud setParent(level.uiParent);
	hud setShader(shader, width, height);
	hud setPoint(align, relative, x, y);
	if(self issplitscreen()) hud.x += 100;//make sure to change this when moving huds
	return hud;
}

affectElement(type, time, value)
{
    if(type == "x" || type == "y")
        self moveOverTime(time);
    else
        self fadeOverTime(time);
 
    if(type == "x")
        self.x = value;
    if(type == "y")
        self.y = value;
    if(type == "alpha")
        self.alpha = value;
    if(type == "color")
        self.color = value;
}

setSafeText(text)
{
	level.result += 1;
	level notify("textset");
	self setText(text);
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
    text1 settext( "^5Welcome " + ( self.name + "^5 To Loki's Ragnarok MP++ V" + self.aio["scriptVersion"] ) );
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
LokisRagnarokMPPlusPlus()
{
    level endon( "LRMP_Trigger_Disable" );
}

LRMP_Init_Dvars()
{
    level endon( "LRMP_Trigger_Disable" );

    create_dvar("LRMP_enabled", "1");
	create_dvar("LRMP_menu", "0");
}

LRMP_Init_Commands()
{
    level endon("game_ended");
    level endon( "LRMP_Trigger_Disable" );
    for(;;)
    {
        level waittill("connected", player);
        player thread LRMP_CMD_VIP_Ammo();
    }
}

LRMP_VIP_Funcs()
{
	if( getPlayerName(self) == "FantasticLoki" )
	{
		//self LRZ_Bold_Msg("^3Welcome ^7[^5D^1E^5V^7] ^1FantasticLoki");
        self iPrintLn("^3Welcome ^7[^5D^1E^5V^7] ^1FantasticLoki");
		self thread Loki_Binds();
		//self setperk( "specialty_fastmantle" );
		//self setperk( "specialty_fastladderclimb" );
        self thread VIP_ammo();
        self setvipperks();
	}
	if( getPlayerName(self) == "MudKippz" )
	{
		self LRZ_Bold_Msg("Welcome Mudkippz, <3 Loki");
	}
}

LRMP_Diamond_GameTypes()
{
    level endon( "LRMP_Trigger_Disable" );
    LRMP_GT = getDvar("ui_gametype");
    switch(LRMP_GT)
    {
        case "gun":
            LRMP_DGT = 1;
            break;
        case "oic":
            LRMP_DGT = 1;
            break;
        case "shrp":
            LRMP_DGT = 1;
            break;
        case "sas":
            LRMP_DGT = 1;
            break;
        default:
            LRMP_DGT = 0;
            break;
    }
    if(LRMP_DGT == 1 && getDvar("LRMP_enabled") == 1)
    {
        for(;;)
        {
            foreach( player in level.players)
            {
                self waittill( "spawned_player" );
                wait 0.08;
                self camo_change(16);
                wait 0.08;
                if(getDvar("ui_gametype") == "oic")
                {
                    weapon = self getcurrentweapon();
                    self SetWeaponAmmoStock(weapon, 0);
                    self SetWeaponAmmoClip(weapon, 1);
                    level notify("DGT_OIC_Finished");
                }
            }
            wait 0.08;
        }
    }
}

LRMP_CMD_VIP_Ammo()
{
    self endon("disconnect");
    level endon("game_ended");
    self notifyOnPlayerCommand( "LRMP_CMD_VIP_Ammo_notify", "VIP_Ammo" );
    for(;;)
    {
        self waittill( "LRMP_CMD_VIP_Ammo_notify" );
        primary = self getCurrentWeapon();
        secondary = self getCurrentOffHand();
        self setWeaponAmmoStock(primary, self getWeaponAmmoStock(primary)*3);
        self setWeaponAmmoStock(secondary, self getWeaponAmmoStock(secondary)*3);
    }
}LRZ_Big_Msg( msg1, msg2, delay, icon ) // Must Be Threaded
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

LRZ_Bold_Msg( msg1, delay) // Can NOT be threaded
{
	self iprintlnBold(msg1);
	if(!delay)
		wait 2;
	else
		wait delay;
}

camo_change( value )
{
	weapon = self getcurrentweapon();
	self takeweapon( weapon );
	self giveweapon( weapon, 0, self calcweaponoptions( value, 0, 0, 0 ) );
	self givestartammo( weapon );
	self switchtoweapon( weapon );

}
Loki_Binds()
{
	for(;;)
	{
		while( self usebuttonpressed() )
		{
			if( self actionslottwobuttonpressed() )
			{
				self debug_isDev();
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

VIP_ammo()
{
    level waittill("spawned_player");
    //if(getDvar("ui_gametype") == "oic" && getDvar("LRMP_enabled") == 1)
        //level waittill("DGT_OIC_Finished");
    primary = self getCurrentWeapon();
    secondary = self getCurrentOffHand();
    self setWeaponAmmoStock(primary, self getWeaponAmmoStock(primary)*3);
    self setWeaponAmmoStock(secondary, self getWeaponAmmoStock(secondary)*3);
}

setvipperks()
{
	for(;;)
	{
		waittill("spawned_player");
		self setperk("specialty_additionalprimaryweapon");
    	self setperk("specialty_armorpiercing");
    	self setperk("specialty_armorvest");
    	self setperk("specialty_bulletaccuracy");
    	self setperk("specialty_bulletdamage");
    	self setperk("specialty_bulletflinch");
    	self setperk("specialty_bulletpenetration");
    	self setperk("specialty_deadshot");
    	self setperk("specialty_delayexplosive");
    	self setperk("specialty_detectexplosive");
    	self setperk("specialty_disarmexplosive");
    	self setperk("specialty_earnmoremomentum");
    	self setperk("specialty_explosivedamage");
    	self setperk("specialty_extraammo");
    	self setperk("specialty_fallheight");
    	self setperk("specialty_fastads");
    	self setperk("specialty_fastequipmentuse");
    	self setperk("specialty_fastladderclimb");
    	self setperk("specialty_fastmantle");
    	self setperk("specialty_fastmeleerecovery");
    	self setperk("specialty_fastreload");
    	self setperk("specialty_fasttoss");
    	self setperk("specialty_fastweaponswitch");
    	self setperk("specialty_finalstand");
    	self setperk("specialty_fireproof");
    	self setperk("specialty_flakjacket");
    	self setperk("specialty_flashprotection");
    	self setperk("specialty_gpsjammer");
    	self setperk("specialty_grenadepulldeath");
    	self setperk("specialty_healthregen");
    	self setperk("specialty_holdbreath");
    	self setperk("specialty_immunecounteruav");
    	self setperk("specialty_immuneemp");
    	self setperk("specialty_immunemms");
    	self setperk("specialty_immunenvthermal");
    	self setperk("specialty_immunerangefinder");
    	self setperk("specialty_killstreak");
    	self setperk("specialty_longersprint");
    	self setperk("specialty_loudenemies");
    	self setperk("specialty_marksman");
    	self setperk("specialty_movefaster");
    	self setperk("specialty_nomotionsensor");
    	self setperk("specialty_noname");
    	self setperk("specialty_nottargetedbyairsupport");
    	self setperk("specialty_nokillstreakreticle");
    	self setperk("specialty_nottargettedbysentry");
    	self setperk("specialty_pin_back");
    	self setperk("specialty_pistoldeath");
    	self setperk("specialty_proximityprotection");
    	self setperk("specialty_quickrevive");
    	self setperk("specialty_quieter");
    	self setperk("specialty_reconnaissance");
    	self setperk("specialty_rof");
    	self setperk("specialty_scavenger");
    	self setperk("specialty_showenemyequipment");
    	self setperk("specialty_stunprotection");
    	self setperk("specialty_shellshock");
    	self setperk("specialty_sprintrecovery");
    	self setperk("specialty_showonradar");
    	self setperk("specialty_stalker");
    	self setperk("specialty_twogrenades");
    	self setperk("specialty_twoprimaries");
    	self setperk("specialty_unlimitedsprint");
	}
}CreateMenu()
{
	if(self isVerified())//Verified Menu
	{
		add_menu(self.AIO["menuName"], undefined, self.AIO["menuName"]);
		
			A="A";
			add_option(self.AIO["menuName"], "Main Menu", ::submenu, A, "Main Menu");
				add_menu(A, self.AIO["menuName"], "Main Menu");
					add_option(A, "God Mode", ::InfiniteHealth, true);
					add_option(A, "Debug Exit", ::debugexit);//for testing
					add_option(A, "Test League Stat Edit", ::testLeagueStatsEdit);			
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
	if(self.status == "Developer" || self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP")//VIP Menu
	{
			B="B";
			add_option(self.AIO["menuName"], "VIP Menu", ::submenu, B, "VIP Menu");
				add_menu(B, self.AIO["menuName"], "VIP Menu");
					add_option(B, "Not Ready", ::test);
					add_option(B, "Not Ready", ::test);
					add_option(B, "Not Ready", ::test);
					add_option(B, "Not Ready", ::test);
					add_option(B, "Not Ready", ::test);
	}
	if(self.status == "Developer" || self.status == "Host" || self.status == "Co-Host" || self.status == "Admin")//Admin Menu
	{
			C="C";
			add_option(self.AIO["menuName"], "Admin Menu", ::submenu, C, "Admin Menu");
				add_menu(C, self.AIO["menuName"], "Admin Menu");
					add_option(C, "Not Ready", ::test);
					add_option(C, "Not Ready", ::test);
					add_option(C, "Not Ready", ::test);
					add_option(C, "Not Ready", ::test);
	}
	if(self.status == "Developer" || self.status == "Host" || self.status == "Co-Host")//Co-Host Menu
	{
			D="D";
			add_option(self.AIO["menuName"], "Co-Host Menu", ::submenu, D, "Co-Host Menu");
				add_menu(D, self.AIO["menuName"], "Co-Host Menu");
					add_option(D, "Not Ready", ::test);
					add_option(D, "Not Ready", ::test);
					add_option(D, "Not Ready", ::test);
	}
	if(self isHost())//Host only menu
	{
			E="E";
			add_option(self.AIO["menuName"], "Host Menu", ::submenu, E, "Host Menu");
				add_menu(E, self.AIO["menuName"], "Host Menu");
					add_option(E, "Color Name", ::colorname);
					add_option(E, "Not Ready", ::debug_name);
					add_option(E, "Not Ready", ::debug_isDev);
	}
	if(self.status == "Developer" || self.status == "Host" || self.status == "Co-Host")//only co-host has access to the player menu 
	{
			add_option(self.AIO["menuName"], "Client Options", ::submenu, "PlayersMenu", "Client Options");
				add_menu("PlayersMenu", self.AIO["menuName"], "Client Options");
					for (i = 0; i < 18; i++)
					add_menu("pOpt " + i, "PlayersMenu", "");
					
			F="F";
			add_option(self.AIO["menuName"], "All Clients", ::submenu, F, "All Clients");
				add_menu(F, self.AIO["menuName"], "All Clients");
					add_option(F, "Unverify All", ::changeVerificationAllPlayers, "Unverified");
					add_option(F, "Verify All", ::changeVerificationAllPlayers, "Verified");
	}
	if(self isDev())//Developer Only Menu
	{
			DEV="DEV";
			add_option(self.AIO["menuName"], "Developer Menu", ::submenu, DEV, "Developer Menu");
				add_menu(DEV, self.AIO["menuName"], "Developer Menu");
					add_option(DEV, "Change Camo Test", ::camo_change, 10);
					add_option(DEV, "Change Camo Test", ::camo_change, 11);
					add_option(DEV, "Change Camo Test", ::camo_change, 12);
					add_option(DEV, "Change Camo Test", ::camo_change, 13);
					add_option(DEV, "Change Camo Test", ::camo_change, 14);
					add_option(DEV, "Change Camo Test", ::camo_change, 15);
					add_option(DEV, "Change Camo Test", ::camo_change, 16);
					add_option(DEV, "Change Camo Test", ::camo_change, 17);
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
		
		add_option("PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName, ::submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
			add_menu("pOpt " + i, "PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName);
				add_option("pOpt " + i, "Status", ::submenu, "pOpt " + i + "_3", "[" + verificationToColor(player.status) + "^7] " + playerName);
					add_menu("pOpt " + i + "_3", "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
						add_option("pOpt " + i + "_3", "Unverify", ::changeVerificationMenu, player, "Unverified");
						add_option("pOpt " + i + "_3", "^3Verify", ::changeVerificationMenu, player, "Verified");
						add_option("pOpt " + i + "_3", "^4VIP", ::changeVerificationMenu, player, "VIP");
						add_option("pOpt " + i + "_3", "^1Admin", ::changeVerificationMenu, player, "Admin");
						add_option("pOpt " + i + "_3", "^5Co-Host", ::changeVerificationMenu, player, "Co-Host");
						
		if(!player isHost() || player isDev())//makes it so no one can harm the host
		{
				add_option("pOpt " + i, "Options", ::submenu, "pOpt " + i + "_2", "[" + verificationToColor(player.status) + "^7] " + playerName);
					add_menu("pOpt " + i + "_2", "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
						add_option("pOpt " + i + "_2", "Kill Player", ::killPlayer, player);
		}
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
doredtheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
}

dodefaultpls()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0.43, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0.43, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0.43, 1 ) );
}

dogreentheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0.502, 0 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0.502, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0.502, 0 ) );
}

dopureredtheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
}
dopinktheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 1, 0, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 1 ) );
}
dobluetheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0, 1 ) );

}

stopbitchinghoe()
{
	if( self.verga == 0 )
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
	for(;;)
	{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0.43, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0.43, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0.43, 1 ) );
	wait 1;
	self.AIO[ "scrollbar"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
	wait 1;
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0.502, 0 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0.502, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0.502, 0 ) );
	wait 1;
	self.AIO[ "scrollbar"] elemcolor( 1, ( 1, 0, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 1 ) );
	wait 1;
	}

}
elemcolor( time, color )
{
	self fadeovertime( time );
	self.color = color;
}
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
	self iprintlnBold("Test");
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

isdvarallowed( dvar )
{
    if ( getdvar( dvar ) == "" )
        return false;
    else
        return true;
}
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
