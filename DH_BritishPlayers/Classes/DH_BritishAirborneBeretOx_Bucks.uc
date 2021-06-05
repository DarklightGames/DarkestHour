//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_BritishAirborneBeretOx_Bucks extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_tanker_Headgear');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'dhgear_anm.Brit_Beret'
    Skins(0)=Texture'DHBritishCharactersTex.Headgear.Brit_para_beret'
    Skins(1)=Texture'DHBritishCharactersTex.Headgear.OxBucks_Badge'
}
