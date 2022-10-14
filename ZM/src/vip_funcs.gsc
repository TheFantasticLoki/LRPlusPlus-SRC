toggle_bullets()
{
    if ( self.bullets == 0 )
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

teleportgun()
{
    if ( self.tpg == 0 )
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

toggle_bullets()
{
    if ( self.bullets == 0 )
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

arrowpbullets()
{
    if ( self.bulletsa == 0 )
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

fth()
{
    if ( self.fths == 0 )
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

doublejump()
{
    if ( self.doublejump == 0 )
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

    for (;;)
    {
        if ( !self isonground() )
        {
            wait 0.2;
            self setvelocity( ( self getvelocity()[0], self getvelocity()[1], self getvelocity()[2] ) + ( 0.0, 0.0, 250.0 ) );
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

    if ( cointoss() )
        x *= -1;
    else
        y *= -1;

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
    if ( !player ishost() || player.status == "Developer" )
    {
        if ( player.isspinning == 0 )
        {
            player thread spinme();
            player iprintlnbold( "Spinning ^2ON" );
            self iprintlnbold( player.name + " Spinning ^2ON" );
            player.isspinning = 1;
        }
        else if ( player.isspinning == 1 )
        {
            player notify( "Stop_Spining" );
            player iprintlnbold( "Spinning ^1OFF" );
            self iprintlnbold( player.name + " Spinning ^1OFF" );
            player.isspinning = 0;
        }
    }
}

spinme()
{
    self endon( "disconnect" );
    self endon( "Stop_Spining" );

    for (;;)
    {
        self setplayerangles( self.angles + ( 0.0, 20.0, 0.0 ) );
        wait 0.01;
        self setplayerangles( self.angles + ( 0.0, 20.0, 0.0 ) );
        wait 0.01;
    }

    wait 0.05;
}

bulletmod()
{
    self endon( "stop_bullets" );

    for (;;)
    {
        self waittill( "weapon_fired" );

        earthquake( 0.5, 1, self.origin, 90 );
        forward = self gettagorigin( "j_head" );
        end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
        splosionlocation = bullettrace( forward, end, 0, self )["position"];
        radiusdamage( splosionlocation, 500, 1000, 500, self );
        playsoundatposition( "evt_nuke_flash", splosionlocation );
        play_sound_at_pos( "evt_nuke_flash", splosionlocation );
        earthquake( 2.5, 2, splosionlocation, 300 );
        playfx( loadfx( "explosions/fx_default_explosion" ), splosionlocation );
    }
}

teleportrun()
{
    self endon( "death" );
    self endon( "Stop_TP" );

    for (;;)
    {
        self waittill( "weapon_fired" );

        self setorigin( bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )["position"] );
    }
}

careabullets()
{
    self endon( "stop_bullets2" );

    while ( true )
    {
        self waittill( "weapon_fired" );

        forward = self gettagorigin( "j_head" );
        end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
        splosionlocation = bullettrace( forward, end, 0, self )["position"];
        m = spawn( "script_model", splosionlocation );
        m setmodel( "fx_axis_createfx" );
    }
}

doflame()
{
    self endon( "Stop_FlameTrowher" );
    self takeallweapons();
    self giveweapon( "defaultweapon_mp" );
    self switchtoweapon( "defaultweapon_mp" );
    self givemaxammo( "defaultweapon_mp" );

    while ( true )
    {
        self waittill( "weapon_fired" );

        forward = self gettagorigin( "j_head" );
        end = self thread vector_scal( anglestoforward( self getplayerangles() ), 1000000 );
        crosshair = bullettrace( forward, end, 0, self )["position"];
        magicbullet( self getcurrentweapon(), self gettagorigin( "j_shouldertwist_le" ), crosshair, self );
        flamefx = loadfx( "env/fire/fx_fire_zombie_torso" );
        playfx( flamefx, crosshair );
        flamefx2 = loadfx( "env/fire/fx_fire_zombie_md" );
        playfx( flamefx, self gettagorigin( "j_hand" ) );
        radiusdamage( crosshair, 100, 15, 15, self );
    }
}
