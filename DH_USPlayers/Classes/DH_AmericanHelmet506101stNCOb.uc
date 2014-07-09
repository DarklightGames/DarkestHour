// *************************************************************************
//
//	***  DH_AmericanHelmet506101stNCOb   ***
//
// *************************************************************************

class DH_AmericanHelmet506101stNCOb extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.US_Airborne_Helmet2'
     Skins(0)=Texture'DHUSCharactersTex.Gear.US101AB506NCO_headgear2'
}
