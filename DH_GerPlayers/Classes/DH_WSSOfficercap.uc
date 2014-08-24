// *************************************************************************
//
//  ***   SS officer cap   ***
//
// *************************************************************************

class DH_WSSOfficercap extends DH_Headgear;

#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.RMFGerHeadgear.ger_ss_crashcap');
}

defaultproperties
{
     bIsHelmet=false
     Mesh=SkeletalMesh'DH_RMFHeadGear.ger_crashcap1'
     Skins(0)=Texture'DHGermanCharactersTex.RMFGerHeadgear.ger_ss_crashcap'
}
