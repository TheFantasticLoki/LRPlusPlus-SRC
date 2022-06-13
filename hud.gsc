// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

storehuds()
{
    self.aio["background"] = createrectangle( "LEFT", "CENTER", -380, 27, 0, 190, ( 0, 0, 0 ), "white", 1, 0 );
    self.aio["backgroundouter"] = createrectangle( "LEFT", "CENTER", -384, 24, 0, 193, ( 0, 0, 0 ), "white", 1, 0 );
    self.aio["scrollbar"] = createrectangle( "CENTER", "CENTER", -300, -50, 160, 0, ( 0.0, 0.45, 1.0 ), "white", 2, 0 );
    self.aio["bartop"] = createrectangle( "CENTER", "CENTER", -300, 0.2, 160, 30, ( 0.0, 0.45, 1.0 ), "white", 3, 0 );
    self.aio["barbottom"] = createrectangle( "CENTER", "CENTER", -300, 0.2, 160, 30, ( 0.0, 0.45, 1.0 ), "white", 3, 0 );
    self.aio["barclose"] = createrectangle( "CENTER", "CENTER", -299, 0.2, 162, 32, ( 0.0, 0.45, 1.0 ), "white", 1, 0 );
    self.aio["title"] = drawtext( "", "objective", 1.7, "LEFT", "CENTER", -376, -80, ( 1, 1, 1 ), 0, 5 );
    self.aio["closeText"] = drawtext( "[{+speed_throw}]+[{+melee}] to Open Ragnarok", "objective", 1.3, "LEFT", "CENTER", -376, 0.2, ( 1, 1, 1 ), 0, 5 );
    self.aio["status"] = drawtext( "Status: " + verificationtocolor( self.status ), "objective", 1.7, "LEFT", "CENTER", -376, 128, ( 1, 1, 1 ), 0, 5 );
    self.aio["barclose"] affectelement( "alpha", 0.2, 0.9 );
    self.aio["bartop"] affectelement( "alpha", 0.2, 0.9 );
    self.aio["barbottom"] affectelement( "alpha", 0.2, 0.9 );
    self.aio["closeText"] affectelement( "alpha", 0.2, 1 );
}

storetext( menu, title )
{
    self.aio["title"] setsafetext( title );

    if ( self.recreateoptions )
    {
        for ( i = 0; i < 7; i++ )
        {
            self.aio["options"][i] = drawtext( "", "objective", 1.3, "LEFT", "CENTER", -376, -50 + i * 25, ( 1, 1, 1 ), 0, 7 );
            self.aio["options"][i].archived = 0;
        }
    }
    else
    {
        for ( i = 0; i < 7; i++ )
            self.aio["options"][i] setsafetext( self.menu.menuopt[menu][i] );
    }
}

showhud()
{
    self endon( "destroyMenu" );
    self.aio["closeText"] affectelement( "alpha", 0.1, 0 );
    self.aio["closeText"].archived = 0;
    self.aio["barclose"] affectelement( "alpha", 0, 0 );
    self.aio["barclose"].archived = 0;
    self.aio["bartop"] affectelement( "y", 0.5, -80 );
    self.aio["bartop"].archived = 0;
    self.aio["barbottom"] affectelement( "y", 0.5, 128 );
    self.aio["barbottom"].archived = 0;
    wait 0.5;
    self.aio["background"] affectelement( "alpha", 0.2, 0.5 );
    self.aio["background"].archived = 0;
    self.aio["backgroundouter"] affectelement( "alpha", 0.2, 0.5 );
    self.aio["backgroundouter"].archived = 0;
    self.aio["background"] scaleovertime( 0.5, 160, 230 );
    self.aio["background"].archived = 0;
    self.aio["backgroundouter"] scaleovertime( 0.3, 168, 244 );
    self.aio["backgroundouter"].archived = 0;
    wait 0.5;
    self.aio["scrollbar"] affectelement( "alpha", 0.2, 0.9 );
    self.aio["scrollbar"] scaleovertime( 0.5, 160, 25 );
    self.aio["scrollbar"].archived = 0;
    self.aio["title"] affectelement( "alpha", 0.2, 1 );
    self.aio["title"].archived = 0;
    self.aio["status"] affectelement( "alpha", 0.2, 1 );
    self.aio["status"].archived = 0;
}

