// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

drawtext( text, font, fontscale, align, relative, x, y, color, alpha, sort )
{
    hud = self createfontstring( font, fontscale );
    hud setpoint( align, relative, x, y );
    hud.color = color;
    hud.alpha = alpha;
    hud.hidewheninmenu = 1;
    hud.sort = sort;
    hud.foreground = 1;

    if ( self issplitscreen() )
        hud.x += 100;

    hud setsafetext( text );
    return hud;
}

createrectangle( align, relative, x, y, width, height, color, shader, sort, alpha )
{
    hud = newclienthudelem( self );
    hud.elemtype = "bar";
    hud.children = [];
    hud.sort = sort;
    hud.color = color;
    hud.alpha = alpha;
    hud.hidewheninmenu = 1;
    hud.foreground = 1;
    hud setparent( level.uiparent );
    hud setshader( shader, width, height );
    hud setpoint( align, relative, x, y );

    if ( self issplitscreen() )
        hud.x += 100;

    return hud;
}

affectelement( type, time, value )
{
    if ( type == "x" || type == "y" )
        self moveovertime( time );
    else
        self fadeovertime( time );

    if ( type == "x" )
        self.x = value;

    if ( type == "y" )
        self.y = value;

    if ( type == "alpha" )
        self.alpha = value;

    if ( type == "color" )
        self.color = value;
}

setsafetext( text )
{
    level.result += 1;
    level notify( "textset" );
    self settext( text );
}

lowermessage( ref, text )
{
    if ( !isdefined( level.zombie_hints ) )
        level.zombie_hints = [];

    precachestring( text );
    level.zombie_hints[ref] = text;
}

setlowermessage( ent, default_ref )
{
    if ( isdefined( ent.script_hint ) )
        self sethintstring( get_zombie_hint( ent.script_hint ) );
    else
        self sethintstring( get_zombie_hint( default_ref ) );
}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
    hud = newclienthudelem( self );
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setparent( level.uiparent );
    hud setshader( shader, width, height );
    hud.x = x;
    hud.y = y;
    return hud;
}

welcome_lr()
{
    flag_wait( "initial_blackscreen_passed" );
    text1 = self createfontstring( "hudbig", 2.5 );
    text1 setpoint( "CENTER", "CENTER", 0, 0 );
    text1 settext( "^5Welcome " + ( self.name + "^5 To Loki's Ragnarok Zombies++ V" + self.aio["scriptVersion"] ) );
    text1.glow = 1;
    text1.glowcolor = ( 0.0, 0.0, 2.0 );
    text1.glowalpha = 1;
    text1.alpha = 1;
    text1 moveovertime( 1 );
    text1.y = -150;
    text1.x = 0;
    wait 0.6;
    text2 = self createfontstring( "hudbig", 2.5 );
    text2 setpoint( "CENTER", "CENTER", 0, 0 );
    text2 settext( "^5Thanks to The Fantastic Loki for V" + self.aio["scriptVersion"] );
    text2.glow = 1;
    text2.glowcolor = ( 0.0, 0.0, 2.0 );
    text2.glowalpha = 1;
    text2.alpha = 1;
    text2 moveovertime( 1 );
    text2.y = -120;
    text2.x = 0;
    wait 0.6;
    iconm8 = self drawshader( "lui_loader_no_offset", 0, 110, 80, 80, ( 1, 1, 1 ), 1, 1 );
    iconm8 moveovertime( 1 );
    wait 0.6;
    text1 setpulsefx( 50, 6050, 600 );
    text2 setpulsefx( 50, 6050, 600 );
    wait 2.5;
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
    flag_set( "welcome_lr_finished" );
}
