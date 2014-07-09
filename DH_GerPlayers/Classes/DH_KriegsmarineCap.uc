// *************************************************************************
//
//	***   Kriegsmarine cap   ***
//
// *************************************************************************

class DH_KriegsmarineCap extends DH_Headgear;

#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.WH_HG_1');
}

defaultproperties
{
     bIsHelmet=False
     Mesh=SkeletalMesh'gear_anm.ger_tankercap_cap'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.WK_HG_1'
}
