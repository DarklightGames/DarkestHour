//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHMapMarker_Enemy_Tank extends DHMapMarker_Enemy
    abstract;

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.tank'
    MarkerName="Enemy Tank"
    LifetimeSeconds=120
    SpottingConsoleCommand="SPEECH ENEMY 6"
}
