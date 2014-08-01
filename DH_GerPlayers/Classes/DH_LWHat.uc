// *************************************************************************
//
//	***   LW ski cap   ***
//
// *************************************************************************

class DH_LWHat extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.LW_HG');
}

defaultproperties
{
     bIsHelmet=false
     Mesh=SkeletalMesh'gear_anm.ger_NCOlate_cap'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.LW_HG'
}
