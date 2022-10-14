//Decompiled with SeriousHD-'s GSC Decompiler
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zombies/_zm_score;
init()
{
	level thread playerbank();
	level thread onplayerconnect();
	level thread roundlogger();

}

onplayerconnect()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	for(;;)
	{
	level waittill( "connected", player );
	player thread statsupdate();
	player thread downlogger();
	player thread revivelogger();
	player thread setplayermoney();
	player thread endplayermoney();
	player thread endplayermoney2();
	}

}

endplayermoney()
{
	self endon( "disconnect" );
	for(;;)
	{
	level waittill( "end_game" );
	setdvar( self getentitynumber() + "_money", 0 );
	}

}

endplayermoney2()
{
	self endon( "disconnect" );
	for(;;)
	{
	level waittill( "_zombie_game_over" );
	setdvar( self getentitynumber() + "_money", 0 );
	}

}

setplayermoney()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	for(;;)
	{
	if( !(isalive( self )) )
	{
		setdvar( self getentitynumber() + "_money", 0 );
	}
	else
	{
		setdvar( self getentitynumber() + "_money", self.score );
	}
	wait 0.05;
	}

}

getplayerbyguid( guid )
{
	i = 0;
	while( i < level.players.size )
	{
		if( int( level.players[ i] getguid() ) == int( guid ) && isalive( level.players[ i] ) )
		{
			return level.players[ i];
		}
		i++;
	}
	return 0;

}

playerbank()
{
	for(;;)
	{
	if( getdvar( "bank_withdraw" ) != "" )
	{
		withdraw = strtok( getdvar( "bank_withdraw" ), ";" );
		setdvar( "bank_withdraw", "" );
		getplayerbyguid( withdraw[ 0] ).score = getplayerbyguid( withdraw[ 0] ).score + int( withdraw[ 1] );
		getplayerbyguid( withdraw[ 0] ) iprintln( "Withdrew ^2$" + ( int( withdraw[ 1] ) + "^7 from your bank account!" ) );
	}
	if( getdvar( "bank_deposit" ) != "" )
	{
		deposit = strtok( getdvar( "bank_deposit" ), ";" );
		setdvar( "bank_deposit", "" );
		getplayerbyguid( deposit[ 0] ).score = getplayerbyguid( deposit[ 0] ).score - int( deposit[ 1] );
		getplayerbyguid( deposit[ 0] ) iprintln( "Deposited ^2$" + ( int( deposit[ 1] ) + "^7 into your bank account!" ) );
	}
	wait 0.05;
	}

}

arr2json( arr )
{
	if( isobj( arr ) )
	{
		return obj2json( arr );
	}
	keys = getarraykeys( arr );
	string = "[";
	i = 0;
	while( i < keys.size )
	{
		key = keys[ i];
		if( !(isobj( arr[ key] )) )
		{
			if( isint( arr[ key] ) )
			{
				string = string + arr[ key];
			}
			else
			{
				string = string + ( """ + ( arr[ key] + """ ) );
			}
		}
		else
		{
			string = string + obj2json( arr[ key] );
		}
		if( i < keys.size - 1 )
		{
			string = string + ", ";
		}
		i++;
	}
	string = string + "]";
	return string;

}

isint( var )
{
	return int( var ) == var;

}

json_encode( obj )
{
	if( !(isarray( obj )) )
	{
		return """ + ( obj + ""
" );
	}
	if( !(isobj( obj )) )
	{
		return arr2json( obj ) + "
";
	}
	return obj2json( obj ) + "
";

}

obj2json( obj )
{
	string = "{";
	keys = getarraykeys( obj );
	if( !(IsDefined( keys )) )
	{
		return "{ struct }";
	}
	i = 0;
	while( i < keys.size )
	{
		key = keys[ i];
		if( isarray( obj[ key] ) )
		{
			string = string + ( """ + ( key + ( "": " + arr2json( obj[ key] ) ) ) );
		}
		else
		{
			if( !(isint( obj[ key] )) )
			{
				string = string + ( """ + ( key + ( "": "" + ( obj[ key] + """ ) ) ) );
			}
			else
			{
				string = string + ( """ + ( key + ( "": " + obj[ key] ) ) );
			}
		}
		if( i < keys.size - 1 )
		{
			string = string + ", ";
		}
		i++;
	}
	string = string + "}";
	return string;

}

isobj( obj )
{
	keys = getarraykeys( obj );
	if( !(IsDefined( keys )) )
	{
		return 0;
	}
	i = 0;
	while( i < keys.size )
	{
		if( keys[ i] != 0 && int( keys[ i] ) == 0 )
		{
			return 1;
		}
		i++;
	}
	return 0;

}

playerstoarr()
{
	players = [];
	i = 0;
	while( i < level.players.size )
	{
		players[i] = [];
		players[i]["Name"] = level.players[ i].name;
		players[i]["Guid"] = level.players[ i] getguid();
		players[i]["Clientslot"] = level.players[ i] getentitynumber();
		players[i]["Stats"] = level.players[ i] getplayerstats();
		i++;
	}
	return players;

}

statsupdate()
{
	self endon( "disconnect" );
	for(;;)
	{
	obj = [];
	obj["event"] = "update_stats";
	obj["player"] = [];
	obj["player"]["Guid"] = self.guid;
	obj["player"]["Clientslot"] = self getentitynumber();
	obj["player"]["Stats"] = self getplayerstats();
	logprint( json_encode( obj ) );
	wait 60;
	}

}

getplayerstats()
{
	stats = [];
	stats["Kills"] = self.pers[ "kills"];
	stats["Downs"] = self.pers[ "downs"];
	stats["Revives"] = self.pers[ "revives"];
	stats["Headshots"] = self.pers[ "headshots"];
	stats["Score"] = self.score_total;
	return stats;

}

revivelogger()
{
	for(;;)
	{
	self waittill( "player_revived" );
	obj = [];
	obj["event"] = "player_revived";
	obj["player"] = [];
	obj["player"]["Name"] = self.name;
	obj["player"]["Guid"] = self.guid;
	obj["player"]["Clientslot"] = self getentitynumber();
	obj["player"]["Stats"] = self getplayerstats();
	logprint( json_encode( obj ) );
	}

}

downlogger()
{
	for(;;)
	{
	self waittill( "player_downed" );
	obj = [];
	obj["event"] = "player_downed";
	obj["player"] = [];
	obj["player"]["Name"] = self.name;
	obj["player"]["Guid"] = self.guid;
	obj["player"]["Clientslot"] = self getentitynumber();
	obj["player"]["Stats"] = self getplayerstats();
	logprint( json_encode( obj ) );
	}

}

roundlogger()
{
	for(;;)
	{
	level waittill( "start_of_round" );
	obj = [];
	obj["event"] = "round_start";
	obj["players"] = playerstoarr();
	obj["round"] = level.round_number;
	logprint( json_encode( obj ) );
	}

}

