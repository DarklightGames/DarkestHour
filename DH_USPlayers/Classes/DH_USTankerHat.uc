//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USTankerHat extends DHHeadgear;

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DHUSCharactersTex.US_Tanker_Headgear');
}

defaultproperties
{
    bIsHelmet=false
    Mesh=SkeletalMesh'dhgear_anm.US_TankerHat'
    Skins(0)=Texture'DHUSCharactersTex.US_Tanker_Headgear'
    Skins(1)=Texture'DH_GUI_Tex.DHSectionTopper'
}
