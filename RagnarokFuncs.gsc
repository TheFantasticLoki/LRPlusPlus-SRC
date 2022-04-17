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
    level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
}