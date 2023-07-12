//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USWinterPawn extends DH_AmericanPawn;

// Modified to remove unwanted inherited FaceSkins
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    FaceSkins.Length = 2;
}

defaultproperties
{
    Species=class'DH_USPlayers.DH_American'

    Mesh=SkeletalMesh'DHCharactersUS_anm.USWinter_GI'
    Skins(0)=Texture'DHUSCharactersTex.us_heads.WinterFace2'
    Skins(1)=Texture'DHUSCharactersTex.Winter.GI_Variant_Jacket'

// Same texture declared twice as this role has only one texture variant, necessary due to AmericanPawn inheritance
	BodySkins(0)=Texture'DHUSCharactersTex.Winter.GI_Variant_Jacket'
    BodySkins(1)=Texture'DHUSCharactersTex.Winter.GI_Variant_Jacket'

    bReversedSkinsSlots=true

    FaceSkins(0)=Texture'DHUSCharactersTex.us_heads.WinterFace1'
    FaceSkins(1)=Texture'DHUSCharactersTex.us_heads.WinterFace2'
}
