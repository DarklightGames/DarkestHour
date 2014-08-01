// *************************************************************************
//
//	***   DH_BritishRMCommandoBeret   ***
//
// *************************************************************************

class DH_BritishRMCommandoBeret extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_tanker_Headgear');
}

defaultproperties
{
     bIsHelmet=false
     Mesh=SkeletalMesh'dhgear_anm.Brit_Beret'
     Skins(0)=Texture'DHBritishCharactersTex.Headgear.Brit_Commando_beret'
     Skins(1)=Texture'DHBritishCharactersTex.Headgear.RMCommando_Badge'
}
