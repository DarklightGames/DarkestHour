//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_LWHelmet extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(material'DHGermanCharactersTex.GerHeadGear.LW_HG');
}

defaultproperties
{
    Mesh=SkeletalMesh'gear_anm.ger_helmet'
    Skins(0)=texture'DHGermanCharactersTex.GerHeadgear.LW_HG'
}
