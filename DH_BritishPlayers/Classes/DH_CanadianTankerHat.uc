//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_CanadianTankerHat extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(material'DHUSCharactersTex.Gear.US_tanker_Headgear');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'dhgear_anm.Brit_Tanker_Hat'
    Skins(0)=texture'DH_GUI_Tex.Menu.DHSectionTopper'
    Skins(1)=texture'DHBritishCharactersTex.Headgear.Brit_tanker_beret'
    Skins(2)=texture'DHCanadianCharactersTex.Headgear.RoyalCanadianHussars_Badge'
}
