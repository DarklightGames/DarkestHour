//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SSHelmetCover extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(material'GermanCharactersTex.WSS.WSSParkaCam1');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.Ger_HelmetCover'
    Skins(0)=texture'DHGermanCharactersTex.WSS.WSSParkaCam1'
}
