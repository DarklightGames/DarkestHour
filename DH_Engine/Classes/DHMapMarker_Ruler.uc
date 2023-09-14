//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// A marker for measuring distances on the map. Any role can use it.

class DHMapMarker_Ruler extends DHMapMarker
    abstract;

static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    return static.GetDistanceString(PC, Marker);
}

defaultproperties
{
    MarkerName="Measure"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Calipers'
    IconColor=(R=0,G=204,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=4
    bShouldShowOnCompass=true
    Type=MT_Measurement
    OverwritingRule=UNIQUE
    Scope=PERSONAL
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ERS_ALL)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=ERS_ALL)
    Permissions_CanPlace(0)=ERS_ALL
    ActivationTimeout=15
}

