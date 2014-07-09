// *************************************************************************
//
//	***   DH_AmericanHelmet82ndOfficera   ***
//
// *************************************************************************

class DH_AmericanHelmet82ndOfficera extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.US_Airborne_Helmet'
     Skins(0)=Texture'DHUSCharactersTex.Gear.US_Officer_headgear'
}
