Loki_Binds()
{
	for(;;)
	{
		while( self usebuttonpressed() )
		{
			if( self actionslottwobuttonpressed() )
			{
				self debug_isDev();
				wait 0.05;
			}
			wait 0.05;
			if( self actionslotonebuttonpressed() )
			{
				self camo_change(39);
				wait 0.05;
			}
			wait 0.05;
			/*if(self actionslotthreebuttonpressed())
			{
				//weapon = self getcurrentweapon();
				self GPA(+sf);
				wait 0.05;
				self GPA(+grip);
				wait 0.05;
				self GPA(+reflex);
				//self GPA(+sf);
				wait 0.05;
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

setvipperks()
{
	for(;;)
	{
		level waittill("spawned_player");
		self setperk("specialty_additionalprimaryweapon");
    	self setperk("specialty_armorpiercing");
    	self setperk("specialty_armorvest");
    	self setperk("specialty_bulletaccuracy");
    	self setperk("specialty_bulletdamage");
    	self setperk("specialty_bulletflinch");
    	self setperk("specialty_bulletpenetration");
    	self setperk("specialty_deadshot");
    	self setperk("specialty_delayexplosive");
    	self setperk("specialty_detectexplosive");
    	self setperk("specialty_disarmexplosive");
    	self setperk("specialty_earnmoremomentum");
    	self setperk("specialty_explosivedamage");
    	self setperk("specialty_extraammo");
    	self setperk("specialty_fallheight");
    	self setperk("specialty_fastads");
    	self setperk("specialty_fastequipmentuse");
    	self setperk("specialty_fastladderclimb");
    	self setperk("specialty_fastmantle");
    	self setperk("specialty_fastmeleerecovery");
    	self setperk("specialty_fastreload");
    	self setperk("specialty_fasttoss");
    	self setperk("specialty_fastweaponswitch");
    	self setperk("specialty_finalstand");
    	self setperk("specialty_fireproof");
    	self setperk("specialty_flakjacket");
    	self setperk("specialty_flashprotection");
    	self setperk("specialty_gpsjammer");
    	self setperk("specialty_grenadepulldeath");
    	self setperk("specialty_healthregen");
    	self setperk("specialty_holdbreath");
    	self setperk("specialty_immunecounteruav");
    	self setperk("specialty_immuneemp");
    	self setperk("specialty_immunemms");
    	self setperk("specialty_immunenvthermal");
    	self setperk("specialty_immunerangefinder");
    	self setperk("specialty_killstreak");
    	self setperk("specialty_longersprint");
    	self setperk("specialty_loudenemies");
    	self setperk("specialty_marksman");
    	self setperk("specialty_movefaster");
    	self setperk("specialty_nomotionsensor");
    	self setperk("specialty_noname");
    	self setperk("specialty_nottargetedbyairsupport");
    	self setperk("specialty_nokillstreakreticle");
    	self setperk("specialty_nottargettedbysentry");
    	self setperk("specialty_pin_back");
    	self setperk("specialty_pistoldeath");
    	self setperk("specialty_proximityprotection");
    	self setperk("specialty_quickrevive");
    	self setperk("specialty_quieter");
    	self setperk("specialty_reconnaissance");
    	self setperk("specialty_rof");
    	self setperk("specialty_scavenger");
    	self setperk("specialty_showenemyequipment");
    	self setperk("specialty_stunprotection");
    	self setperk("specialty_shellshock");
    	self setperk("specialty_sprintrecovery");
    	self setperk("specialty_showonradar");
    	self setperk("specialty_stalker");
    	self setperk("specialty_twogrenades");
    	self setperk("specialty_twoprimaries");
    	self setperk("specialty_unlimitedsprint");
		wait 0.05;
	}
}