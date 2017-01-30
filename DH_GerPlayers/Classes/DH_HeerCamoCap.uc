//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_HeerCamoCap extends DHHeadgear;

#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(material'DHGermanCharactersTex.GerHeadGear.WH_HG_1');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'gear_anm.ger_NCOlate_cap'
    Skins(0)=texture'DHGermanCharactersTex.GerHeadgear.WH_HG_1'
}
