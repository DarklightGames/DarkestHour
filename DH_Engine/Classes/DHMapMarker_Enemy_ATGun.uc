//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHMapMarker_Enemy_ATGun extends DHMapMarker_Enemy
    abstract;

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    MarkerName="Enemy AT Gun"
    LifetimeSeconds=300
    SpottingConsoleCommand="SPEECH ENEMY 8"
}

