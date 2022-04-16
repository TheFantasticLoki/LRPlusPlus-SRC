kickplayer( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "^1Fuck You Men !" );
		kick( self getentitynumber() );
	}
	else
	{
		self iprintlnbold( "^1 " + ( player.name + " ^7Has Been ^1Kicked ^7!" ) );
		kick( player getentitynumber() );
	}

}

doreviveplayer( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't revive the host!" );
	}
	else
	{
		self iprintlnbold( "^1 " + ( player.name + " ^7Revive ^1!" ) );
		player notify( "player_revived" );
		player reviveplayer();
		player.revivetrigger delete();
		player.revivetrigger = undefined;
		player.ignoreme = 0;
		player allowjump( 1 );
		player.laststand = undefined;
	}

}

dokillnoobplayer( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "^1You Can't Kill The Host You Skid" );
	}
	else
	{
		self iprintlnbold( "^1 " + ( player.name + " ^7Has Been ^1Rekt!" ) );
		player.maxhealth = 100;
		player.health = self.maxhealth;
		player disableinvulnerability();
		player dodamage( self.health * 2, self.origin );
	}

}

accecastronzo( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't Blind the Host" );
	}
	else
	{
		if( self.accecastr == 0 )
		{
			self.accecastr = 1;
			self iprintlnbold( "^2" + ( player.name + " ^7Blinded" ) );
			player setblur( 50.3, 1 );
		}
		else
		{
			self.accecastr = 0;
			self iprintlnbold( "^2" + ( player.name + " ^7Can See Again" ) );
			player setblur( 0, 1 );
		}
	}

}

doteleporttome( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't teleport the Host!" );
	}
	else
	{
		player setorigin( self.origin );
		player iprintlnbold( "Teleported to ^1" + player.name );
	}
	self iprintlnbold( "^5" + ( player.name + " ^7Teleported to Me" ) );

}

doteleporttohim( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't teleport to the host!" );
	}
	else
	{
		self setorigin( player.origin );
		self iprintlnbold( "Teleported to ^1" + player.name );
	}
	self iprintlnbold( "^5" + ( player.name + " ^7Teleported to Me" ) );

}

playerfrezecontrol( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't freez the host!" );
	}
	else
	{
		if( self.fronzy == 0 )
		{
			self.fronzy = 1;
			self iprintlnbold( "^2Frozen: ^7" + player.name );
			player freezecontrols( 1 );
		}
		else
		{
			self.fronzy = 0;
			self iprintlnbold( "^1Unfrozen: ^7" + player.name );
			player freezecontrols( 0 );
		}
	}

}

chicitakeweaponplayer( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't take weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Taken Weapons: ^1" + player.name );
		player takeallweapons();
	}

}

dogiveplayerweapon( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given RayGun: ^1" + player.name );
		player weapon_give( "ray_gun_upgraded_zm" );
		player switchtoweapon( "ray_gun_upgraded_zm" );
		player givemaxammo( "ray_gun_upgraded_zm" );
	}

}

dogiveplayerweapon2( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given RayGun x2: ^1" + player.name );
		player weapon_give( "raygun_mark2_upgraded_zm" );
		player switchtoweapon( "raygun_mark2_upgraded_zm" );
		player givemaxammo( "raygun_mark2_upgraded_zm" );
	}

}

dogiveplayerweapon3( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given JetGun: ^1" + player.name );
		player thread dammijetgun();
	}

}

dogiveplayerweaponbruh( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given Default Weapon: ^1" + player.name );
		player thread debruh();
	}

}

dogiveplayerweapon4( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given Sliquifier: ^1" + player.name );
		player thread sliquifiersweg();
	}

}

dogiveplayerweapon5( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given Blundergat: ^1" + player.name );
		player thread blundergatsweg();
	}

}

dogiveplayerweapon6( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given Paralyzer: ^1" + player.name );
		player thread unlimitedjet();
	}

}

dogiveplayerweapon7( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given Staff of Lightning: ^1" + player.name );
		player thread staff1();
	}

}

dogiveplayerweapon8( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given Staff of Fire: ^1" + player.name );
		player thread staff2();
	}

}

playerunlimitedammo( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give the host Unlimited Ammo!" );
	}
	else
	{
		self iprintlnbold( "Given Unlimited Ammo: ^1" + player.name );
		player thread toggle_ammo();
	}

}

dorankplayer( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give the host Max Rank!" );
	}
	else
	{
		self iprintlnbold( "Given Max Rank: ^1" + player.name );
		player thread shotgunrank();
	}

}

dotrophiesplayer( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give the host Trophies!" );
	}
	else
	{
		self iprintlnbold( "Given Trophies: ^1" + player.name );
		player thread unlockallcheevos();
	}

}

dogiveplayerweapon9( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given Staff of Ice: ^1" + player.name );
		player thread staff3();
	}

}

dogiveplayerweapon10( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give weapon the host!" );
	}
	else
	{
		self iprintlnbold( "Given Staff of Wind: ^1" + player.name );
		player thread staff4();
	}

}

dokillnoobplayer( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "^1You Can't Kill The Host You Skid" );
	}
	else
	{
		self iprintlnbold( "^1 " + ( player.name + " ^7Has Been ^1Rekt!" ) );
		player.maxhealth = 100;
		player.health = self.maxhealth;
		player disableinvulnerability();
		player dodamage( self.health * 2, self.origin );
	}

}

sendtospace( player )
{
	if( !(player ishost()) )
	{
		self iprintlnbold( player.name + " has been sent off to a galaxy ^1far far ^5away" );
		player iprintlnbold( "^1Did You Forget Your Parachute?" );
		x = randomintrange( -75, 75 );
		y = randomintrange( -75, 75 );
		z = 45;
		player.location = ( 0 + x, 0 + y, 500000 + z );
		player.angle = ( 0, 176, 0 );
		player setorigin( player.location );
		player setplayerangles( player.angle );
	}
	else
	{
		self iprintln( "host is protected" );
	}

}

playergivegodmod( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't give godmod the host!" );
	}
	else
	{
		if( self.godmodplater == 0 )
		{
			self.godmodplater = 1;
			self iprintlnbold( "^1" + ( player.name + " ^7GodMod [^2ON^7]" ) );
			player toggle_god();
		}
		else
		{
			self.godmodplater = 0;
			self iprintlnbold( "^1" + ( player.name + " ^7GodMod [^1OFF^7]" ) );
			player toggle_god();
		}
	}

}

dopointsplayer( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You can't Give Points To The Host!" );
	}
	else
	{
		self iprintlnbold( "^1 " + ( player.name + " ^7MaxPoints ^1!" ) );
		player.score = player.score + 21473140;
	}

}

allperks( player )
{
	if( player ishost() || player.status == "Developer" )
	{
		self iprintlnbold( "You Can't Give The Host Perks Retard!" );
	}
	else
	{
		self iprintlnbold( "^5Given All Perks To " + player.name );
		player thread drinkallperks();
	}

}