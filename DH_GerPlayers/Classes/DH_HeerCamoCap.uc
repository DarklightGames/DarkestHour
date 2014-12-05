//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HeerCamoCap extends DH_Headgear;

#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.WH_HG_1');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'gear_anm.ger_NCOlate_cap'
    Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.WH_HG_1'
}
