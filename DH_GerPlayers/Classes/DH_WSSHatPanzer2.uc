//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WSSHatPanzer2 extends DH_Headgear;


static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.SS_HG_1');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'gear_anm.ger_NCOlate_cap'
    Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.SS_HG_1'
}
