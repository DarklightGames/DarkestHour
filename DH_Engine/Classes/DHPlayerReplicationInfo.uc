//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPlayerReplicationInfo extends ROPlayerReplicationInfo;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        SquadIndex, SquadMemberIndex;
}

var     int                     SquadIndex;
var     int                     SquadMemberIndex;

function bool IsInSquad()
{
    return Team != none && (Team.TeamIndex == AXIS_TEAM_INDEX || Team.TeamIndex == ALLIES_TEAM_INDEX) && SquadIndex != -1;
}

// Will return true if passed two different players that are in the same squad.
simulated static function bool IsInSameSquad(DHPlayerReplicationInfo A, DHPlayerReplicationInfo B)
{
    return A != none && B != none && A != B ||
          (A.Team.TeamIndex == AXIS_TEAM_INDEX || A.Team.TeamIndex == ALLIES_TEAM_INDEX) &&
           A.Team.TeamIndex == B.Team.TeamIndex &&
           A.SquadIndex == B.SquadIndex;
}

defaultproperties
{
    SquadIndex=-1
    SquadMemberIndex=-1
}
