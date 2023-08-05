//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AmericanPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_USPlayers.DH_American'

    Mesh=SkeletalMesh'DHCharactersUS_anm.US_GI'
    Skins(0)=Texture'DHUSCharactersTex.us_heads.US_AB_Face2'
    Skins(1)=Texture'DHUSCharactersTex.GI.GI_1'
	
	BodySkins(0)=Texture'DHUSCharactersTex.GI.GI_1'
    BodySkins(1)=Texture'DHUSCharactersTex.GI.GI_2'

    bReversedSkinsSlots=true

    FaceSkins(0)=Texture'DHUSCharactersTex.us_heads.US_AB_Face1'
    FaceSkins(1)=Texture'DHUSCharactersTex.us_heads.US_AB_Face2'
    FaceSkins(2)=Texture'DHUSCharactersTex.us_heads.US_AB_Face3'
    FaceSkins(3)=Texture'DHUSCharactersTex.us_heads.US_AB_Face4'
    FaceSkins(4)=Texture'DHUSCharactersTex.us_heads.US_AB_Face5'


    ShovelClass=class'DH_Equipment.DHShovelItem_US'
    bShovelHangsOnLeftHip=false // US shovel goes on the player's backpack
    BinocsClass=class'DH_Equipment.DHBinocularsItemAllied'

    SmokeGrenadeClass=class'DH_Equipment.DH_USSmokeGrenadeWeapon'
    ColoredSmokeGrenadeClass=class'DH_Equipment.DH_RedSmokeWeapon'
}
