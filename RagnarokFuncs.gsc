doBuyMaxAmmo()
{
    //iprintlnbold( "^1Executed" );
    if( self.score > price)
    {
        self.score = self.score - price;
        self dopmammo();
    }
    else
    {
        iprintlnbold( "^1Not enough points!" );
    }
}

doBuyInstaKill(price)
{
    //iprintlnbold( "^1Executed" );
    if( self.score > price)
    {
        self.score = self.score - price;
        self dopinstakills();
    }
    else
    {
        iprintlnbold( "^1Not enough points!" );
    }
}

doBuyDoublePoints(price)
{
    //iprintlnbold( "^1Executed" );
    if( self.score > price)
    {
        self.score = self.score - price;
        self dopdoublepoints();
    }
    else
    {
        iprintlnbold( "^1Not enough points!" );
    }
}

doBuyNuke(price)
{
    //iprintlnbold( "^1Executed" );
    if( self.score > price)
    {
        self.score = self.score - price;
        self dopnuke();
    }
    else
    {
        iprintlnbold( "^1Not enough points!" );
    }
}

Zombie_Vars()
{
    for(;;)
    {
        level.zombie_vars[ "zombie_health_increase" ] = "125";
        level.zombie_vars[ "zombie_health_increase_multiplier" ] = "0.125";
        level.zombie_vars[ "zombie_max_ai" ] = "32";
        level.zombie_vars[ "zombie_move_speed_multiplier" ] = "12";
        while( level.round_number >= 1 && level.round_number <= 5 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 1.5;
        wait 0.1;
        }
        while( level.round_number >= 6 && level.round_number <= 10 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 1.25;
        wait 0.1;
        }
        while( level.round_number >= 11 && level.round_number <= 15 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 1;
        wait 0.1;
        }
        while( level.round_number >= 16 && level.round_number <= 20 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 0.75;
        wait 0.1;
        }
        while( level.round_number >= 21 )
        {
        level.zombie_vars[ "zombie_spawn_delay" ] = 0.50;
        wait 0.1;
        }
    }
}
