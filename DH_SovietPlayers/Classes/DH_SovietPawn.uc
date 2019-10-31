//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SovietPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_SovietPlayers.DH_Soviet'

    Mesh=SkeletalMesh'DHCharacters_anm.DH_rus_rifleman_tunic'
    Skins(0)=Texture'DHSovietCharactersTex.RussianTunics.DH_rus_rifleman_tunic'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face01'

    FaceSkins(0)=Texture'DH_Halloween_Masks.rus_heads.rus_face01'
    FaceSkins(1)=Texture'DH_Halloween_Masks.rus_heads.rus_face02'
    FaceSkins(2)=Texture'DH_Halloween_Masks.rus_heads.rus_face03'
    FaceSkins(3)=Texture'DH_Halloween_Masks.rus_heads.rus_face04'
    FaceSkins(4)=Texture'DH_Halloween_Masks.rus_heads.rus_face05'

    ShovelClassName="DH_Equipment.DHShovelItem_Russian"
    BinocsClassName="DH_Equipment.DHBinocularsItemSoviet"
}
