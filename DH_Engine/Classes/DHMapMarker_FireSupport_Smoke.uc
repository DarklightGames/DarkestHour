//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_Smoke extends DHMapMarker_FireSupport_OnMap
    abstract;

defaultproperties
{
    MarkerName="Fire Support (smoke)"
    TypeName="Smoke"
    IconMaterial=Texture'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=0,X2=63,Y2=63)
    IconColor=(R=220,G=220,B=220,A=255) // gray
}
