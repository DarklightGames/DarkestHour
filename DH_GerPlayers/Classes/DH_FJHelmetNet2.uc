//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJHelmetNet2 extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.FJ_HelmetNet2');
}

defaultproperties
{
     Mesh=SkeletalMesh'dhgear_anm.Ger_Fallsch_Helmet'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.FJ_HelmetNet2'
}
