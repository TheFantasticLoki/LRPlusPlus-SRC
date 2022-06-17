doredtheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
}

dodefaultpls()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0.43, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0.43, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0.43, 1 ) );
}

dogreentheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0.502, 0 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0.502, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0.502, 0 ) );
}

dopureredtheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
}
dopinktheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 1, 0, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 1 ) );
}
dobluetheme()
{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0, 1 ) );

}

stopbitchinghoe()
{
	if( self.verga == 0 )
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
	for(;;)
	{
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0.43, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0.43, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0.43, 1 ) );
	wait 1;
	self.AIO[ "scrollbar"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 0 ) );
	wait 1;
	self.AIO[ "scrollbar"] elemcolor( 1, ( 0, 0.502, 0 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 0, 0.502, 0 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 0, 0.502, 0 ) );
	wait 1;
	self.AIO[ "scrollbar"] elemcolor( 1, ( 1, 0, 1 ) );
	self.AIO[ "bartop"] elemcolor( 1, ( 1, 0, 1 ) );
	self.AIO[ "barbottom"] elemcolor( 1, ( 1, 0, 1 ) );
	wait 1;
	}

}
elemcolor( time, color )
{
	self fadeovertime( time );
	self.color = color;
}
