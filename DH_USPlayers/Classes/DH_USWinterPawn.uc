//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_USWinterPawn extends DHPawn;

// Modified to remove unwanted inherited FaceSkins
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    FaceSkins.Length = 2;
}

defaultproperties
{
    Mesh=SkeletalMesh'DHCharacters_anm.USWinter_GI'
    Skins(0)=texture'DHUSCharactersTex.us_heads.WinterFace2'
    Skins(1)=texture'DHUSCharactersTex.Winter.GI_Variant_Jacket'

    FaceSkins(0)=texture'DHUSCharactersTex.us_heads.WinterFace1'
    FaceSkins(1)=texture'DHUSCharactersTex.us_heads.WinterFace2'
}
