//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Halloween Special 2020

class DH_ZombiePawn extends DHPawn;

defaultproperties
{
    Species=Class'DHSPECIES_Human'

    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_Soldat'

    Skins(0)=Texture'DHEventCharactersTex.ger_face01_zombie01'
    Skins(1)=Texture'DHEventCharactersTex.wh_4_zombie01'

    bReversedSkinsSlots=true

    FaceSkins(0)=Texture'DHEventCharactersTex.ger_face01_zombie01'
    FaceSkins(1)=Texture'DHEventCharactersTex.ger_face01_zombie02'
    FaceSkins(2)=Texture'DHEventCharactersTex.ger_face02_zombie01'
    FaceSkins(3)=Texture'DHEventCharactersTex.ger_face03_zombie01'
    FaceSkins(4)=Texture'DHEventCharactersTex.ger_face04_zombie01'
    FaceSkins(5)=Texture'DHEventCharactersTex.ger_face06_zombie01'
    FaceSkins(6)=Texture'DHEventCharactersTex.ger_face07_zombie01'
    FaceSkins(7)=Texture'DHEventCharactersTex.ger_face09_zombie01'
    FaceSkins(8)=Texture'DHEventCharactersTex.ger_face10_zombie01'
    FaceSkins(10)=Texture'DHEventCharactersTex.ger_face12_zombie01'
    FaceSkins(11)=Texture'DHEventCharactersTex.ger_face13_zombie01'
    FaceSkins(12)=Texture'DHEventCharactersTex.ger_face14_zombie01'
    FaceSkins(13)=Texture'DHEventCharactersTex.ger_face15_zombie01'

    ShovelClass=Class'DHShovelItem_German'
    BinocsClass=Class'DHBinocularsItemGerman'

    bAlwaysSeverBodyparts=true

    HealthFigureClass=Class'DHHealthFigure_Germany'
}
