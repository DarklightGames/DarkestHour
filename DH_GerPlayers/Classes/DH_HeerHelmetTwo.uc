// *************************************************************************
//
//	***   Heer Helmet 2 with camo paint   ***
//
// *************************************************************************

class DH_HeerHelmetTwo extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.WH_HG_2');
}

defaultproperties
{
     Mesh=SkeletalMesh'gear_anm.ger_helmet'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.WH_HG_2'
}
