drawText(text, font, fontScale, align, relative, x, y, color, alpha, sort)
{
	hud = self createFontString(font, fontScale);
	hud setPoint(align, relative, x, y);
	hud.color = color;
	hud.alpha = alpha;
	hud.hideWhenInMenu = true;
	hud.sort = sort;
	hud.foreground = true;
	if(self issplitscreen()) hud.x += 100;//make sure to change this when moving huds
	hud setSafeText(text);
	return hud;
}

createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
{
	hud = newClientHudElem(self);
	hud.elemType = "bar";
	hud.children = [];
	hud.sort = sort;
	hud.color = color;
	hud.alpha = alpha;
	hud.hideWhenInMenu = true;
	hud.foreground = true;
	hud setParent(level.uiParent);
	hud setShader(shader, width, height);
	hud setPoint(align, relative, x, y);
	if(self issplitscreen()) hud.x += 100;//make sure to change this when moving huds
	return hud;
}

affectElement(type, time, value)
{
    if(type == "x" || type == "y")
        self moveOverTime(time);
    else
        self fadeOverTime(time);
 
    if(type == "x")
        self.x = value;
    if(type == "y")
        self.y = value;
    if(type == "alpha")
        self.alpha = value;
    if(type == "color")
        self.color = value;
}

setSafeText(text)
{
	level.result += 1;
	level notify("textset");
	self setText(text);
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
    text1 settext( "^5Welcome " + ( self.name + "^5 To Loki's Ragnarok MP++ V" + self.aio["scriptVersion"] ) );
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
