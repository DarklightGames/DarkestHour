//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHMapMarker_Enemy_Infantry extends DHMapMarker_Enemy
    abstract;

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.infantry'
    MarkerName="Enemy Infantry"
    LifetimeSeconds=120
    SpottingConsoleCommand="SPEECH ENEMY 0"
}

