//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHPlayerReplicationInfo extends ROPlayerReplicationInfo;

var DH_RoleInfo     DHRoleInfo;

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
