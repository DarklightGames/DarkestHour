// *************************************************************************
//
//  ***   Heer Helmet 3    ***
//
// *************************************************************************

class DH_HeerHelmetThree extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.WH_HG_3');
}

defaultproperties
{
     Mesh=SkeletalMesh'gear_anm.ger_helmet'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.WH_HG_3'
}
