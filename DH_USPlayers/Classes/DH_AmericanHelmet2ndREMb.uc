//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AmericanHelmet2ndREMb extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.US_GI_Helmet'
     Skins(0)=Texture'DHUSCharactersTex.Gear.US2R_EM_headgear2'
}
