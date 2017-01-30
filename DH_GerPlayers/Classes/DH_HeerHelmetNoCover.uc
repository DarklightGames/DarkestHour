//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_HeerHelmetNoCover extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(material'GermanCharactersTex.Heer.HeerParkaCam1');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.Ger_HelmetNC'
    Skins(0)=texture'DHGermanCharactersTex.GerHeadgear.WH_HG_2'
}
