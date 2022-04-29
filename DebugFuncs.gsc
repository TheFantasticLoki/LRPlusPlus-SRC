DEBUG_Status() 
{
    self thread LRZ_Big_Msg("DEBUG_self.Status: "+self.status);
}

DEBUG_isDev() 
{
    self thread LRZ_Big_Msg("DEBUG_isDev: "+self isDev());
}

DEBUG_SpawnDelay()
{
	self LRZ_Bold_Msg("Test: spawn delay = "+level.zombie_vars["zombie_spawn_delay"]);
}

DEBUG_PerkLimit()
{
    self LRZ_Big_Msg("DEBUG_PerkLimit: "+level.perk_purchase_limit);
}