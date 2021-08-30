//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_GermanPawn_Balaklava extends DHPawn;

defaultproperties
{
    Species=class'DH_Engine.DHSPECIES_Human'

    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_Soldat'
    Skins(0)=Texture'Characters_tex.ger_heads.ger_face01'
    Skins(1)=Texture'DHGermanCharactersTex.Heer.WH_1'

    bReversedSkinsSlots=true

    FaceSkins(0)=Combiner'DHGermanCharactersTex.Heads.ger_face01winter'
    FaceSkins(1)=Combiner'DHGermanCharactersTex.Heads.ger_face02winter'
    FaceSkins(2)=Combiner'DHGermanCharactersTex.Heads.ger_face03winter'
    FaceSkins(3)=Combiner'DHGermanCharactersTex.Heads.ger_face04winter'
    FaceSkins(4)=Combiner'DHGermanCharactersTex.Heads.ger_face05winter'
    FaceSkins(5)=Combiner'DHGermanCharactersTex.Heads.ger_face06winter'
    FaceSkins(6)=Combiner'DHGermanCharactersTex.Heads.ger_face07winter'
    FaceSkins(7)=Combiner'DHGermanCharactersTex.Heads.ger_face08winter'
    FaceSkins(8)=Combiner'DHGermanCharactersTex.Heads.ger_face09winter'
    FaceSkins(9)=Combiner'DHGermanCharactersTex.Heads.ger_face10winter'
    FaceSkins(10)=Combiner'DHGermanCharactersTex.Heads.ger_face11winter'
    FaceSkins(11)=Combiner'DHGermanCharactersTex.Heads.ger_face12winter'
    FaceSkins(12)=Combiner'DHGermanCharactersTex.Heads.ger_face13winter'
    FaceSkins(13)=Combiner'DHGermanCharactersTex.Heads.ger_face14winter'
    FaceSkins(14)=Combiner'DHGermanCharactersTex.Heads.ger_face15winter'

    ShovelClassName="DH_Equipment.DHShovelItem_German"
    BinocsClassName="DH_Equipment.DHBinocularsItemGerman"
}
