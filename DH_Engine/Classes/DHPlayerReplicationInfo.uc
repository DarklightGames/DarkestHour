//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPlayerReplicationInfo extends ROPlayerReplicationInfo;

var DH_RoleInfo     DHRoleInfo; // Can we remove this? it isn't used or set tmk anywhere, not sure how getRolePortrait would work if we even used it

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        DHRoleInfo;
}

simulated function Material getRolePortrait()
{
    if (DHRoleInfo == none)
    {
        return none;
    }
    else
    {
        return DHRoleInfo.MenuImage;
    }
}

defaultproperties
{
}
