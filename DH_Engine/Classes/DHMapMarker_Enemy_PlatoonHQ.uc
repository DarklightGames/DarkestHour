//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHMapMarker_Enemy_PlatoonHQ extends DHMapMarker_Enemy
    abstract;

static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return GRI != none && GRI.bAreConstructionsEnabled;
}

defaultproperties
{
    IconMaterial=Texture'DH_GUI_tex.DeployMenu.PlatoonHQ'
    MarkerName="Enemy HQ"
}

