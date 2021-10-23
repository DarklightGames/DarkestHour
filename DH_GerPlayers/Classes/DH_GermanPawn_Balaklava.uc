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

    FaceSkins(0)=Combiner'DHGermanCharactersTex.Heads.ger_face01Winter'
    FaceSkins(1)=Combiner'DHGermanCharactersTex.Heads.ger_face01Winter' // 02 is replaced with 01 to compensate for its removal in gloved pawn (gloved and winter pawns are commonly used for winter germans)
    FaceSkins(2)=Combiner'DHGermanCharactersTex.Heads.ger_face03Winter'
    FaceSkins(3)=Combiner'DHGermanCharactersTex.Heads.ger_face04Winter'
    FaceSkins(4)=Combiner'DHGermanCharactersTex.Heads.ger_face05Winter'
    FaceSkins(5)=Combiner'DHGermanCharactersTex.Heads.ger_face06Winter'
    FaceSkins(6)=Combiner'DHGermanCharactersTex.Heads.ger_face07Winter'
    FaceSkins(7)=Combiner'DHGermanCharactersTex.Heads.ger_face08Winter'
    FaceSkins(8)=Combiner'DHGermanCharactersTex.Heads.ger_face09Winter'
    FaceSkins(9)=Combiner'DHGermanCharactersTex.Heads.ger_face10Winter'
    FaceSkins(10)=Combiner'DHGermanCharactersTex.Heads.ger_face11Winter'
    FaceSkins(11)=Combiner'DHGermanCharactersTex.Heads.ger_face13Winter'
    FaceSkins(12)=Combiner'DHGermanCharactersTex.Heads.ger_face13Winter' //
    FaceSkins(13)=Combiner'DHGermanCharactersTex.Heads.ger_face14Winter' //
    FaceSkins(14)=Combiner'DHGermanCharactersTex.Heads.ger_face14Winter'

    ShovelClassName="DH_Equipment.DHShovelItem_German"
    BinocsClassName="DH_Equipment.DHBinocularsItemGerman"
}
