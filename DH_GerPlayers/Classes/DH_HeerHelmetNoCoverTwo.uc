// *************************************************************************
//
//  ***   Heer Helmet with camo cover   ***
//
// *************************************************************************

class DH_HeerHelmetNoCoverTwo extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'GermanCharactersTex.Heer.HeerParkaCam1');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.Ger_HelmetNC'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.LW_HG2'
}
