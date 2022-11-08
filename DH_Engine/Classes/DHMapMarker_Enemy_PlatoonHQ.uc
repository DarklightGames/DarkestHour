//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHMapMarker_Enemy_PlatoonHQ extends DHMapMarker_Enemy
    abstract;

static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return GRI != none && GRI.bAreConstructionsEnabled;
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.platoon_hq'
    MarkerName="Enemy HQ"
    LifetimeSeconds=600
    SpottingConsoleCommand="SPEECH SUPPORT 6"
}

