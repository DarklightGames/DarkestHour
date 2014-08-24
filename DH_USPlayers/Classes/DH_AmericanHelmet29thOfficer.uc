// *************************************************************************
//
//  ***   DH_AmericanHelmet29thOfficer   ***
//
// *************************************************************************

class DH_AmericanHelmet29thOfficer extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.US_GI_Helmet'
     Skins(0)=Texture'DHUSCharactersTex.Gear.US29ID_Officer_headgear'
}
