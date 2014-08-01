// *************************************************************************
//
//	***   SS ski cap Italian Camo   ***
//
// *************************************************************************

class DH_12SSCap extends DH_Headgear;

#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.SS_HG_2');
}

defaultproperties
{
     bIsHelmet=false
     Mesh=SkeletalMesh'gear_anm.ger_NCOlate_cap'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.SS_HG_3'
}
