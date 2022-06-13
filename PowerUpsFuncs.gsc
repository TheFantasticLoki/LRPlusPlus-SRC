// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

dopnuke()
{
    foreach ( player in level.players )
    {
        level thread nuke_powerup( self, player.team );
        player powerup_vo( "nuke" );
        zombies = getaiarray( level.zombie_team );
        player.zombie_nuked = arraysort( zombies, self.origin );
        player notify( "nuke_triggered" );
    }

    self iprintlnbold( "Nuke Bomb ^2Send" );
}

dopmammo()
{
    foreach ( player in level.players )
    {
        level thread full_ammo_powerup( self, player );
        player thread powerup_vo( "full_ammo" );
    }

    self iprintlnbold( "Max Ammo ^2Send" );
}

dopdoublepoints()
{
    foreach ( player in level.players )
    {
        level thread double_points_powerup( self, player );
        player thread powerup_vo( "double_points" );
    }

    self iprintlnbold( "Double Points ^2Send" );
}

dopinstakills()
{
    foreach ( player in level.players )
    {
        level thread insta_kill_powerup( self, player );
        player thread powerup_vo( "insta_kill" );
    }

    self iprintlnbold( "Insta Kill ^2Send" );
}
