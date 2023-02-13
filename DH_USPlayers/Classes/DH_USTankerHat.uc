//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USTankerHat extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.Gear.US_Tanker_Headgear');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'dhgear_anm.US_TankerHat'
    Skins(0)=Texture'DHUSCharactersTex.Gear.US_Tanker_Headgear'
    Skins(1)=Texture'DH_GUI_Tex.Menu.DHSectionTopper'
}
