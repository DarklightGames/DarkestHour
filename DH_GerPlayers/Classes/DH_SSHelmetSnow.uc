// *************************************************************************
//
//	***   SS Helmet with snow cover   ***
//
// *************************************************************************

class DH_SSHelmetSnow extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'GermanCharactersTex.WSS.WSSParkaSnow1');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.Ger_HelmetCover'
     Skins(0)=Texture'DHGermanCharactersTex.WSS.WSSParkaSnow1'
}
