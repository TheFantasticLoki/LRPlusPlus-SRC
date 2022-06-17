// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

upload_stats_on_round_end()
{
    level endon( "end_game" );

    for (;;)
    {
        level waittill( "end_of_round" );

        uploadstats();
    }
}

upload_stats_on_game_end()
{
    level waittill( "end_game" );

    uploadstats();
}

upload_stats_on_player_connect()
{
    level endon( "end_game" );

    for (;;)
    {
        level waittill( "connected" );

        level thread delay_uploadstats( 1 );
    }
}

delay_uploadstats( delay )
{
    level notify( "delay_uploadstats" );
    level endon( "delay_uploadstats" );
    level endon( "end_game" );
    wait( delay );
    uploadstats();
}
