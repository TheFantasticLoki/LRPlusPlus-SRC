#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/gametypes_zm/_spawnlogic;
#include maps/mp/gametypes_zm/_hostmigration;
#include maps/mp/zombies/_zm_sidequests;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/animscripts/zm_combat;
#include maps/mp/animscripts/zm_utility;
#include maps/mp/animscripts/utility;
#include maps/mp/animscripts/shared;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/gametypes_zm/_gv_actions;
#include maps/mp/gametypes_zm/_damagefeedback;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_weap_cymbal_monkey;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_score;
#include scripts/zm/zm_bo2_bots;
// Use This^ For Zombies

/*#include maps/mp/gametypes/_hud;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/_utility;
#include common_scripts/utility;*/
// Use This^ For Multiplayer

settings() 
{
	// Settings 
	level.LRZ_enabled = 1;
	level.LRZ_Menu = 0;
	level.LRZ_Progressive_Perks = 1;
	level.start_round = 1;
	level.LRZ_start_delay = 10;
	// Hud
	level.LRZ_HUD = 1;
	level.LRZ_HUD_timer = 1;
	level.LRZ_HUD_round_timer = 1;
	level.LRZ_HUD_zombie_counter = 1;
	level.LRZ_HUD_health_counter = 1;
	level.LRZ_HUD_zone_names = 1;
}

init()
{
	level.result = 1;//set to 1 for the overflow fix string
	level.player_out_of_playable_area_monitor = 0;
	level.firstHostSpawned = false;
	level thread preCacheAssets();
	level thread onPlayerConnect();
	level thread removeskybarrier();
	level thread upload_stats_on_round_end();
	level thread upload_stats_on_game_end();
	level thread upload_stats_on_player_connect();
	level.init = 0;
	settings();
	//enable_cheats();
	level thread LRZ_Checks();
	level thread onConnect();
	bot_set_skill();
	flag_wait("initial_blackscreen_passed");
	if(!isdefined(level.using_bot_weapon_logic))
		level.using_bot_weapon_logic = 1;
	if(!isdefined(level.using_bot_revive_logic))
		level.using_bot_revive_logic = 1;
	bot_amount = GetDvarIntDefault("bo2_zm_bots_count", 0);
	if(bot_amount > (8-get_players().size))
		bot_amount = 8 - get_players().size;
	for(i=0;i<bot_amount;i++)
		spawn_bot();
}

onConnect()
{
    for (;;)
    {
        level waittill( "connected" , player);
        player thread connected();
    }
}

onPlayerConnect()
{
	self unfreeze();
	enable_LRZ_Menu( 0 );
	for(;;)
	{
		level waittill("connecting", player);
		
		player thread onPlayerSpawned();
		player.MenuInit = false;
		
		level thread playerMenuAuth();

		if(player isVerified() && level.LRZ_Menu == 1) 
		{
			player giveMenu();
		}
		else
		{
			if(player.status == "Developer")
			{
				player giveMenu();
			}
		}
		if( IsDefined( level.player_out_of_playable_area_monitor ) )
		{
			level.player_out_of_playable_area_monitor = 0;
		}
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
		self waittill("spawned_player");
		
		//LRZ_Big_Msg( "VIP Enabled" );
		
		//LRZ_Big_Msg( "Blessings Enabled" );
		self thread welcome_lr();
		setdvar( "ui_errorMessageDebug", "^5FantasticLoki" ); // Set's Message Pop up box information for end of match pop up.
		setdvar( "ui_errorTitle", "^5RagnarokV"+self.AIO["scriptVersion"] );
		setdvar( "ui_errorMessage", "^5Hope You Enjoyed Loki's Ragnarok Zombies ++ V"+self.AIO["scriptVersion"]+" ^5Made By: ^5The Fantastic Loki" );

		if(!level.firstHostSpawned && self.status == "Host")//the first host player that spawns calls on the overflow fix
		{
			thread overflowfix();
			level.firstHostSpawned = true;
		}
		
		self resetBooleans();//resets variable bools

		if(self isVerified())
		{
			self iPrintln("Welcome to "+self.AIO["menuName"]+" V:"+self.AIO["scriptVersion"]+" ^5Made By: ^5The Fantastic Loki");
			
			if(self.menu.open)//if the menu is open when you spawn
				self freezeControlsallowlook(false);
		}
		if(self isHost())
		{
			self freezecontrols(false);
		}
		if(!isFirstSpawn)//First official spawn
		{

			isFirstSpawn = true;
		}
	}
}

connected()
{
	self endon( "disconnect" );
    self.init = 0;

	enable_LRZ( 1 );
	if( !level.LRZ_enabled )
	{
		self LRZ_Big_Msg("LRZ disabled");
		return;//continue;
	}
	for(;;)
    {
		self waittill( "spawned_player" );

		if( !self.init )
        {
            self.init = 1;

            //self.score = 5000;
			//self welcome_message();

			self thread VIP_Funcs();
			self thread Lokis_Blessings();

			//self thread LRZ_Big_Msg( "Test Begin" );

			// HUD
			self thread enable_LRZ_HUD(  );
			wait(0.1);
			self thread timer_hud(  );
			self thread round_timer_hud(  );
			self thread health_remaining_hud(  );
			self thread zombie_remaining_hud(  );
			self thread zone_hud(  );
			//self thread LRZ_Big_Msg( "HUD Enabled" );
		}

		if( !level.init )
        {
            level.init = 1;
			level thread LokisZombiesPlusPlus(); 
			level thread remove_perk_limit();

            enable_cheats();
			enable_LRZ_Progressive_Perks( 1 );


			level thread start_round_delay( level.LRZ_start_delay );
			level thread set_starting_round( 1 );

			wait(0.05);
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
	self.AIO["menuName"] = "Ragnarok";//Put your menu name here
	self.AIO["scriptVersion"] = "1.4.8.2";//Put your script version here
	
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
	self freezeControlsallowlook(false);
	self freezeControls(false);
}





