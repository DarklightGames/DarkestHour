//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SSHelmetNoCover extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'GermanCharactersTex.WSS.WSSParkaCam1');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.Ger_HelmetNC'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.LW_HG2'
}
