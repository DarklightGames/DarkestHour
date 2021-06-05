//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_LWHat extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.LW_HG');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'gear_anm.ger_NCOlate_cap'
    Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.LW_HG'
}
