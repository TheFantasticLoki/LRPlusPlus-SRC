// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

doredtheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 0, 0, 1 ) );
    self.aio["bartop"] elemcolor( 1, ( 1, 0, 0 ) );
    self.aio["barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
}

dodefaultpls()
{
    self.aio["scrollbar"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
    self.aio["bartop"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
    self.aio["barbottom"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
}

dogreentheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
    self.aio["bartop"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
    self.aio["barbottom"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
}

dopureredtheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 1, 0, 0 ) );
    self.aio["bartop"] elemcolor( 1, ( 1, 0, 0 ) );
    self.aio["barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
}

dopinktheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 1, 0, 1 ) );
    self.aio["bartop"] elemcolor( 1, ( 1, 0, 1 ) );
    self.aio["barbottom"] elemcolor( 1, ( 1, 0, 1 ) );
}

dobluetheme()
{
    self.aio["scrollbar"] elemcolor( 1, ( 0, 0, 1 ) );
    self.aio["bartop"] elemcolor( 1, ( 0, 0, 1 ) );
    self.aio["barbottom"] elemcolor( 1, ( 0, 0, 1 ) );
}

stopbitchinghoe()
{
    if ( self.verga == 0 )
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

    for (;;)
    {
        self.aio["scrollbar"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
        self.aio["bartop"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
        self.aio["barbottom"] elemcolor( 1, ( 0.0, 0.43, 1.0 ) );
        wait 1;
        self.aio["scrollbar"] elemcolor( 1, ( 1, 0, 0 ) );
        self.aio["bartop"] elemcolor( 1, ( 1, 0, 0 ) );
        self.aio["barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
        wait 1;
        self.aio["scrollbar"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
        self.aio["bartop"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
        self.aio["barbottom"] elemcolor( 1, ( 0.0, 0.502, 0.0 ) );
        wait 1;
        self.aio["scrollbar"] elemcolor( 1, ( 1, 0, 1 ) );
        self.aio["bartop"] elemcolor( 1, ( 1, 0, 1 ) );
        self.aio["barbottom"] elemcolor( 1, ( 1, 0, 1 ) );
        wait 1;
    }
}

elemcolor( time, color )
{
    self fadeovertime( time );
    self.color = color;
}
