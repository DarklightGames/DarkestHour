//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHPlayerReplicationInfo extends ROPlayerReplicationInfo;

//=============================================================================
// Variables
//=============================================================================

var DH_RoleInfo     DHRoleInfo;

//=============================================================================
// replication
//=============================================================================

replication
{
    reliable if (bNetDirty && (Role == Role_Authority))
        DHRoleInfo;
}

//=============================================================================
// Functions
//=============================================================================

simulated function Material getRolePortrait()
{
    if (DHRoleInfo == none)
        return none;
    else
        return DHRoleInfo.MenuImage;
}

defaultproperties
{
}
