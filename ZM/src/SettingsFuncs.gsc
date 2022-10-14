// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

spawnbot()
{
    addtestclient();
    self iprintlnbold( "^5Bot ^2Spawned!" );
}

canzonenorm()
{
    self playsound( "mus_zmb_secret_song" );
    self iprintlnbold( "Easter Egg Song ^5Played" );
}

turnpoweron( user )
{
    trig = getent( "use_elec_switch", "targetname" );
    master_switch = getent( "elec_switch", "targetname" );
    master_switch notsolid();
    trig sethintstring( &"ZOMBIE_ELECTRIC_SWITCH" );
    trig setvisibletoall();
    trig notify( "trigger", user );
    trig setinvisibletoall();
    master_switch rotateroll( -90, 0, 3 );
    master_switch playsound( "zmb_switch_flip" );
    master_switch playsound( "zmb_poweron" );
    level delay_thread( 11, 8, ::wtfpoweron );

    if ( isdefined( user ) )
        user thread create_and_play_dialog( "power", "power_on" );

    level thread perk_unpause_all_perks();

    master_switch waittill( "rotatedone" );

    playfx( level._effect["switch_sparks"], master_switch.origin + ( 0.0, 12.0, -60.0 ), anglestoforward( master_switch.angles ) );
    master_switch playsound( "zmb_turn_on" );
    level notify( "electric_door" );
    clientnotify( "power_on" );
    flag_set( "power_on" );
    level setclientfield( "zombie_power_on", 1 );
    self iprintln( "^2Power On!" );
}

openalltehdoors()
{
    setdvar( "zombie_unlock_all", 1 );
    //self give_money();
    wait 0.5;
    self iprintln( "Open all the doors ^2Success" );
    triggers = strtok( "zombie_doors|zombie_door|zombie_airlock_buy|zombie_debris|flag_blocker|window_shutter|zombie_trap", "|" );

    for ( a = 0; a < triggers.size; a++ )
    {
        trigger = getentarray( triggers[a], "targetname" );

        for ( b = 0; b < trigger.size; b++ )
            trigger[b] notify( "trigger" );
    }

    wait 0.1;
    setdvar( "zombie_unlock_all", 0 );
}

autorevive()
{
    if ( level.autor == 0 )
    {
        level.autor = 1;
        self thread autor();
        self iprintlnbold( "Auto Revive [^2ON^7]" );
    }
    else
    {
        level.autor = 0;
        self iprintlnbold( "Auto Revive [^1OFF^7]" );
        self notify( "R_Off" );
        self notify( "R2_Off" );
    }
}

buildalltables()
{
    foreach ( stub in level.buildable_stubs )
        stub.built = 1;
}

levacassa()
{
    level.chest_accessed = 100;
    self iprintlnbold( "Box Will Be ^5Moved" );
}

magicbox()
{
    if ( self.magicbox == 0 )
    {
        self iprintlnbold( "Box ^2Frozen" );
        setdvar( "magic_chest_movable", "0" );
        self.magicbox = 1;
    }
    else
    {
        self iprintlnbold( "Box ^1Unfrozen" );
        setdvar( "magic_chest_movable", "1" );
        self.magicbox = 0;
    }
}

pauseme()
{
    self thread callback_hostmigration();
    self disableinvulnerability();
    wait 0.5;
    self.maxhealth = 999999999;
    self.health = self.maxhealth;

    if ( self.health < self.maxhealth )
        self.health = self.maxhealth;

    self enableinvulnerability();
}

lagswitch()
{
    self endon( "disconnect" );

    if ( self.lag == 1 )
    {
        self iprintlnbold( "Lag Switch ^2ON" );
        setdvar( "g_speed", "-1" );
        self.lag = 0;
    }
    else
    {
        self iprintlnbold( "Lag Switch ^1OFF" );
        setdvar( "g_speed", "200" );
        self.lag = 1;
    }
}

sprintofds()
{
    if ( self.diosassssaa == 0 )
    {
        self iprintlnbold( "Unlimited Sprint ^2On" );
        self setperk( "specialty_unlimitedsprint" );
        self.diosassssaa = 1;
    }
    else
    {
        self unsetperk( "specialty_unlimitedsprint" );
        self iprintlnbold( "Unlimited Sprint ^1Off" );
        self.diosassssaa = 0;
    }
}

