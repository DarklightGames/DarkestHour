//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_AmericanHelmet82ndNCOb extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.US_Airborne_Helmet2'
    Skins(0)=Texture'DHUSCharactersTex.Gear.US_NCO_headgear2'
}
