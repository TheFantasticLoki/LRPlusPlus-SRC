LRZ_Big_Msg( msg1, msg2, delay, icon ) // Must Be Threaded
{
	flag_wait( "initial_blackscreen_passed" );
	text1 = self createfontstring( "hudbig", 2.5 );
	text1 setpoint( "CENTER", "CENTER", 0, 0 );
	text1 settext( msg1 );
	text1.glow = 1;
	text1.glowcolor = ( 0, 0, 2 );
	text1.glowalpha = 1;
	text1.alpha = 1;
	text1 moveovertime( 1 );
	text1.y = -150;
	text1.x = 0;
	wait 0.6;
	text2 = self createfontstring( "hudbig", 2.5 );
	text2 setpoint( "CENTER", "CENTER", 0, 0 );
	text2 settext( msg2 );
	text2.glow = 1;
	text2.glowcolor = ( 0, 0, 2 );
	text2.glowalpha = 1;
	text2.alpha = 1;
	text2 moveovertime( 1 );
	text2.y = -120;
	text2.x = 0;
	wait 0.6;
	iconm8 = self drawshader( icon, 0, 110, 80, 80, ( 1, 1, 1 ), 1, 1 );
	iconm8 moveovertime( 1 );
	wait 0.6;
	text1 setpulsefx( 50, 6050, 600 );
	text2 setpulsefx( 50, 6050, 600 );
	if( !delay )
		wait 2.5;
	else
		wait delay;
	text1 fadeovertime( 3 );
	text2 fadeovertime( 3 );
	iconm8 fadeovertime( 3 );
	text1.alpha = 0;
	text2.alpha = 0;
	iconm8.alpha = 0;
	wait 1;
	text1 destroy();
	text2 destroy();
	iconm8 destroy();

}

LRZ_Bold_Msg( msg1, delay) // Can NOT be threaded
{
	self iprintlnBold(msg1);
	if(!delay)
		wait 2;
	else
		wait delay;
}

camo_change( value )
{
	weapon = self getcurrentweapon();
	self takeweapon( weapon );
	self giveweapon( weapon, 0, self calcweaponoptions( value, 0, 0, 0 ) );
	self givestartammo( weapon );
	self switchtoweapon( weapon );

}
