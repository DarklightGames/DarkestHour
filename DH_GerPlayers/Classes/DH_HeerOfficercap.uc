//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_HeerOfficercap extends DHHeadgear;

#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(material'DHGermanCharactersTex.RMFGerHeadgear.ger_Heer_crashcap');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'DH_RMFHeadGear.ger_crashcap1'
    Skins(0)=texture'DHGermanCharactersTex.RMFGerHeadgear.ger_heer_crashcap'
}
