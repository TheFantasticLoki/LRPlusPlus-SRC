
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

new_full_ammo_powerup( drop_item, player )
{
    players = get_players( player.team );

    if ( isdefined( level._get_game_module_players ) ){
        players = [[ level._get_game_module_players ]]( player );
    }

    for ( i = 0; i < players.size; i++ )
    {
        if ( players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
            continue;

        primary_weapons = players[i] getweaponslist( 1 );
        players[i] notify( "zmb_max_ammo" );
        players[i] notify( "zmb_lost_knife" );
        players[i] notify( "zmb_disable_claymore_prompt" );
        players[i] notify( "zmb_disable_spikemore_prompt" );

        for ( x = 0; x < primary_weapons.size; x++ )
        {
        	curWeapon = primary_weapons[x];
            if ( level.headshots_only && is_lethal_grenade(curWeapon) ){
                continue;
            }

            if ( isDefined( level.zombie_include_equipment ) && isDefined( level.zombie_include_equipment[curWeapon] ) ){
                continue;
            }

            if ( isDefined( level.zombie_weapons_no_max_ammo ) && isDefined( level.zombie_weapons_no_max_ammo[curWeapon] ) ){
                continue;
            }

            if ( players[i] hasweapon( curWeapon ) ){
                players[i] givemaxammo( curWeapon );
                players[i] setweaponammoclip( curWeapon, 300);
            }

        }
    }

    level thread full_ammo_on_hud( drop_item, player.team );
}