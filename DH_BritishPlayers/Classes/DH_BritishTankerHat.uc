//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishTankerHat extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_tanker_Headgear');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'dhgear_anm.Brit_Tanker_Hat'
    Skins(0)=Texture'DH_GUI_Tex.Menu.DHSectionTopper'
    Skins(1)=Texture'DHBritishCharactersTex.Headgear.Brit_tanker_beret'
    Skins(2)=Texture'DHBritishCharactersTex.Headgear.Tanker_Badge'
}
