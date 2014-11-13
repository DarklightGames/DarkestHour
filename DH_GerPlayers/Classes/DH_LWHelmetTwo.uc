//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_LWHelmetTwo extends DH_Headgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.LW_HG2');
}

defaultproperties
{
     Mesh=SkeletalMesh'gear_anm.ger_helmet'
     Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.LW_HG2'
}
