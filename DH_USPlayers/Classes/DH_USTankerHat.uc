//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USTankerHat extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(material'DHUSCharactersTex.Gear.US_Tanker_Headgear');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'dhgear_anm.US_TankerHat'
    Skins(0)=texture'DHUSCharactersTex.Gear.US_Tanker_Headgear'
    Skins(1)=texture'DH_GUI_Tex.Menu.DHSectionTopper'
}
