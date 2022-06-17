overflowfix()
{
    level endon( "game_ended" );
    level endon( "host_migration_begin" );
    level.test = createserverfontstring( "default", 1 );
    level.test settext( "xTUL" );
    level.test.alpha = 0;

    if ( getdvar( "g_gametype" ) == "sd" )
        a = 45;
    else
        a = 55;

    for (;;)
    {
        level waittill( "textset" );

        if ( level.result >= a )
        {
            level.test clearalltextafterhudelem();
            level.result = 0;

            foreach ( player in level.players )
            {
                if ( player.menu.open && player isverified() )
                {
                    player.isoverflowing = 1;
                    player submenu( player.curmenu, player.curtitle );
                    player.aio["closeText"] setsafetext( "[{+speed_throw}]+[{+melee}] to Open Ragnarok" );
                    player.aio["status"] setsafetext( "Status: " + verificationtocolor( player.status ) );
                }

                if ( !player.menu.open && player isverified() )
                {
                    player.aio["closeText"] setsafetext( "[{+speed_throw}]+[{+melee}] to Open Ragnarok" );
                    player.aio["status"] setsafetext( "Status: " + verificationtocolor( player.status ) );
                }
            }
        }
    }
}
