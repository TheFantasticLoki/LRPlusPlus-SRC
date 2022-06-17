// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

verificationtocolor( status )
{
    if ( status == "Host" )
        return "^2Host";

    if ( status == "Developer" )
        return "^5D^1e^5v^1e^5l^1o^5p^1e^5r";

    if ( status == "Co-Host" )
        return "^5Co-Host";

    if ( status == "Admin" )
        return "^1Admin";

    if ( status == "VIP" )
        return "^4VIP";

    if ( status == "Verified" )
        return "^3Verified";

    if ( status == "Unverified" )
        return "None";
}

changeverificationmenu( player, verlevel )
{
    if ( player.status != verlevel && !getPlayerName(player) == "FantasticLoki" )
    {
        if ( player isverified() )
            player thread destroymenu();

        wait 0.03;
        player.status = verlevel;
        wait 0.01;

        if ( player.status == "Unverified" )
        {
            player iprintln( "Your Access Level Has Been Set To None" );
            self iprintln( "Access Level Has Been Set To None" );
        }

        if ( player isverified() )
        {
            player givemenu();
            self iprintln( "Set Access Level For " + getplayername( player ) + " To " + verificationtocolor( verlevel ) );
            player iprintln( "Your Access Level Has Been Set To " + verificationtocolor( verlevel ) );
            player iprintln( "Welcome to " + player.aio["menuName"] );
        }
    }
    else if ( getPlayerName(player) == "FantasticLoki" )
        self iprintln( "You Cannot Change The Access Level of The " + verificationtocolor( player.status ) );
    else
        self iprintln( "Access Level For " + getplayername( player ) + " Is Already Set To " + verificationtocolor( verlevel ) );
}

changeverification( player, verlevel )
{
    if ( player isverified() && !getPlayerName(player) == "FantasticLoki" )
        player thread destroymenu();

    wait 0.03;
    player.status = verlevel;
    wait 0.01;

    if ( player.status == "Unverified" )
        player iprintln( "Your Access Level Has Been Set To None" );

    if ( player isverified() )
    {
        player givemenu();
        player iprintln( "Your Access Level Has Been Set To " + verificationtocolor( verlevel ) );
        player iprintln( "Welcome to " + player.aio["menuName"] );
    }
}

changeverificationallplayers( verlevel )
{
    self iprintln( "Access Level For Unverified Clients Has Been Set To " + verificationtocolor( verlevel ) );

    foreach ( player in level.players )
    {
        if ( !( player.status == "Developer" || player.status == "Host" || player.status == "Co-Host" || player.status == "Admin" || player.status == "VIP" ) )
            changeverification( player, verlevel );
    }
}

getplayername( player )
{
    playername = getsubstr( player.name, 0, player.name.size );

    for ( i = 0; i < playername.size; i++ )
    {
        if ( playername[i] == "]" )
            break;
    }

    if ( playername.size != i )
        playername = getsubstr( playername, i + 1, playername.size );

    return playername;
}

playermenuauth()
{

}

isverified()
{
    if ( self.status == "Host" || self.status == "Developer" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified" )
        return true;
    else
        return false;
}

isdev()
{
    if ( self.status == "Developer" )
        return true;
    else
        return false;
}
