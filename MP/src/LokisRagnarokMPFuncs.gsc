LokisRagnarokMPPlusPlus()
{
    level endon( "LRMP_Trigger_Disable" );
}

LRMP_Init_Dvars()
{
    level endon( "LRMP_Trigger_Disable" );

    create_dvar("LRMP_enabled", "1");
	create_dvar("LRMP_menu", "0");
}

LRMP_Init_Commands()
{
    level endon("game_ended");
    level endon( "LRMP_Trigger_Disable" );
    for(;;)
    {
        level waittill("connected", player);
        player thread LRMP_CMD_VIP_Ammo();
    }
}

LRMP_VIP_Funcs()
{
	if( getPlayerName(self) == "FantasticLoki" )
	{
		//self LRZ_Bold_Msg("^3Welcome ^7[^5D^1E^5V^7] ^1FantasticLoki");
        self iPrintLn("^3Welcome ^7[^5D^1E^5V^7] ^1FantasticLoki");
		self thread Loki_Binds();
		//self setperk( "specialty_fastmantle" );
		//self setperk( "specialty_fastladderclimb" );
        self thread VIP_ammo();
        //self thread setvipperks();
	}
	if( getPlayerName(self) == "MudKippz" )
	{
		self LRZ_Bold_Msg("Welcome Mudkippz, <3 Loki");
	}
}

LRMP_Diamond_GameTypes()
{
    level endon( "LRMP_Trigger_Disable" );
    LRMP_GT = getDvar("ui_gametype");
    switch(LRMP_GT)
    {
        case "gun":
            LRMP_DGT = 1;
            break;
        case "oic":
            LRMP_DGT = 1;
            break;
        case "shrp":
            LRMP_DGT = 1;
            break;
        case "sas":
            LRMP_DGT = 1;
            break;
        default:
            LRMP_DGT = 0;
            break;
    }
    if(LRMP_DGT == 1 && getDvar("LRMP_enabled") == 1)
    {
        for(;;)
        {
            foreach( player in level.players)
            {
                self waittill( "spawned_player" );
                wait 0.05;
                self camo_change(16);
                wait 0.05;
                if(getDvar("ui_gametype") == "oic")
                {
                    weapon = self getcurrentweapon();
                    self SetWeaponAmmoStock(weapon, 0);
                    self SetWeaponAmmoClip(weapon, 1);
                    level notify("DGT_OIC_Finished");
                }
            }
            wait 0.05;
        }
    }
}

