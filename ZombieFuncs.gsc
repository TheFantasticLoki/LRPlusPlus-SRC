
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
