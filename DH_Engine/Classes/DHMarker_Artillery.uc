//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMarker_Artillery extends DHMarker abstract;

var string Type;

defaultproperties
{
    MarkerName="Generic artillery marker"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.Attack'
    IconColor=(R=204,G=255,B=0,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    LifetimeSeconds=30
}
