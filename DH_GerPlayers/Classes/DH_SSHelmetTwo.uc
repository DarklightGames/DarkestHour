// *************************************************************************
//
//	***   SS Helmet 2 with camo cover   ***
//
// *************************************************************************

class DH_SSHelmetTwo extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.SS_HG_2');
}

defaultproperties
{
     Mesh=SkeletalMesh'gear_anm.ger_helmet'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.SS_HG_2'
}
