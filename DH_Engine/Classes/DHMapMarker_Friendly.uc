//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Friendly extends DHMapMarker
    abstract;

defaultproperties
{
    IconColor=(R=0,G=255,B=0,A=255)
    GroupIndex=2
    Scope=TEAM
    OverwritingRule=OFF
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ALL)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=SL)
    Permissions_CanRemove(1)=(LevelSelector=TEAM,RoleSelector=ASL)
    Permissions_CanPlace(0)=(LevelSelector=TEAM,RoleSelector=SL)
    Permissions_CanPlace(1)=(LevelSelector=TEAM,RoleSelector=ASL)
}

