//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GermanPawn extends DHPawn;

defaultproperties
{
    Species=Class'DHSPECIES_Human'

    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_Soldat'
    Skins(0)=Texture'Characters_tex.ger_heads.ger_face01'
    Skins(1)=Texture'DHGermanCharactersTex.Heer.WH_1'

    bReversedSkinsSlots=true

    FaceSkins(0)=Texture'Characters_tex.ger_heads.ger_face01'
    FaceSkins(1)=Texture'Characters_tex.ger_heads.ger_face02'
    FaceSkins(2)=Texture'Characters_tex.ger_heads.ger_face03'
    FaceSkins(3)=Texture'Characters_tex.ger_heads.ger_face04'
    FaceSkins(4)=Texture'Characters_tex.ger_heads.ger_face05'
    FaceSkins(5)=Texture'Characters_tex.ger_heads.ger_face06'
    FaceSkins(6)=Texture'Characters_tex.ger_heads.ger_face07'
    FaceSkins(7)=Texture'Characters_tex.ger_heads.ger_face08'
    FaceSkins(8)=Texture'Characters_tex.ger_heads.ger_face09'
    FaceSkins(9)=Texture'Characters_tex.ger_heads.ger_face10'
    FaceSkins(10)=Texture'Characters_tex.ger_heads.ger_face11'
    FaceSkins(11)=Texture'Characters_tex.ger_heads.ger_face12'
    FaceSkins(12)=Texture'Characters_tex.ger_heads.ger_face13'
    FaceSkins(13)=Texture'Characters_tex.ger_heads.ger_face14'
    FaceSkins(14)=Texture'Characters_tex.ger_heads.ger_face15'

    ShovelClass=Class'DHShovelItem_German'
    BinocsClass=Class'DHBinocularsItemGerman'
    SmokeGrenadeClass=Class'DH_NebelGranate39Weapon'
    ColoredSmokeGrenadeClass=Class'DH_OrangeSmokeWeapon'

    HealthFigureClass=Class'DHHealthFigure_Germany'
}
