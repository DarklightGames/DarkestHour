//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_AmericanHelmet2ndRNCOb extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.US_GI_Helmet'
    Skins(0)=Texture'DHUSCharactersTex.Gear.US2R_NCO_headgear2'
}
