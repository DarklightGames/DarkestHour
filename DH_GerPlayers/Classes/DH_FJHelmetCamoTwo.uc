//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_FJHelmetCamoTwo extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.FJ_HelmetCamo2');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.Ger_Fallsch_Helmet'
    Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.FJ_HelmetCamo2'
}
