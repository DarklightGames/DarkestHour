// *************************************************************************
//
//  ***   Heer Helmet with snow cover   ***
//
// *************************************************************************

class DH_HeerHelmetSnow extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'GermanCharactersTex.Heer.HeerParkaSnow1');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.Ger_HelmetCover'
     Skins(0)=Texture'DHGermanCharactersTex.Heer.HeerParkaSnow1'
}
