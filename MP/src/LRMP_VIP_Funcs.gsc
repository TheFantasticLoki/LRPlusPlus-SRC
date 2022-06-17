Loki_Binds()
{
	for(;;)
	{
		while( self usebuttonpressed() )
		{
			if( self actionslottwobuttonpressed() )
			{
				self debug_isDev();
				wait 0.08;
			}
			wait 0.08;
			if( self actionslotonebuttonpressed() )
			{
				self camo_change(39);
				wait 0.08;
			}
			wait 0.08;
			/*if(self actionslotthreebuttonpressed())
			{
				//weapon = self getcurrentweapon();
				self GPA(+sf);
				wait 0.08;
				self GPA(+grip);
				wait 0.08;
				self GPA(+reflex);
				//self GPA(+sf);
				wait 0.08;
			}*/
		}
		wait 0.1;
	}
}

VIP_ammo()
{
    level waittill("spawned_player");
    //if(getDvar("ui_gametype") == "oic" && getDvar("LRMP_enabled") == 1)
        //level waittill("DGT_OIC_Finished");
    primary = self getCurrentWeapon();
    secondary = self getCurrentOffHand();
    self setWeaponAmmoStock(primary, self getWeaponAmmoStock(primary)*3);
    self setWeaponAmmoStock(secondary, self getWeaponAmmoStock(secondary)*3);
}