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
					if( level.player_out_of_playable_area_monitor == 0 )
					{
						if( getdvar( "mapname" ) == "zm_transit" )
						{
							add_option( VIP, "Teleport Menu", ::submenu, TELEPORT, "Teleport Menu" );
							add_menu( TELEPORT, VIP, "Teleport Menu" );
							add_option( TELEPORT, "PaP", ::tp_transit_pap );
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
