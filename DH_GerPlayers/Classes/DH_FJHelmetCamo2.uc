//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJHelmetCamo2 extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(material'DHGermanCharactersTex.GerHeadGear.FJ_HelmetCamo2');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.Ger_Fallsch_Helmet'
    Skins(0)=texture'DHGermanCharactersTex.GerHeadgear.FJ_HelmetCamo2'
}
