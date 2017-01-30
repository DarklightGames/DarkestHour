//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJHelmet2 extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(material'DHGermanCharactersTex.GerHeadGear.FJ_Helmet2');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.Ger_Fallsch_Helmet'
    Skins(0)=texture'DHGermanCharactersTex.GerHeadgear.FJ_Helmet2'
}
