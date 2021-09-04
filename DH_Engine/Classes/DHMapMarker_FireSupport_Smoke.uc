//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_Smoke extends DHMapMarker_FireSupport
    abstract;

defaultproperties
{
    MarkerName="On-map mortar barrage (smoke)"
    TypeName="Smoke"
    IconColor=(R=160,G=160,B=160,A=100)
    ActivatedIconColor=(R=160,G=160,B=160,A=255)
    ArtilleryType=AT_Smoke
    ArtilleryRange=AR_OnMap
    IconMaterial=Texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=0,X2=63,Y2=63)
    GroupIndex=5
    bShouldShowOnCompass=false
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=SQUAD
    LifetimeSeconds=120
    HitVisibilityRadius=12070.4   // 200 meters
}
