//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHPlayerReplicationInfo extends ROPlayerReplicationInfo;

var     float                   NameDrawStartTime;
var     float                   LastNameDrawTime;

var     string                  IDHash; // This does not need replicated because it is only used by the server.  It exists here for ease of access.
var     int                     WeaponUnlockTime; // Weapons can lock (preventing fire) for punishment, this is when it become unlocked

replication
{
    // Replicate to owner client only
    reliable if (bNetOwner && bNetDirty && (Role == Role_Authority))
        WeaponUnlockTime;
}

defaultproperties
{
}

