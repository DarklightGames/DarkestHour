//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_GermanPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_Engine.DHSPECIES_Human'

    Mesh=SkeletalMesh'DHCharacters_anm.Ger_Soldat'
    Skins(0)=Texture'Characters_tex.ger_heads.ger_face01'
    Skins(1)=Texture'DHGermanCharactersTex.Heer.WH_1'

    bReversedSkinsSlots=true

    FaceSkins(0)=Texture'DH_Halloween_Masks.ger_heads.ger_face01'
    FaceSkins(1)=Texture'DH_Halloween_Masks.ger_heads.ger_face02'
    FaceSkins(2)=Texture'DH_Halloween_Masks.ger_heads.ger_face03'
    FaceSkins(3)=Texture'DH_Halloween_Masks.ger_heads.ger_face04'
    FaceSkins(4)=Texture'DH_Halloween_Masks.ger_heads.ger_face05'

    ShovelClassName="DH_Equipment.DHShovelItem_German"
    BinocsClassName="DH_Equipment.DHBinocularsItemGerman"
}
