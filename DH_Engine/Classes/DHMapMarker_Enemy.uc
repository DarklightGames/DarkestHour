//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Enemy extends DHMapMarker
    abstract;

defaultproperties
{
    IconColor=(R=255,G=0,B=0,A=255)
    GroupIndex=1
    Scope=TEAM
    OverwritingRule=OFF
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ALL)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=SL)
    Permissions_CanRemove(1)=(LevelSelector=TEAM,RoleSelector=ASL)
    Permissions_CanRemove(2)=(LevelSelector=TEAM,RoleSelector=PATRON)
    Permissions_CanPlace(0)=(LevelSelector=TEAM,RoleSelector=SL)
    Permissions_CanPlace(1)=(LevelSelector=TEAM,RoleSelector=ASL)
    Permissions_CanPlace(2)=(LevelSelector=TEAM,RoleSelector=PATRON)
}
