//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_BarrageRequest extends DHMapMarker_FireSupport
    abstract;

defaultproperties
{
    MarkerName="Barrage Request"
    TypeName="HE"

    IconMaterial=Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=64,X2=63,Y2=127)
    IconColor=(R=255,G=255,B=255,A=128)

    Scope=PERSONAL
    OverwritingRule=UNIQUE
}
