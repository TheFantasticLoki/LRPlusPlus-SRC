// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

debug_status()
{
    self thread lrz_big_msg( "DEBUG_self.Status: " + self.status );
}

debug_isdev()
{
    self thread lrz_big_msg( "DEBUG_isDev: " + self isdev() );
}

debug_spawndelay()
{
    self lrz_bold_msg( "Test: spawn delay = " + level.zombie_vars["zombie_spawn_delay"] );
}

debug_perklimit()
{
    self lrz_big_msg( "DEBUG_PerkLimit: " + level.perk_purchase_limit );
}

debug_msg()
{
    self lrz_big_msg( "DEBUG_Msg: " );
}
