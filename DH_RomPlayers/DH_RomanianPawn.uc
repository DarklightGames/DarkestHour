//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RomanianPawn extends DHPawn;

defaultproperties
{
    Species=Class'DH_Romanian'

    Mesh=SkeletalMesh'DHCharactersITA_anm.ita_livorno_rifleman'
    Skins(0)=Texture'DHItalianCharactersTex.ita_livorno_corporal'
    Skins(1)=Texture'DHItalianCharactersTex.ita_face01'

    FaceSkins(0)=Texture'DHItalianCharactersTex.ita_face01'
    FaceSkins(1)=Texture'DHItalianCharactersTex.ita_face02'
    FaceSkins(2)=Texture'DHItalianCharactersTex.ita_face03'
    FaceSkins(3)=Texture'DHItalianCharactersTex.ita_face04'
    FaceSkins(4)=Texture'DHItalianCharactersTex.ita_face05'
    FaceSkins(5)=Texture'DHItalianCharactersTex.ita_face06'
    FaceSkins(6)=Texture'DHItalianCharactersTex.ita_face07'
    FaceSkins(7)=Texture'DHItalianCharactersTex.ita_face08'
    FaceSkins(8)=Texture'DHItalianCharactersTex.ita_face09'
    FaceSkins(9)=Texture'DHItalianCharactersTex.ita_face10'
    FaceSkins(10)=Texture'DHItalianCharactersTex.ita_face11'

    // TODO: replace all this
    ShovelClass=Class'DHShovelItem_Italian'
    BinocsClass=Class'DHBinocularsItemItalian'
    SmokeGrenadeClass=Class'DH_SRCMMod35SmokeGrenadeWeapon'

    HealthFigureClass=Class'DHHealthFigure_Italy'
}
