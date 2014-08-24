// *************************************************************************
//
//  ***   DH_AmericanHelmet82ndEMa   ***
//
// *************************************************************************

class DH_AmericanHelmet82ndEMa extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.US_Airborne_Helmet'
     Skins(0)=Texture'DHUSCharactersTex.Gear.US_EM_headgear'
}
