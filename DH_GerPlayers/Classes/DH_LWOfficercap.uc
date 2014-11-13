//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_LWOfficercap extends DH_Headgear;

#exec OBJ LOAD FILE=..\Textures\DHGermanCharactersTex.utx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.RMFGerHeadgear.ger_LW_crashcap');
}

defaultproperties
{
     bIsHelmet=false
     Mesh=SkeletalMesh'DH_RMFHeadGear.ger_crashcap1'
     Skins(0)=Texture'DHGermanCharactersTex.RMFGerHeadgear.ger_LW_crashcap'
}
