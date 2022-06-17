LRMP_CMD_VIP_Ammo()
{
    self endon("disconnect");
    level endon("game_ended");
    self notifyOnPlayerCommand( "LRMP_CMD_VIP_Ammo_notify", "VIP_Ammo" );
    for(;;)
    {
        self waittill( "LRMP_CMD_VIP_Ammo_notify" );
        primary = self getCurrentWeapon();
        secondary = self getCurrentOffHand();
        self setWeaponAmmoStock(primary, self getWeaponAmmoStock(primary)*3);
        self setWeaponAmmoStock(secondary, self getWeaponAmmoStock(secondary)*3);
    }
}