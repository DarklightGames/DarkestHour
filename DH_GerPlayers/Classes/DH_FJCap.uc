// *************************************************************************
//
//	***  FJ little boat   ***
//
// *************************************************************************

class DH_FJCap extends DH_Headgear;

// Current cap doesn't fit new FJ model, so this is temporarily displaying as a grey helmet instead

static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadgear.LW_HG');
//	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadgear.FJ_Helmet1');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.Ger_Fallsch_Helmet'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.FJ_Helmet1'
}
