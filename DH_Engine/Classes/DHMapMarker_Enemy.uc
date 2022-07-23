//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHMapMarker_Enemy extends DHMapMarker
    abstract;

defaultproperties
{
    IconColor=(R=255,G=0,B=0,A=255)
    GroupIndex=1
    Type=MT_Enemy
    Scope=TEAM
    OverwritingRule=OFF
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ERS_ALL)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=ERS_SL)
    Permissions_CanRemove(1)=(LevelSelector=TEAM,RoleSelector=ERS_ASL)
    Permissions_CanRemove(2)=(LevelSelector=TEAM,RoleSelector=ERS_PATRON)
    Permissions_CanPlace(0)=ERS_SL
    Permissions_CanPlace(1)=ERS_ASL
    Permissions_CanPlace(2)=ERS_PATRON
}
