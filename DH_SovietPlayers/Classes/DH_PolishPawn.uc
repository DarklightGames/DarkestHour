//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PolishPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_SovietPlayers.DH_Polish'

    Mesh=SkeletalMesh'DHCharactersSOV_anm.DH_rus_rifleman_tunic'
    Skins(0)=Texture'DHSovietCharactersTex.RussianTunics.DH_rus_rifleman_tunic'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face08'

    FaceSkins(0)=Texture'Characters_tex.rus_heads.rus_face08' //removed the non-slavic looking face
    FaceSkins(1)=Texture'Characters_tex.rus_heads.rus_face02'
    FaceSkins(2)=Texture'Characters_tex.rus_heads.rus_face03'
    FaceSkins(3)=Texture'Characters_tex.rus_heads.rus_face04'
    FaceSkins(4)=Texture'Characters_tex.rus_heads.rus_face05'
    FaceSkins(5)=Texture'Characters_tex.rus_heads.rus_face06'
    FaceSkins(6)=Texture'Characters_tex.rus_heads.rus_face07'
    FaceSkins(7)=Texture'Characters_tex.rus_heads.rus_face08'
    FaceSkins(8)=Texture'Characters_tex.rus_heads.rus_face09'
    FaceSkins(9)=Texture'Characters_tex.rus_heads.rus_face10'
    FaceSkins(10)=Texture'Characters_tex.rus_heads.rus_face11'
    FaceSkins(11)=Texture'Characters_tex.rus_heads.rus_face12'
    FaceSkins(12)=Texture'Characters_tex.rus_heads.rus_face13'
    FaceSkins(13)=Texture'Characters_tex.rus_heads.rus_face14'
    FaceSkins(14)=Texture'Characters_tex.rus_heads.rus_face15'

    ShovelClass=class'DH_Equipment.DHShovelItem_Russian'
    BinocsClass=class'DH_Equipment.DHBinocularsItemSoviet'
    SmokeGrenadeClass=class'DH_Equipment.DH_RDG1SmokeGrenadeWeapon'
}
