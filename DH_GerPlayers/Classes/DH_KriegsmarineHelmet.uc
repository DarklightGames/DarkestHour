// *************************************************************************
//
//  ***   Kriegsmarine Helmet   ***
//
// *************************************************************************

class DH_KriegsmarineHelmet extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.WK_HG_1');
}

defaultproperties
{
     Mesh=SkeletalMesh'gear_anm.ger_helmet'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.WK_HG_1'
}
