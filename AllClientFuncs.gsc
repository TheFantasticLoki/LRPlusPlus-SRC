doallkickplayer()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			kick( player getentitynumber() );
		}
		self iprintlnbold( "All Players ^1Kicked" );
	}

}

dorevivealls()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
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

}

allplayerskilled()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player.maxhealth = 100;
			player.health = self.maxhealth;
			player disableinvulnerability();
			player dodamage( self.health * 2, self.origin );
		}
	}
	self iprintlnbold( "All Players: ^2Killed !" );

}

unlockallthrophiesallplayers()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread unlockallcheevos();
		}
	}

}

allplayergivegodmod()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			if( self.godmodplater == 0 )
			{
				self.godmodplater = 1;
				self iprintlnbold( "All Players ^7GodMod [^2ON^7]" );
				player toggle_god();
			}
			else
			{
				self.godmodplater = 0;
				self iprintlnbold( "All Players ^7GodMod [^1OFF^7]" );
				player toggle_god();
			}
		}
	}

}

toggle_ammo1337()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread toggle_ammo();
		}
	}

}

all1()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread maxscore();
		}
	}

}

allmaxrank()
{
	self iprintlnbold( "^5Given Max Rank!" );
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread shotgunrank();
		}
	}

}

doteleportalltome()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player setorigin( self.origin );
		}
	}
	self iprintlnbold( "^2Teleported All to Me" );

}

teltocross()
{
	self endon( "disconnect" );
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player setorigin( bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )[ "position"] );
		}
		self iprintlnbold( "^2All Players Teleported to Crosshair" );
	}

}

sendalltospace()
{
	self iprintlnbold( "Everyone's been sent to a galaxy ^1far far ^5away" );
	foreach( player in level.players )
	{
		if( !(player ishost()) )
		{
			x = randomintrange( -75, 75 );
			y = randomintrange( -75, 75 );
			z = 45;
			player.location = ( 0 + x, 0 + y, 500000 + z );
			player.angle = ( 0, 176, 0 );
			player setorigin( player.location );
			player setplayerangles( player.angle );
			player iprintlnbold( "^1Did You Forget Your Parachute?" );
		}
	}

}

raygunsweg1()
{
	self takeweapon( self getcurrentweapon() );
	self weapon_give( "ray_gun_upgraded_zm" );
	self switchtoweapon( "ray_gun_upgraded_zm" );
	self givemaxammo( "ray_gun_upgraded_zm" );
	self iprintlnbold( "^2Ray Gun Given!" );

}

debruh()
{
	self takeweapon( self getcurrentweapon() );
	self giveweapon( "defaultweapon_mp" );
	self switchtoweapon( "defaultweapon_mp" );
	self givemaxammo( "defaultweapon_mp" );
	self iprintlnbold( "^2Default Weapon Given!" );

}

raygunsweg2()
{
	self takeweapon( self getcurrentweapon() );
	self weapon_give( "raygun_mark2_upgraded_zm" );
	self switchtoweapon( "raygun_mark2_upgraded_zm" );
	self givemaxammo( "raygun_mark2_upgraded_zm" );
	self iprintlnbold( "^2Ray Gun MK2 Given!" );

}

sliquifiersweg()
{
	self takeweapon( self getcurrentweapon() );
	self giveweapon( "slipgun_upgraded_zm" );
	self switchtoweapon( "slipgun_upgraded_zm" );
	self givemaxammo( "slipgun_upgraded_zm" );
	self iprintlnbold( "^2Sliquifier Given!" );

}

blundergatsweg()
{
	self takeweapon( self getcurrentweapon() );
	self weapon_give( "blundersplat_upgraded_zm" );
	self switchtoweapon( "blundersplat_upgraded_zm" );
	self givemaxammo( "blundersplat_upgraded_zm" );
	self iprintlnbold( "^2Blundergat Given!" );

}

staff1()
{
	self takeweapon( self getcurrentweapon() );
	self giveweapon( "staff_lightning_zm" );
	self switchtoweapon( "staff_lightning_zm" );
	self givemaxammo( "staff_lightning_zm" );
	self iprintlnbold( "^2Staff of Lightning Given!" );

}

staff2()
{
	self takeweapon( self getcurrentweapon() );
	self giveweapon( "staff_fire_zm" );
	self switchtoweapon( "staff_fire_zm" );
	self givemaxammo( "staff_fire_zm" );
	self iprintlnbold( "^2Staff of Fire Given!" );

}

staff3()
{
	self takeweapon( self getcurrentweapon() );
	self giveweapon( "staff_water_zm" );
	self switchtoweapon( "staff_water_zm" );
	self givemaxammo( "staff_water_zm" );
	self iprintlnbold( "^2Staff of Ice Given!" );

}

staff4()
{
	self takeweapon( self getcurrentweapon() );
	self giveweapon( "staff_air_zm" );
	self switchtoweapon( "staff_air_zm" );
	self givemaxammo( "staff_air_zm" );
	self iprintlnbold( "^2Staff of Wind Given!" );

}

staff11()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread staff1();
		}
	}

}

staff22()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread staff2();
		}
	}

}

staff33()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread staff3();
		}
	}

}

staff44()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread staff4();
		}
	}

}

paralyzersweg()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread unlimitedjet();
		}
	}

}

blundergatsweg2()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread blundergatsweg();
		}
	}

}

sliquifiersweg2()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread sliquifiersweg();
		}
	}

}

jetgunsweg()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread dammijetgun();
		}
	}

}

rg1()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread raygunsweg1();
		}
	}

}

debruh1()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread debruh();
		}
	}

}

rg2()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread raygunsweg2();
		}
	}

}

perksall()
{
	foreach( player in level.players )
	{
		if( player ishost() )
		{
		}
		else
		{
			player thread drinkallperks();
			self iprintlnbold( "^5Given All Players Perks!" );
		}
	}

}
