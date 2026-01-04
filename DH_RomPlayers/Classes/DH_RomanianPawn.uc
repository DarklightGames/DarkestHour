//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RomanianPawn extends DHPawn;

defaultproperties
{
    Species=Class'DH_Romanian'

    Mesh=SkeletalMesh'DHCharactersROM_anm.Rom_Rifleman'
    Skins(0)=Texture'DHRomanianCharactersTex.romanian_tunic_summer.summerTunic_puttees'
    Skins(1)=Texture'DHRomanianCharactersTex.romanian_face.Face3'
    Skins(2)=Texture'DHRomanianCharactersTex.romanian_gear.gear1'
    Skins(3)=Texture'DHRomanianCharactersTex.romanian_rank_summer.SummerPrivateRank'

    bReversedSkinsSlots=false

    FaceSkins(0)=Texture'DHRomanianCharactersTex.romanian_face.Face1'
    FaceSkins(1)=Texture'DHRomanianCharactersTex.romanian_face.Face3'
    FaceSkins(2)=Texture'DHRomanianCharactersTex.romanian_face.Face4'
    FaceSkins(3)=Texture'DHRomanianCharactersTex.romanian_face.Face5'
    FaceSkins(4)=Texture'DHRomanianCharactersTex.romanian_face.Face6'
    FaceSkins(5)=Texture'DHRomanianCharactersTex.romanian_face.Face7'

    // TODO: replace all this
    ShovelClass=Class'DHShovelItem_German'
    BinocsClass=Class'DHBinocularsItemItalian'
    //SmokeGrenadeClass=Class'DH_SRCMMod35SmokeGrenadeWeapon'

    HealthFigureClass=Class'DHHealthFigure_Romania'
}
