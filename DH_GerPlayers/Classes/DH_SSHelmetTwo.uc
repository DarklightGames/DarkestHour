//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SSHelmetTwo extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.SS_HG_2');
}

defaultproperties
{
    Mesh=SkeletalMesh'gear_anm.ger_helmet'
    Skins(0)=texture'DHGermanCharactersTex.GerHeadgear.SS_HG_2'
}
