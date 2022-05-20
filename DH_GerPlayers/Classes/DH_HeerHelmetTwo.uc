//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_HeerHelmetTwo extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'DHGermanCharactersTex.GerHeadGear.WH_HG_2');
}

defaultproperties
{
    Mesh=SkeletalMesh'dhgear_anm.Ger_Helmet_alt'
    Skins(0)=Texture'DHGermanCharactersTex.GerHeadgear.WH_HG_2'
}
