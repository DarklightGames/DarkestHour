// *************************************************************************
//
//  ***   DH_AmericanHelmet1stEMb   ***
//
// *************************************************************************

class DH_AmericanHelmet1stEMb extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.US_GI_Helmet'
     Skins(0)=Texture'DHUSCharactersTex.Gear.US_EM_headgear2'
}
