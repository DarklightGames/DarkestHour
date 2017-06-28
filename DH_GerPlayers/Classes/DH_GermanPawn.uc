//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_GermanPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_Engine.DHSPECIES_Human'

    Mesh=SkeletalMesh'DHCharacters_anm.Ger_Soldat'
    Skins(0)=texture'Characters_tex.ger_heads.ger_face01'
    Skins(1)=texture'DHGermanCharactersTex.Heer.WH_1'

    bReversedSkinsSlots=true

    FaceSkins(0)=texture'Characters_tex.ger_heads.ger_face01'
    FaceSkins(1)=texture'Characters_tex.ger_heads.ger_face02'
    FaceSkins(2)=texture'Characters_tex.ger_heads.ger_face03'
    FaceSkins(3)=texture'Characters_tex.ger_heads.ger_face04'
    FaceSkins(4)=texture'Characters_tex.ger_heads.ger_face05'
    FaceSkins(5)=texture'Characters_tex.ger_heads.ger_face06'
    FaceSkins(6)=texture'Characters_tex.ger_heads.ger_face07'
    FaceSkins(7)=texture'Characters_tex.ger_heads.ger_face08'
    FaceSkins(8)=texture'Characters_tex.ger_heads.ger_face09'
    FaceSkins(9)=texture'Characters_tex.ger_heads.ger_face10'
    FaceSkins(10)=texture'Characters_tex.ger_heads.ger_face11'
    FaceSkins(11)=texture'Characters_tex.ger_heads.ger_face12'
    FaceSkins(12)=texture'Characters_tex.ger_heads.ger_face13'
    FaceSkins(13)=texture'Characters_tex.ger_heads.ger_face14'
    FaceSkins(14)=texture'Characters_tex.ger_heads.ger_face15'

    ShovelClassName="DH_Equipment.DHShovelItem_German"
}
