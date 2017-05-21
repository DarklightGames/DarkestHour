//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_AmericanPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_USPlayers.DH_American'

    Mesh=SkeletalMesh'DHCharacters_anm.US_GI'
    Skins(0)=texture'DHUSCharactersTex.us_heads.US_AB_Face2'
    Skins(1)=texture'DHUSCharactersTex.GI.GI_1'

    bReversedSkinsSlots=true

    FaceSkins(0)=texture'DHUSCharactersTex.us_heads.US_AB_Face1'
    FaceSkins(1)=texture'DHUSCharactersTex.us_heads.US_AB_Face2'
    FaceSkins(2)=texture'DHUSCharactersTex.us_heads.US_AB_Face3'
    FaceSkins(3)=texture'DHUSCharactersTex.us_heads.US_AB_Face4'
    FaceSkins(4)=texture'DHUSCharactersTex.us_heads.US_AB_Face5'
}
