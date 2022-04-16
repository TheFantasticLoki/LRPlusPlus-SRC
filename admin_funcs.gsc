
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

DTRate(i)
{
	setDvar("perk_weapRateMultiplier", i);
}

DTRateToggle()
{
	if( self.DTRateT == 0 )
	{
		setDvar("perk_weapRateMultiplier", "0.70" );
		self iprintlnbold( "Double Tap Rate: [^20.70^7] ^1Lower Is Better" );
		self.DTRateT = 1;
	}
	else
	{
		if( self.DTRateT == 1 )
		{
			setDvar("perk_weapRateMultiplier", "0.65" );
			self iprintlnbold( "Double Tap Rate: [^20.65^7] ^1Lower Is Better" );
			self.DTRateT = 2;
		}
		else
		{
			if( self.DTRateT == 2 )
			{
				setDvar("perk_weapRateMultiplier", "0.60" );
				self iprintlnbold( "Double Tap Rate: [^20.60^7] ^1Lower Is Better" );
				self.DTRateT = 3;
			}
			else
			{
				if( self.DTRateT == 3 )
				{
					setDvar("perk_weapRateMultiplier", "0.55" );
					self iprintlnbold( "Double Tap Rate: [^20.55^7]" );
					self.DTRateT = 4;
				}
				else
				{
					if( self.DTRateT == 4 )
					{
						setDvar("perk_weapRateMultiplier", "0.50" );
						self iprintlnbold( "Double Tap Rate: [^20.50^7]" );
						self.DTRateT = 5;
					}
					else
					{
						if( self.DTRateT == 5 )
						{
							setDvar("perk_weapRateMultiplier", "0.45" );
							self iprintlnbold( "Double Tap Rate: [^20.45^7]" );
							self.DTRateT = 6;
						}
						else
						{
							if( self.DTRateT == 6 )
							{
								setDvar("perk_weapRateMultiplier", "0.75" );
								self iprintlnbold( "Double Tap Rate ^1reset ^7to: [^1Default: 0.75^7]" );
								self.DTRateT = 0;
							}
						}
					}
				}
			}
		}
	}

}
