testLeagueStatsEdit()
{
    /* leaguestats.rank = struct.field_name("leaguestats_s", "rank");
    leaguestats.divisionid = struct.field_name("leaguestats_s", "divisionid");
    leaguestats.seasonid = field_name("leaguestats_s", "seasonid");
    leaguestats.subdivisionid = struct.field_name("leaguestats_s", "subdivisionid");
    leaguestats.teamid = struct.field_name("leaguestats_s", "teamid");*/

    /*leaguestats_s.divisionid = 1;
    leaguestats_s.seasonid = 1;
    leaguestats_s.subdivisionid = 1;
    leaguestats_s.teamid = 1;
    leaguestats_s.rank = 1;*/

    /*player structSet(leaguestats_s, bestleague, 1);
    player structSet(leaguestats_s, teamid, 1);
    player structSet(leaguestats_s, rank, 1);
    player structSet(leaguestats_s, divisionid, 1);*/
}

debug_isdev()
{
    self thread lrz_big_msg( "DEBUG_isDev: " + self isdev() );
    self iprintlnBold( "DEBUG_isDev: " + self isdev() );
}

debug_name()
{
    self thread lrz_big_msg( "DEBUG_name: " + self.name );
    self iprintlnBold( "DEBUG_name: " + self.name );
}
