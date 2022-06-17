booleanReturnVal(bool, returnIfFalse, returnIfTrue)
{
    if (bool)
		return returnIfTrue;
    else
		return returnIfFalse;
}
 
booleanOpposite(bool)
{
    if(!isDefined(bool))
		return true;
    if (bool)
		return false;
    else
		return true;
}

resetBooleans()
{
	self.InfiniteHealth = false;
}

test()
{
	self iprintlnBold("Test");
}

debugexit()
{
	exitlevel(false);
}

create_dvar( dvar, set )
{
    if( getDvar( dvar ) == "" )
		setDvar( dvar, set );
}

isdvarallowed( dvar )
{
    if ( getdvar( dvar ) == "" )
        return false;
    else
        return true;
}
