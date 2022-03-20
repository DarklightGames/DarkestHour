//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_AmericanHelmet502101stEMa extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.US_Airborne_Helmet'
    Skins(0)=Texture'DHUSCharactersTex.Gear.US101AB502EM_headgear'
}
