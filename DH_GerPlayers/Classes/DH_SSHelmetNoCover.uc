//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_SSHelmetNoCover extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(material'GermanCharactersTex.WSS.WSSParkaCam1');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.Ger_HelmetNC'
    Skins(0)=texture'DHGermanCharactersTex.GerHeadgear.LW_HG2'
}
