// *************************************************************************
//
//	***   DH_AmericanWinterWoolHat   ***
//
// *************************************************************************

class DH_AmericanWinterWoolHat extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_29thID_Headgear');
}

defaultproperties
{
     bIsHelmet=false
     Mesh=SkeletalMesh'dhgear_anm.USWinterWoolly_hat'
     Skins(0)=Texture'DHUSCharactersTex.Gear.Woolcap'
}
