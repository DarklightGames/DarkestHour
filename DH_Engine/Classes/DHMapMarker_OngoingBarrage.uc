//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHMapMarker_OngoingBarrage extends DHMapMarker
    abstract;

defaultproperties
{
    MarkerName="Ongoing Barrage"

    IconMaterial=Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=64,X2=63,Y2=127)
    IconColor=(R=255,G=255,B=255,A=255)
    Type=MT_ArtilleryBarrage
    OverwritingRule=UNIQUE
    Scope=TEAM
    LifetimeSeconds=-1
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ALL)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=NO_ONE)
    Permissions_CanPlace(0)=ARTILLERY_SPOTTER)
}
