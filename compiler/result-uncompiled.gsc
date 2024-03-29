#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\animscripts\zm_combat;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\gametypes_zm\_gv_actions;
#include maps\mp\gametypes_zm\_damagefeedback;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_unitrigger;
// Use This^ For Zombies

/*#include maps\mp\gametypes/_hud;
#include maps\mp\gametypes/_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;*/
// Use This^ For Multiplayer

init()
{
	level.result = 1;//set to 1 for the overflow fix string
	level.player_out_of_playable_area_monitor = 0;
	level.firstHostSpawned = false;
	level thread preCacheAssets();
	level thread onPlayerConnect();
	level thread removeskybarrier();
	level thread remove_perk_limit();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player.MenuInit = false;
		
		if( getPlayerName(player) == "FantasticLoki")//here you can add host players
			player.status = "Host";
		else 
			player.status = "Unverified";
			
		/*if(getPlayerName(player) == "MudKippz")//here you can add host players
			player.status = "VIP";
		else 
			player.status = "Unverified";*/
		if(player isVerified()) 
			player giveMenu();
			
		player thread onPlayerSpawned();
		//self thread LokisZombiesPlusPlus(); NOT WORKING Fatal Error
		self thread Progressive_Perks();// Initialize Progressive Perks
		setDvar("revive_trigger_radius", "125");//Additional Perk Tweaks
    	setDvar("jump_height", "45");
    	setDvar("player_breath_hold_time", "10");
		setDvar("perk_sprintMultiplier", "2.25");
    	setDvar("player_meleeRange", "80");
		self.flopp = 1;
		level.zombie_ai_limit = 128;
		level.zombie_actor_limit = 128;
		level.claymores_max_per_player = 64;
		if( getdvar( "mapname" ) == "zm_transit" || getdvar( "mapname" ) == "zm_town")//Remove Fog on Tranzit
    	{
    		setDvar("r_fog", "0");
    	}
		player thread healthCounter();
		player thread zombieCounter();
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
		
		self thread VIP_Funcs();
		self thread Lokis_Blessings();
		wait 5;
		self iprintln("^5Loki's ^1Zombies^3++^5 Loaded, Enjoy!");
		wait 2.0;
		self iprintln("^6Features: Progressive Perks|Doubled Melee & Revive Range|Zombie & Health Counter");
		wait 7;
		self iprintln("^2" +self.name + "^7 , your perk limit has been removed");
		
		if(!level.firstHostSpawned && self.status == "Host")//the first host player that spawns calls on the overflow fix
		{
			thread overflowfix();
			level.firstHostSpawned = true;
		}
		
		self resetBooleans();//resets variable bools

		if(self isVerified())
		{
			self iPrintln("Welcome to "+self.AIO["menuName"]);
			
			if(self.menu.open)//if the menu is open when you spawn
				self freezeControlsallowlook(true);
		}
		if(!isFirstSpawn)//First official spawn
		{
			if(self isHost())
				self freezecontrols(false);

			isFirstSpawn = true;
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





verificationToColor(status)
{
    if (status == "Host")
		return "^2Host";
    if (status == "Co-Host")
		return "^5Co-Host";
    if (status == "Admin")
		return "^1Admin";
    if (status == "VIP")
		return "^4VIP";
    if (status == "Verified")
		return "^3Verified";
    if (status == "Unverified")
		return "None";
}

changeVerificationMenu(player, verlevel)
{
	if (player.status != verlevel && !player == "FantasticLoki")
	{
		if(player isVerified())
		player thread destroyMenu();
		wait 0.03;
		player.status = verlevel;
		wait 0.01;
		
		if(player.status == "Unverified")
		{
			player iPrintln("Your Access Level Has Been Set To None");
			self iprintln("Access Level Has Been Set To None");
		}
		if(player isVerified())
		{
			player giveMenu();
			
			self iprintln("Set Access Level For " + getPlayerName(player) + " To " + verificationToColor(verlevel));
			player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
			player iPrintln("Welcome to "+player.AIO["menuName"]);
		}
	}
	else
	{
		if (player == "FantasticLoki")
			self iprintln("You Cannot Change The Access Level of The " + verificationToColor(player.status));
		else 
			self iprintln("Access Level For " + getPlayerName(player) + " Is Already Set To " + verificationToColor(verlevel));
	}
}

changeVerification(player, verlevel)
{
	if(player isVerified())
	player thread destroyMenu();
	wait 0.03;
	player.status = verlevel;
	wait 0.01;
	
	if(player.status == "Unverified")
		player iPrintln("Your Access Level Has Been Set To None");
		
	if(player isVerified())
	{
		player giveMenu();
		
		player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
		player iPrintln("Welcome to "+player.AIO["menuName"]);
	}
}

changeVerificationAllPlayers(verlevel)
{
	self iprintln("Access Level For Unverified Clients Has Been Set To " + verificationToColor(verlevel));
	
	foreach(player in level.players) 
		if(!(player.status == "Host" || player.status == "Co-Host" || player.status == "Admin" || player.status == "VIP")) 
			changeVerification(player, verlevel);
}

getPlayerName(player)
{
    playerName = getSubStr(player.name, 0, player.name.size);
    for(i = 0; i < playerName.size; i++)
    {
		if(playerName[i] == "]")
			break;
    }
    if(playerName.size != i)
		playerName = getSubStr(playerName, i + 1, playerName.size);
		
    return playerName;
}

isVerified()
{
	if(self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified")
		return true;
	else 
		return false;
}

toggle_god()
{
	if( self.god == 0 )
	{
		self iprintlnbold( "God Mode [^2ON^7]" );
		self.maxhealth = 999999999;
		self.health = self.maxhealth;
		if( self.health < self.maxhealth )
		{
			self.health = self.maxhealth;
		}
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
	if( self.unlammo == 0 )
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
	if( self.invisible == 0 )
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
	self.score = self.score + 21473140;
	self iprintlnbold( "^5Money ^2Given!" );

}

donoclip()
{
	if( self.noclipon == 0 )
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
	for(;;)
	{
	if( self secondaryoffhandbuttonpressed() && self.flynoclip == 0 )
	{
		self.originobj = spawn( "script_origin", self.origin, 1 );
		self.originobj.angles = self.angles;
		self playerlinkto( self.originobj, undefined );
		self.flynoclip = 1;
	}
	if( self.flynoclip == 1 && self secondaryoffhandbuttonpressed() )
	{
		normalized = anglestoforward( self getplayerangles() );
		scaled = vector_scal( normalized, 25 );
		originpos += scaled;
		self.originobj.origin = originpos;
	}
	if( self.flynoclip == 1 && self jumpbuttonpressed() )
	{
		normalized = anglestoforward( self getplayerangles() );
		scaled = vector_scal( normalized, 50 );
		originpos += scaled;
		self.originobj.origin = originpos;
	}
	if( self.flynoclip == 1 && self stancebuttonpressed() )
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
	for(;;)
	{
	self waittill( "death" );
	self.flynoclip = 0;
	}

}

talktonoobs( text )
{
	foreach( player in level.players )
	{
		iprintlnbold( text );
	}

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
	foreach( cheevo in cheevolist )
	{
		self giveachievement( cheevo );
		self iprintln( "^" + ( randomint( 9 ) + ( "Unlocking: " + cheevo ) ) );
		wait 0.2;
	}
	self iprintlnbold( "^1Trophies Unlocked ;)" );

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
	if( self.god == 0 )
	{
		self iprintlnbold( "DemiGod Mode [^2ON^7]" );
		self.maxhealth = 450;
		self.health = self.maxhealth;
		self.DemiGod = 1;
	}
	else
	{
		self iprintlnbold( "DemiGod Mode [^1OFF^7]" );
		self.maxhealth = 100;
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
		if( UNDEFINED_LOCAL.zombie_cymbal_monkey_count )
		{
			self player_give_cymbal_monkey();
			self setweaponammoclip( "cymbal_monkey_zm", UNDEFINED_LOCAL.zombie_cymbal_monkey_count );
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
		self [[  ]]();
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

forcehost()
{
	if( self.fhost == 0 )
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
	self.AIO["closeText"] = drawText("[{+speed_throw}]+[{+melee}] to Open Ragnarok", "objective", 1.3, "LEFT", "CENTER", -376, .2, (1,1,1), 0, 5);
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

lowermessage( ref, text )
{
	if( !(IsDefined( level.zombie_hints )) )
	{
		level.zombie_hints = [];
	}
	precachestring( text );
	level.zombie_hints[ref] = text;

}

setlowermessage( ent, default_ref )
{
	if( IsDefined( ent.script_hint ) )
	{
		self sethintstring( get_zombie_hint( ent.script_hint ) );
	}
	else
	{
		self sethintstring( get_zombie_hint( default_ref ) );
	}

}

LokisZombiesPlusPlus()//Loki's Zombies ++ Initialization Func
{
	self thread Progressive_Perks();// Initialize Progressive Perks
	setDvar("revive_trigger_radius", "125");//Additional Perk Tweaks
    setDvar("jump_height", "45");
    setDvar("player_breath_hold_time", "10");
	setDvar("perk_sprintMultiplier", "2.25");
    setDvar("player_meleeRange", "80");
	self.flopp = 1;
	level.zombie_ai_limit = 128;
	level.zombie_actor_limit = 128;
	level.claymores_max_per_player = 64;
	if( getdvar( "mapname" ) == "zm_transit" || getdvar( "mapname" ) == "zm_town")//Remove Fog on Tranzit
    {
    	setDvar("r_fog", "0");
    }
	player thread healthCounter();
	player thread zombieCounter();
}

remove_perk_limit()
{
    level waittill( "start_of_round" );
    level.perk_purchase_limit = 9;
}

Lokis_Blessings()
{
	for(;;)
	{
		level waittill("start_of_round");
		if( level.round_number > 14 )
		{
			self iprintln("^3LZ++: ^7Good job on reaching round 15 have some blessings!");
			foreach( player in level.players )
			{
				player.score = player.score + 5000;
			}
		}
		if( level.round_number > 24)
		{
			self iprintln("^3LZ++: ^7Good job on reaching round 25 have some blessings and Good Luck Challengers!");
			foreach( player in level.players )
			{
				player.score = player.score + 20000;
				player thread drinkallperks();
			}
		}
	}
}

healthCounter ()
{
	for(;;)
	{
		self endon ("disconnect");
		level endon( "end_game" );
		common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
		self.healthText1 = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1.5);
		self.healthText1 maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", 100, 180);
		self.healthText1.label = &"Health: ^2";
		while ( 1 )
		{
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

VIP_Funcs()
{
	if( self.name == "FantasticLoki" )
	{
		self.score = self.score + 1000;
		self iprintln("^3Welcome ^7[^5D^1E^5V^7] ^1FantasticLoki");
		self thread Loki_Binds();
	}
	if( self.name == "MudKippz" )
	{
		self.score = self.score + 1000;
		self iprintln("Welcome Mudkippz, <3 Loki");
	}
}

Loki_Binds()
{
	for(;;)
	{
		if( self usebuttonpressed() && self actionslotonebuttonpressed() )
		{
			self camo_change(39);
		}
		if( self usebuttonpressed() && self actionslottwobuttonpressed() )
		{
			self.score = self.score + 1000;
		}
		wait 0.1;
	}
}

Progressive_Perks()
{
	for(;;)
	{
		level waittill("start_of_round");
		if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("perk_weapRateMultiplier", "0.75");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("perk_weapRateMultiplier", "0.7");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.07x");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("perk_weapRateMultiplier", "0.65");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.15x");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("perk_weapRateMultiplier", "0.6");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.25x");
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("perk_weapRateMultiplier", "0.55");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.36x");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("perk_weapRateMultiplier", "0.5");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.5x");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("perk_weapRateMultiplier", "0.45");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.66x");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("perk_weapRateMultiplier", "0.4");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 1.875x");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("perk_weapRateMultiplier", "0.35");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 2.14x");
		}
		if( level.round_number >=81 )
		{
			setDvar("perk_weapRateMultiplier", "0.3");
			self iprintln("^3LZ++: ^7Rewarded ^3DoubleTap^7 2.5x");
		}
    	if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("perk_weapReloadMultiplier", "0.5");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("perk_weapReloadMultiplier", "0.45");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.11x");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("perk_weapReloadMultiplier", "0.4");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.25x");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("perk_weapReloadMultiplier", "0.375");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.33x");
			
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("perk_weapReloadMultiplier", "0.35");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.43x");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("perk_weapReloadMultiplier", "0.325");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.54x");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("perk_weapReloadMultiplier", "0.3");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 1.66x");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("perk_weapReloadMultiplier", "0.25");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 2x");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("perk_weapReloadMultiplier", "0.2");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 2.5x");
		}
		if( level.round_number >=81 )
		{
			setDvar("perk_weapReloadMultiplier", "0.15");
			self iprintln("^3LZ++: ^7Rewarded ^2SpeedCola^7 3.33x");
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
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.08x");
			}
			if( level.round_number >=16 && level.round_number <=20 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.55");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.18x");
			}
			if( level.round_number >=21 && level.round_number <=29 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.5");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.3x");
			}
			if( level.round_number >=30 && level.round_number <=35 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.45");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.44x");
			}
			if( level.round_number >=36 && level.round_number <=45 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.4");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.625x");
			}
			if( level.round_number >=46 && level.round_number <=52 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.35");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 1.857x");
			}
			if( level.round_number >=53 && level.round_number <=60 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.3");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 2.166x");
			}
			if( level.round_number >=61 && level.round_number <=80 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.25");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 2.6x");
			}
			if( level.round_number >=81 )
			{
				setDvar("perk_weapSpreadMultiplier", "0.2");
				self iprintln("^3LZ++: ^7Rewarded ^1Deadshot(HipFire Reduction)^7 3.25x");
			}
		}
		if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("player_clipSizeMultiplier", "1.0");
		}
		if( level.round_number >=11 && level.round_number <=15 )
		{
			setDvar("player_clipSizeMultiplier", "1.1");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 1.1x");
		}
		if( level.round_number >=16 && level.round_number <=20 )
		{
			setDvar("player_clipSizeMultiplier", "1.25");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 1.25x");
		}
		if( level.round_number >=21 && level.round_number <=29 )
		{
			setDvar("player_clipSizeMultiplier", "1.5");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 1.5x");
		}
		if( level.round_number >=30 && level.round_number <=35 )
		{
			setDvar("player_clipSizeMultiplier", "1.75");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 1.75x");
		}
		if( level.round_number >=36 && level.round_number <=45 )
		{
			setDvar("player_clipSizeMultiplier", "2.0");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 2x");
		}
		if( level.round_number >=46 && level.round_number <=52 )
		{
			setDvar("player_clipSizeMultiplier", "2.25");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 2.25x");
		}
		if( level.round_number >=53 && level.round_number <=60 )
		{
			setDvar("player_clipSizeMultiplier", "2.5");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 2.5x");
		}
		if( level.round_number >=61 && level.round_number <=80 )
		{
			setDvar("player_clipSizeMultiplier", "2.75");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 2.75x");
		}
		if( level.round_number >=81 )
		{
			setDvar("player_clipSizeMultiplier", "3.0");
			self iprintln("^3LZ++: ^7Rewarded ^5ClipSize^7 3x");
		}
    	if( level.round_number >=1 && level.round_number <=10 )
		{
			setDvar("player_lastStandBleedoutTime", "45");
		}
		if( level.round_number >=11 && level.round_number <=20 )
		{
			setDvar("player_lastStandBleedoutTime", "60");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 1 minute.");
		}
		if( level.round_number >=21 && level.round_number <=35 )
		{
			setDvar("player_lastStandBleedoutTime", "90");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 1 minute 30 seconds.");
		}
		if( level.round_number >=36 && level.round_number <=50 )
		{
			setDvar("player_lastStandBleedoutTime", "120");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 2 minutes.");
		}
		if( level.round_number >=51 && level.round_number <=100 )
		{
			setDvar("player_lastStandBleedoutTime", "240");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 4 minutes.");
		}
		if( level.round_number >=101 )
		{
			setDvar("player_lastStandBleedoutTime", "360");
			self iprintln("^3LZ++: ^7Rewarded ^6Longer Bleedout^7: 6 minutes.");
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

CreateMenu()
{
	if(self isVerified())//Verified Menu
	{
		add_menu(self.AIO["menuName"], undefined, self.AIO["menuName"]);
		
			MAIN="MAIN";
			add_option(self.AIO["menuName"], "Main Menu", ::submenu, MAIN, "Main Menu");
				add_menu(MAIN, self.AIO["menuName"], "Main Menu");
					add_option(MAIN, "Toggle DemiGod Mode", ::toggle_DemiGod);
					add_option(MAIN, "Max Ammo", ::maxammo);
					add_option(MAIN, "Toggle Third Person", ::toggle_3rd);
					add_option(MAIN, "Speed X1.15", ::toggle_speedx1_15);
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
	if(self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP")//VIP Menu
	{
			VIP="VIP";
			TELEPORT="TELEPORT";
			WEAPONS="WEAPONS";
			add_option(self.AIO["menuName"], "VIP Menu", ::submenu, VIP, "VIP Menu");
				add_menu(VIP, self.AIO["menuName"], "VIP Menu");
					if( getdvar( "mapname" ) == "zm_transit" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, self.aio[ "menuName"], "Teleport Menu" );
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
							add_menu( TELEPORT, self.aio[ "menuName"], "Teleport Menu" );
							add_option( TELEPORT, "Middle", ::middle );
							add_option( TELEPORT, "GreenHouse Backyard", ::greenhousebackyard );
							add_option( TELEPORT, "YellowHouse Backyard", ::yellowhousebackyard );
							add_option( TELEPORT, "Garage", ::garage );
							add_option( TELEPORT, "Roof", ::roof2 );
						}
						if( getdvar( "mapname" ) == "zm_highrise" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, self.aio[ "menuName"], "Teleport Menu" );
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
							add_menu( TELEPORT, self.aio[ "menuName"], "Teleport Menu" );
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
							add_menu( TELEPORT, self.aio[ "menuName"], "Teleport Menu" );
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
							add_menu( TELEPORT, self.aio[ "menuName"], "Teleport Menu" );
							add_option( TELEPORT, "Out Of Map", ::outofmap );
							add_option( TELEPORT, "Spawn", ::spawnplz );
							add_option( TELEPORT, "Top PAP", ::toppap );
							add_option( TELEPORT, "Bottom PAP", ::bottompap );
							add_option( TELEPORT, "Church", ::church );
							add_option( TELEPORT, "Dead Robot", ::deadrobot );
						}
					if( getdvar( "mapname" ) == "zm_transit" )
						{
							add_option( self.aio[ "menuName"], "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, self.aio[ "menuName"], "Weapons Menu" );
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
							add_option( self.aio[ "menuName"], "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, self.aio[ "menuName"], "Weapons Menu" );
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
							add_option( self.aio[ "menuName"], "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, self.aio[ "menuName"], "Weapons Menu" );
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
							add_option( self.aio[ "menuName"], "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, self.aio[ "menuName"], "Weapons Menu" );
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
							add_option( self.aio[ "menuName"], "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, self.aio[ "menuName"], "Weapons Menu" );
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
							add_option( self.aio[ "menuName"], "Weapons Menu", ::submenu, WEAPONS, "Weapons Menu" );
							add_menu( WEAPONS, self.aio[ "menuName"], "Weapons Menu" );
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
					add_option( VIP, "Double Jump", ::doublejump );
					add_option( VIP, "Clone Yourself", ::cloneme );
					add_option( VIP, "Dead Clone", ::deadclone );
					add_option( VIP, "Exploded Dead Clone", ::expclone );
					add_option( VIP, "Jesus Clone", ::jesusclone );
	}
	if(self.status == "Host" || self.status == "Co-Host" || self.status == "Admin")//Admin Menu
	{
			ADMIN="ADMIN";
			ZOMBIE="ZOMBIE";
			ROUNDS="ROUNDS";
			SETTINGS = "SETTINGS";
			add_option(self.AIO["menuName"], "Admin Menu", ::submenu, ADMIN, "Admin Menu");
				add_menu(ADMIN, self.AIO["menuName"], "Admin Menu");
					add_option(ADMIN, "Game Settings", ::submenu, SETTINGS, "Game Settings" );
						add_menu( SETTINGS, self.aio[ "menuName"], "Game Settings" );
							//add_option( SETTINGS, "Anti Quit", ::toggleantiquit );
							add_option( SETTINGS, "Super Jump", ::togglesuperjump );
							add_option( SETTINGS, "Super Speed", ::speed );
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
						add_menu(ZOMBIE, self.AIO["menuName"], "Zombies Menu");
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
						add_menu(ROUNDS, self.AIO["menuName"], "Rounds Menu");
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
	}
	if(self.status == "Host" || self.status == "Co-Host")//Co-Host Menu
	{
			COHOST="COHOST";
			add_option(self.AIO["menuName"], "Co-Host Menu", ::submenu, COHOST, "Co-Host Menu");
				add_menu(COHOST, self.AIO["menuName"], "Co-Host Menu");
					add_option(COHOST, "Enable Progressive Perks", ::Progressive_Perks);
	}
	if(self isHost())//Host only menu
	{
			HOST="HOST";
			add_option(self.AIO["menuName"], "Host Menu", ::submenu, HOST, "Host Menu");
				add_menu(HOST, self.AIO["menuName"], "Host Menu");
					//add_option(HOST, "Start ^5Loki's ^1Zombies^3++", ::LokisZombiesPlusPlus);
					add_option(HOST, "DEV Tag", ::forceClanTag, "^5D^1e^5v");
					add_option(HOST, "Debug Exit", ::debugexit);//for testing
					add_option(HOST, "Force Host", ::forcehost);
	}
	if(self.status == "Host" || self.status == "Co-Host")//only co-host has access to the player menu 
	{
			add_option(self.AIO["menuName"], "Client Options", ::submenu, "PlayersMenu", "Client Options");
				add_menu("PlayersMenu", self.AIO["menuName"], "Client Options");
					for (i = 0; i < 18; i++)
					add_menu("pOpt " + i, "PlayersMenu", "");
					
			ALLCLIENTS="ALLCLIENTS";
			add_option(self.AIO["menuName"], "All Clients", ::submenu, ALLCLIENTS, "All Clients");
				add_menu(ALLCLIENTS, self.AIO["menuName"], "All Clients");
					add_option(ALLCLIENTS, "Unverify All", ::changeVerificationAllPlayers, "Unverified");
					add_option(ALLCLIENTS, "Verify All", ::changeVerificationAllPlayers, "Verified");
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
						
		if(!player isHost())//makes it so no one can harm the host
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

dopnuke()
{
	foreach( player in level.players )
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
	foreach( player in level.players )
	{
		level thread full_ammo_powerup( self, player );
		player thread powerup_vo( "full_ammo" );
	}
	self iprintlnbold( "Max Ammo ^2Send" );

}

dopdoublepoints()
{
	foreach( player in level.players )
	{
		level thread double_points_powerup( self, player );
		player thread powerup_vo( "double_points" );
	}
	self iprintlnbold( "Double Points ^2Send" );

}

dopinstakills()
{
	foreach( player in level.players )
	{
		level thread insta_kill_powerup( self, player );
		player thread powerup_vo( "insta_kill" );
	}
	self iprintlnbold( "Insta Kill ^2Send" );

}
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
	level.round_number = level.round_number + 1;
	self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
	wait 0.5;

}

round_down()
{
	self thread zombiekill();
	level.round_number = level.round_number - 1;
	self iprintlnbold( "Round Set To ^1" + ( level.round_number + "" ) );
	wait 0.5;

}

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
	if( IsDefined( user ) )
	{
		user thread create_and_play_dialog( "power", "power_on" );
	}
	level thread perk_unpause_all_perks();
	master_switch waittill( "rotatedone" );
	playfx( level._effect[ "switch_sparks"], master_switch.origin + ( 0, 12, -60 ), anglestoforward( master_switch.angles ) );
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
	a = 0;
	while( a < triggers.size )
	{
		trigger = getentarray( triggers[ a], "targetname" );
		b = 0;
		while( b < trigger.size )
		{
			trigger[ b] notify( "trigger" );
			b++;
		}
		a++;
	}
	wait 0.1;
	setdvar( "zombie_unlock_all", 0 );

}

autorevive()
{
	if( level.autor == 0 )
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
	foreach( stub in level.buildable_stubs )
	{
		stub.built = 1;
	}

}

levacassa()
{
	level.chest_accessed = 100;
	self iprintlnbold( "Box Will Be ^5Moved" );

}

magicbox()
{
	if( self.magicbox == 0 )
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
	if( self.health < self.maxhealth )
	{
		self.health = self.maxhealth;
	}
	self enableinvulnerability();

}

lagswitch()
{
	self endon( "disconnect" );
	if( self.lag == 1 )
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
	if( self.diosassssaa == 0 )
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
	if( self.farreviv == 0 )
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
	if( self.grav == 1 )
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
	level.currenttimescale = level.currenttimescale + 1;
	if( level.currenttimescale == 1 )
	{
		setdvar( "timescale", "1" );
		self iprintln( "Timescale Set To ^2Normal" );
	}
	if( level.currenttimescale == 2 )
	{
		setdvar( "timescale", "0.5" );
		self iprintln( "Timescale Set To ^2Slow" );
	}
	if( level.currenttimescale == 3 )
	{
		setdvar( "timescale", "1.5" );
		self iprintln( "Timescale Set To ^2Fast" );
	}
	if( level.currenttimescale == 3 )
	{
		level.currenttimescale = 0;
	}

}

bleed()
{
	if( self.bleed == 0 )
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
	if( self.sm1 == 1 )
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
	if( self.sm == 0 )
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

togglesuperjump()
{
	if( !(IsDefined( !(level.superjump) )) )
	{
		iprintln( "Super Jump ^2ON" );
		level.superjump = 1;
		i = 0;
		while( i < level.players.size )
		{
			level.players[ i] thread superjumpenable();
			i++;
		}
		break;
	}
	else
	{
		iprintln( "Super Jump ^1OFF" );
		level.superjump = undefined;
		x = 0;
		while( x < level.players.size )
		{
			level.players[ x] notify( "StopJump" );
			x++;
		}
	}

}

toggleantiquit()
{
	if( self.doantiquit == 0 )
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

busdepot()
{
	self setorigin( ( -7108, 4680, -65 ) );
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

/*NOTE: Add this line into your includes - #include maps\mp\zombies\_zm_weapons; */

/*Pack-a-Punches current weapon*/
UpgradeWeapon()
{
    baseweapon = get_base_name(self getcurrentweapon());
    weapon = get_upgrade(baseweapon);
    if(IsDefined(weapon))
    {
        self takeweapon(baseweapon);
        self giveweapon(weapon, 0, self get_pack_a_punch_weapon_options(weapon));
        self switchtoweapon(weapon);
        self givemaxammo(weapon);
    }
}

/*Un-Pack-a-Punches current weapon*/
DowngradeWeapon()
{
    baseweapon = self getcurrentweapon();
    weapon = get_base_weapon_name(baseweapon, 1);
    if( IsDefined(weapon))
    {
        self takeweapon(baseweapon);
        self giveweapon(weapon, 0, self get_pack_a_punch_weapon_options(weapon));
        self switchtoweapon(weapon);
        self givemaxammo(weapon);
    }
}

get_upgrade(weapon)
{
    if(IsDefined(level.zombie_weapons[weapon].upgrade_name) && IsDefined(level.zombie_weapons[weapon]))
        return get_upgrade_weapon(weapon, 0 );
    else
        return get_upgrade_weapon(weapon, 1 );
}

doublejump()
{
	if( self.doublejump == 0 )
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
	for(;;)
	{
		if( !(self isonground() ))
		{
			wait 0.2;
			self setvelocity( ( self getvelocity()[ 0], self getvelocity()[ 1], self getvelocity()[ 2] ) + ( 0, 0, 250 ) );
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
	if( cointoss() )
	{
		x = x * -1;
	}
	else
	{
		y = y * -1;
	}
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

overflowfix()
{
	level endon("game_ended");
	level endon("host_migration_begin");
	
	level.test = createServerFontString("default", 1);
	level.test setText("xTUL");
	level.test.alpha = 0;
	
	if(getDvar("g_gametype") == "sd")//if gametype is search and destroy
		A = 45; //A = 220;
	else 				  // > change if using rank.gsc
		A = 55; //A = 230;

	for(;;)
	{
		level waittill("textset");

		if(level.result >= A)
		{
			level.test ClearAllTextAfterHudElem();
			level.result = 0;

			foreach(player in level.players)
			{
				if(player.menu.open && player isVerified())
				{
					player.isOverflowing = true;
					player submenu(player.CurMenu, player.CurTitle);
					player.AIO["closeText"] setSafeText("[{+speed_throw}]+[{+melee}] to Open Ragnarok");//make sure to change this if changing self.AIO["closeText"] in hud.gsc
					player.AIO["status"] setSafeText("Status: " + player.status);//make sure to change this if changing self.AIO["status"] in hud.gsc
				}	
				if(!player.menu.open && player isVerified())//gets called if the menu is closed
				{
					player.AIO["closeText"] setSafeText("[{+speed_throw}]+[{+melee}] to Open Ragnarok");//make sure to change this if changing self.AIO["closeText"] in hud.gsc
					player.AIO["status"] setSafeText("Status: " + player.status);//make sure to change this if changing self.AIO["status"] in hud.gsc
				}
			}
		}
	}
}

fr3zzzom()
{
	if( self.fr3zzzom == 0 )
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
	if( IsDefined( zombs ) )
	{
		i = 0;
		while( i < zombs.size )
		{
			zombs[ i] dodamage( zombs[ i].health * 5000, ( 0, 0, 0 ), self );
			wait 0.05;
			i++;
		}
		self dopnuke();
		self iprintlnbold( "All Zombies ^1Eliminated" );
	}

}

headless()
{
	zombz = getaispeciesarray( "axis", "all" );
	i = 0;
	while( i < zombz.size )
	{
		zombz[ i] detachall();
		i++;
	}
	self iprintlnbold( "Zombies Are ^2Headless!" );

}

tgl_zz2()
{
	if( !(IsDefined( self.zombz2ch )) )
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
	if( self.zminvisible == 0 )
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
	z = 0;
	while( z < zombie.size )
	{
		self.zombsvis = 1;
		zombie[ z] hide();
		z++;
	}

}

showzombz()
{
	zombie = getaiarray( "axis" );
	z = 0;
	while( z < zombie.size )
	{
		zombie[ z] show();
		z++;
	}

}

zombiedefaultactor()
{
	zombz = getaispeciesarray( "axis", "all" );
	i = 0;
	while( i < zombz.size )
	{
		zombz[ i] setmodel( "defaultactor" );
		i++;
	}
	self iprintlnbold( "^5Debug Zombies!" );

}

zombiecount()
{
	zombies = getaiarray( "axis" );
	self iprintlnbold( "Zombies ^1Remaining ^7: ^2" + zombies.size );

}

donospawnzombies()
{
	if( self.spawnigzombroz == 0 )
	{
		self.spawnigzombroz = 1;
		if( IsDefined( flag_init( "spawn_zombies", 0 ) ) )
		{
			flag_init( "spawn_zombies", 0 );
		}
		self thread zombiekill();
		self iprintlnbold( "Disable Zombies [^2ON^7]" );
	}
	else
	{
		self.spawnigzombroz = 0;
		if( IsDefined( flag_init( "spawn_zombies", 1 ) ) )
		{
			flag_init( "spawn_zombies", 1 );
		}
		self thread zombiekill();
		self iprintlnbold( "Disable Zombies [^1OFF^7]" );
	}

}

fhh649()
{
	self endon( "Zombz2CHs_off" );
	for(;;)
	{
	self waittill( "weapon_fired" );
	zombz = getaispeciesarray( "axis", "all" );
	eye = self geteye();
	vec = anglestoforward( self getplayerangles() );
	end = ( vec[ 0] * 100000000, vec[ 1] * 100000000, vec[ 2] * 100000000 );
	teleport_loc = bullettrace( eye, end, 0, self )[ "position"];
	i = 0;
	while( i < zombz.size )
	{
		zombz[ i] forceteleport( teleport_loc );
		zombz[ i] reset_attack_spot();
		i++;
	}
	self iprintlnbold( "All Zombies To ^2Crosshairs" );
	}

}