farrevive()
{
    if ( self.farreviv == 0 )
    {
        self.farreviv = 1;
        setdvar( "revive_trigger_radius", "9999" );
        self iprintlnbold( "Far Revive ^2On" );
    }
    else
    {
        self.farreviv = 0;
        setdvar( "revive_trigger_radius", "60" );
        self iprintlnbold( "Far Revive ^1Off" );
    }
}

gravity()
{
    if ( self.grav == 1 )
    {
        setdvar( "bg_gravity", "150" );
        self.grav = 0;
        iprintln( "Low Gravity ^2ON" );
    }
    else
    {
        setdvar( "bg_gravity", "800" );
        self.grav = 1;
        iprintln( "Low Gravity ^1OFF" );
    }
}

changetimescale()
{
    level.currenttimescale += 1;

    if ( level.currenttimescale == 1 )
    {
        setdvar( "timescale", "1" );
        self iprintln( "Timescale Set To ^2Normal" );
    }

    if ( level.currenttimescale == 2 )
    {
        setdvar( "timescale", "0.5" );
        self iprintln( "Timescale Set To ^2Slow" );
    }

    if ( level.currenttimescale == 3 )
    {
        setdvar( "timescale", "1.5" );
        self iprintln( "Timescale Set To ^2Fast" );
    }

    if ( level.currenttimescale == 3 )
        level.currenttimescale = 0;
}

bleed()
{
    if ( self.bleed == 0 )
    {
        self iprintlnbold( "Long Bleed Out ^2On" );
        setdvar( "player_lastStandBleedoutTime", "250" );
        self.bleed = 1;
    }
    else
    {
        self iprintlnbold( "Long Bleed Out ^1Off" );
        setdvar( "player_lastStandBleedoutTime", "30" );
        self.bleed = 0;
    }
}

knifemeelee()
{
    self endon( "disconnect" );

    if ( self.sm1 == 1 )
    {
        self iprintlnbold( "Long Melee Range ^2On" );
        setdvar( "player_meleeRange", "999" );
        self.sm1 = 0;
    }
    else
    {
        self iprintlnbold( "Long Melee Range ^1Off" );
        setdvar( "player_meleeRange", "50" );
        self.sm1 = 1;
    }
}

fastend()
{
    wait 0.4;
    exitlevel( 1 );
}

doendgame()
{
    self iprintlnbold( "^5Current Game Ended" );
    level notify( "end_game" );
}

dorestartgame()
{
    self iprintlnbold( "^5Current Game Restarted" );
    wait 1;
    map_restart( 0 );
}

speed()
{
    if ( self.sm == 0 )
    {
        iprintln( "Super Speed ^2ON" );
        setdvar( "g_speed", "400" );
        self.sm = 1;
    }
    else
    {
        iprintln( "Super Speed ^1OFF" );
        setdvar( "g_speed", "200" );
        self.sm = 0;
    }
}

toggleantiquit()
{
    if ( self.doantiquit == 0 )
    {
        self thread doantiquit();
        self.doantiquit = 1;
        self iprintlnbold( "Anti Quit ^2ON" );
    }
    else
    {
        self notify( "stopAntiQuit" );
        self.doantiquit = 0;
        self iprintlnbold( "Anti Quit ^1OFF" );
    }
}

wtfpoweron()
{
    level thread sndmusicstingerevent( "poweron" );
}

give_money()
{
    self add_to_player_score( 100000 );
}

autor()
{
    self endon( "R_Off" );

    for (;;)
    {
        self thread reviveall();
        wait 0.05;
    }
}

doantiquit()
{
    self endon( "disconnect" );
    self endon( "stopAntiQuit" );

    for (;;)
    {
        foreach ( player in level.players )
            player closemenus();

        wait 0.05;
    }
}

reviveall()
{
    self endon( "R2_Off" );

    foreach ( p in level.players )
    {
        if ( isdefined( p.revivetrigger ) )
        {
            p notify( "player_revived" );
            p reviveplayer();
            p.revivetrigger delete();
            p.revivetrigger = undefined;
            p.ignoreme = 0;
            p allowjump( 1 );
            p.laststand = undefined;
        }
    }
}

closemenus()
{
    self freezecontrols( 0 );
    self playsoundtoplayer( "cac_grid_equip_item", self );
    self hidehud();
    self setclientuivisibilityflag( "hud_visible", 1 );
    self.menu.open = 0;
}
