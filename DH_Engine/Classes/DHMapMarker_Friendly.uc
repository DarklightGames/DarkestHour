//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapMarker_Friendly extends DHMapMarker
    abstract;

defaultproperties
{
    IconColor=(R=0,G=255,B=0,A=255)
    GroupIndex=2
    Type=MT_Friendly
    Scope=TEAM
    OverwritingRule=OFF
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ERS_ALL)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=ERS_SL)
    Permissions_CanRemove(1)=(LevelSelector=TEAM,RoleSelector=ERS_ASL)
    Permissions_CanPlace(0)=ERS_SL
    Permissions_CanPlace(1)=ERS_ASL
}

