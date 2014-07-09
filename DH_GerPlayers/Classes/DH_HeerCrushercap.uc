// *************************************************************************
//
//	***   Heer crushercap   ***
//
// *************************************************************************

class DH_HeerCrushercap extends DH_Headgear;


#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Material'DHGermanCharactersTex.RMFGerHeadgear.ger_Heer_crashcap');
}

defaultproperties
{
     bIsHelmet=False
     Mesh=SkeletalMesh'DH_RMFHeadGear.ger_crashcap2'
     Skins(0)=Texture'DHGermanCharactersTex.RMFGerHeadgear.ger_heer_crashcap'
}
