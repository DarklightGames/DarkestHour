//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_WSSOfficercap extends DHHeadgear;

#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.RMFGerHeadgear.ger_ss_crashcap');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'DH_RMFHeadGear.ger_crashcap1'
    Skins(0)=Texture'DHGermanCharactersTex.RMFGerHeadgear.ger_ss_crashcap'
}
