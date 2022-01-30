//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_SSHelmetTwo extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.SS_HG_2');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.ger_helmet_alt'
    Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.SS_HG_2'
}