hidehud()
{
    self endon( "destroyMenu" );
    self.aio["title"] affectelement( "alpha", 0.2, 0 );
    self.aio["status"] affectelement( "alpha", 0.2, 0 );

    if ( isdefined( self.aio["options"] ) )
    {
        for ( a = 0; a < self.aio["options"].size; a++ )
        {
            self.aio["options"][a] affectelement( "alpha", 0.2, 0 );
            wait 0.05;
        }

        for ( i = 0; i < self.aio["options"].size; i++ )
            self.aio["options"][i] destroy();
    }

    self.aio["scrollbar"] scaleovertime( 0.5, 2, 0 );
    self.aio["scrollbar"] affectelement( "alpha", 0.2, 0 );
    self.aio["scrollbar1"] scaleovertime( 0.5, 2, 0 );
    self.aio["scrollbar1"] affectelement( "alpha", 0.2, 0 );
    wait 0.4;
    self.aio["backgroundouter"] scaleovertime( 0.5, 1, 193 );
    self.aio["background"] scaleovertime( 0.3, 1, 190 );
    wait 0.4;
    self.aio["backgroundouter"] affectelement( "alpha", 0.2, 0 );
    self.aio["background"] affectelement( "alpha", 0.2, 0 );
    wait 0.2;
    self.aio["barbottom"] affectelement( "y", 0.4, 0.2 );
    self.aio["bartop"] affectelement( "y", 0.4, 0.2 );
    wait 0.4;
    self playsoundtoplayer( "fly_assault_reload_npc_mag_in", self );
    self.aio["barclose"] affectelement( "alpha", 0.1, 0.9 );
    self.aio["closeText"] affectelement( "alpha", 0.1, 1 );
}

updatescrollbar()
{
    if ( self.menu.curs[self.curmenu] < 0 )
        self.menu.curs[self.curmenu] = self.menu.menuopt[self.curmenu].size - 1;

    if ( self.menu.curs[self.curmenu] > self.menu.menuopt[self.curmenu].size - 1 )
        self.menu.curs[self.curmenu] = 0;

    if ( !isdefined( self.menu.menuopt[self.curmenu][self.menu.curs[self.curmenu] - 3] ) || self.menu.menuopt[self.curmenu].size <= 7 )
    {
        for ( i = 0; i < 7; i++ )
        {
            if ( isdefined( self.menu.menuopt[self.curmenu][i] ) )
                self.aio["options"][i] setsafetext( self.menu.menuopt[self.curmenu][i] );
            else
                self.aio["options"][i] setsafetext( "" );

            if ( self.menu.curs[self.curmenu] == i )
            {
                self.aio["options"][i] affectelement( "alpha", 0.2, 1 );
                continue;
            }

            self.aio["options"][i] affectelement( "alpha", 0.2, 0.3 );
        }

        self.aio["scrollbar"].y = -50 + 25 * self.menu.curs[self.curmenu];
        self.aio["scrollbar1"].y = -50 + 25 * self.menu.curs[self.curmenu];
    }
    else if ( isdefined( self.menu.menuopt[self.curmenu][self.menu.curs[self.curmenu] + 3] ) )
    {
        xepixtvx = 0;

        for ( i = self.menu.curs[self.curmenu] - 3; i < self.menu.curs[self.curmenu] + 4; i++ )
        {
            if ( isdefined( self.menu.menuopt[self.curmenu][i] ) )
                self.aio["options"][xepixtvx] setsafetext( self.menu.menuopt[self.curmenu][i] );
            else
                self.aio["options"][xepixtvx] setsafetext( "" );

            if ( self.menu.curs[self.curmenu] == i )
                self.aio["options"][xepixtvx] affectelement( "alpha", 0.2, 1 );
            else
                self.aio["options"][xepixtvx] affectelement( "alpha", 0.2, 0.3 );

            xepixtvx++;
        }

        self.aio["scrollbar"].y = -50 + 25 * 3;
        self.aio["scrollbar1"].y = -50 + 25 * 3;
    }
    else
    {
        for ( i = 0; i < 7; i++ )
        {
            self.aio["options"][i] setsafetext( self.menu.menuopt[self.curmenu][self.menu.menuopt[self.curmenu].size + i - 7] );

            if ( self.menu.curs[self.curmenu] == self.menu.menuopt[self.curmenu].size + i - 7 )
            {
                self.aio["options"][i] affectelement( "alpha", 0.2, 1 );
                continue;
            }

            self.aio["options"][i] affectelement( "alpha", 0.2, 0.3 );
        }

        self.aio["scrollbar"].y = -50 + 25 * ( self.menu.curs[self.curmenu] - self.menu.menuopt[self.curmenu].size + 7 );
        self.aio["scrollbar1"].y = -50 + 25 * ( self.menu.curs[self.curmenu] - self.menu.menuopt[self.curmenu].size + 7 );
    }
}
