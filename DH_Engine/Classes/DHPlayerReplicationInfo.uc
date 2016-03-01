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

defaultproperties
{
    SquadIndex=-1
    SquadMemberIndex=-1
}
