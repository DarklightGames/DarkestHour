//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZPawn_SovGloves extends DH_CzechPawn;

// this is only for soviet gloves. Most cs winter roles are gonna have british gloves which will be implemented differently

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.CSAZ_tunic'
    Skins(1)=Texture'DHSovietCharactersTex.DH_CSAZ_tunicG'
    Skins(0)=Texture'Characters_tex.rus_face04'

    FaceSkins(0)=Combiner'DHSovietCharactersTex.sov_face02gloves' //
    FaceSkins(1)=Combiner'DHSovietCharactersTex.sov_face02gloves'
    FaceSkins(2)=Combiner'DHSovietCharactersTex.sov_face03gloves'
    FaceSkins(3)=Combiner'DHSovietCharactersTex.sov_face04gloves'
    FaceSkins(4)=Combiner'DHSovietCharactersTex.sov_face05gloves'
    FaceSkins(5)=Combiner'DHSovietCharactersTex.sov_face07gloves' //
    FaceSkins(6)=Combiner'DHSovietCharactersTex.sov_face07gloves'
    FaceSkins(7)=Combiner'DHSovietCharactersTex.sov_face09gloves' //
    FaceSkins(8)=Combiner'DHSovietCharactersTex.sov_face09gloves'
    FaceSkins(9)=Combiner'DHSovietCharactersTex.sov_face10gloves'
    FaceSkins(10)=Combiner'DHSovietCharactersTex.sov_face11gloves'
    FaceSkins(11)=Combiner'DHSovietCharactersTex.sov_face12gloves'
    FaceSkins(12)=Combiner'DHSovietCharactersTex.sov_face14gloves' //
    FaceSkins(13)=Combiner'DHSovietCharactersTex.sov_face14gloves'
    FaceSkins(14)=Combiner'DHSovietCharactersTex.sov_face15gloves'

    ShovelClass=Class'DHShovelItem_Russian'
    BinocsClass=Class'DHBinocularsItemSoviet'
}
