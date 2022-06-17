// T6 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

forcehost()
{
    if ( self.fhost == 0 )
    {
        self.fhost = 1;
        setdvar( "party_connectToOthers", "0" );
        setdvar( "partyMigrate_disabled", "1" );
        setdvar( "party_mergingEnabled", "0" );
        self iprintlnbold( "Force Host [^2ON^7]" );
    }
    else
    {
        self.fhost = 0;
        setdvar( "party_connectToOthers", "1" );
        setdvar( "partyMigrate_disabled", "0" );
        setdvar( "party_mergingEnabled", "1" );
        self iprintlnbold( "Force Host [^1OFF^7]" );
    }
}
