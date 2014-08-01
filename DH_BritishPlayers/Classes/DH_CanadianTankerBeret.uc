// *************************************************************************
//
//	***   DH_BritishTankerHat   ***
//
// *************************************************************************

class DH_CanadianTankerBeret extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_tanker_Headgear');
}

defaultproperties
{
     bIsHelmet=false
     Mesh=SkeletalMesh'dhgear_anm.Brit_Beret'
     Skins(0)=Texture'DHBritishCharactersTex.Headgear.Brit_tanker_beret'
     Skins(1)=Texture'DHCanadianCharactersTex.Headgear.RoyalCanadianHussars_Badge'
}
