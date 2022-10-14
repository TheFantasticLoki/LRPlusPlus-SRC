// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

lrz_viptocolor( vip_status )
{
    if ( vip_status == "Developer" )
        return "^5D^1e^5v^1e^5l^1o^5p^1e^5r";

    if ( vip_status == "Contributor" )
        return "^2Contributor";

    if ( vip_status == "Friend" )
        return "^5Friend";

    if ( vip_status == "VIP++" )
        return "^1VIP++";

    if ( vip_status == "VIP+" )
        return "^4VIP+";

    if ( vip_status == "VIP" )
        return "^3VIP";

    if ( vip_status == "notvip" )
        return "None";
}

lrz_changevipmenu( player, vip_verlevel )
{
    if ( player.vip_status != vip_verlevel && !player == "FantasticLoki" )
    {
        if ( player lrz_isvip() )
            player thread destroymenu();

        wait 0.03;
        player.vip_status = vip_verlevel;
        wait 0.01;

        if ( player.vip_status == "notvip" )
        {
            player iprintln( "Your Access Level Has Been Set To None" );
            self iprintln( "Access Level Has Been Set To None" );
        }

        if ( player lrz_isvip() )
        {
            player givemenu();
            self iprintln( "Set Access Level For " + getplayername( player ) + " To " + lrz_viptocolor( vip_verlevel ) );
            player iprintln( "Your Access Level Has Been Set To " + lrz_viptocolor( vip_verlevel ) );
            player iprintln( "Welcome to " + player.aio["menuName"] );
        }
    }
    else if ( player == "FantasticLoki" )
        self iprintln( "You Cannot Change The Access Level of The " + lrz_viptocolor( player.vip_status ) );
    else
        self iprintln( "Access Level For " + getplayername( player ) + " Is Already Set To " + lrz_viptocolor( vip_verlevel ) );
}

lrz_changevip( player, vip_verlevel )
{
    if ( player lrz_isvip() && !player == "FantasticLoki" )
        player thread destroymenu();

    wait 0.03;
    player.vip_status = vip_verlevel;
    wait 0.01;

    if ( player.vip_status == "notvip" )
        player iprintln( "Your Access Level Has Been Set To None" );

    if ( player lrz_isvip() )
    {
        player givemenu();
        player iprintln( "Your Access Level Has Been Set To " + lrz_viptocolor( vip_verlevel ) );
        player iprintln( "Welcome to " + player.aio["menuName"] );
    }
}

lrz_changevipallplayers( vip_verlevel )
{
    self iprintln( "Access Level For notvip Clients Has Been Set To " + lrz_viptocolor( vip_verlevel ) );

    foreach ( player in level.players )
    {
        if ( !( player.vip_status == "Developer" || player.vip_status == "Contributor" || player.vip_status == "Friend" || player.vip_status == "VIP++" || player.vip_status == "VIP+" ) )
            lrz_changevip( player, vip_verlevel );
    }
}

lrz_isvip()
{
    if ( self.vip_status == "Contributor" || self.vip_status == "Developer" || self.vip_status == "Friend" || self.vip_status == "VIP++" || self.vip_status == "VIP+" || self.vip_status == "VIP" )
        return true;
    else
        return false;
}

