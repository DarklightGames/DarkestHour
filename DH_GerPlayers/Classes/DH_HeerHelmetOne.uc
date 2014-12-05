//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HeerHelmetOne extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.WH_HG_1');
}

defaultproperties
{
    Mesh=SkeletalMesh'gear_anm.ger_helmet'
    Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.WH_HG_1'
}
