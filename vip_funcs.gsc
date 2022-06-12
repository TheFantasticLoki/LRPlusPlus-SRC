
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

togglespin( player )
{
	if( !(player ishost()) || player.status == "Developer" )
	{
		if( player.isspinning == 0 )
		{
			player thread spinme();
			player iprintlnbold( "Spinning ^2ON" );
			self iprintlnbold( player.name + " Spinning ^2ON" );
			player.isspinning = 1;
		}
		else
		{
			if( player.isspinning == 1 )
			{
				player notify( "Stop_Spining" );
				player iprintlnbold( "Spinning ^1OFF" );
				self iprintlnbold( player.name + " Spinning ^1OFF" );
				player.isspinning = 0;
			}
		}
	}

}

spinme()
{
	self endon( "disconnect" );
	self endon( "Stop_Spining" );
	for(;;)
	{
	self setplayerangles( self.angles + ( 0, 20, 0 ) );
	wait 0.01;
	self setplayerangles( self.angles + ( 0, 20, 0 ) );
	wait 0.01;
	}
	wait 0.05;

}

toggle_bullets()
{
	if( self.bullets == 0 )
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

bulletmod()
{
	self endon( "stop_bullets" );
	for(;;)
	{
	self waittill( "weapon_fired" );
	earthquake( 0.5, 1, self.origin, 90 );
	forward = self gettagorigin( "j_head" );
	end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
	splosionlocation = bullettrace( forward, end, 0, self )[ "position"];
	radiusdamage( splosionlocation, 500, 1000, 500, self );
	playsoundatposition( "evt_nuke_flash", splosionlocation );
	play_sound_at_pos( "evt_nuke_flash", splosionlocation );
	earthquake( 2.5, 2, splosionlocation, 300 );
	playfx( loadfx( "explosions/fx_default_explosion" ), splosionlocation );
	}

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

teleportgun()
{
	if( self.tpg == 0 )
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
	for(;;)
	{
	self waittill( "weapon_fired" );
	self setorigin( bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )[ "position"] );
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

fth()
{
	if( self.fths == 0 )
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
	while( 1 )
	{
		self waittill( "weapon_fired" );
		forward = self gettagorigin( "j_head" );
		end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
		crosshair = bullettrace( forward, end, 0, self )[ "position"];
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
	if( self.bulletsa == 0 )
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
	while( 1 )
	{
		self waittill( "weapon_fired" );
		forward = self gettagorigin( "j_head" );
		end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
		splosionlocation = bullettrace( forward, end, 0, self )[ "position"];
		m = spawn( "script_model", splosionlocation );
		m setmodel( "fx_axis_createfx" );
	}

}