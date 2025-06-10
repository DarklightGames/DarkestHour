//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AmericanPawn extends DHPawn;

defaultproperties
{
    Species=Class'DH_American'

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


    ShovelClass=Class'DHShovelItem_US'
    bShovelHangsOnLeftHip=false // US shovel goes on the player's backpack
    BinocsClass=Class'DHBinocularsItemAllied'

    SmokeGrenadeClass=Class'DH_USSmokeGrenadeWeapon'
    ColoredSmokeGrenadeClass=Class'DH_RedSmokeWeapon'

    HealthFigureClass=Class'DHHealthFigure_USA'
}
