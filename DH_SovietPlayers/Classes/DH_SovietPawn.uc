//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_SovietPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_SovietPlayers.DH_Soviet'

    Mesh=SkeletalMesh'DHCharacters_anm.DH_rus_rifleman_tunic'
    Skins(0)=texture'DHSovietCharactersTex.RussianTunics.DH_rus_rifleman_tunic'
    Skins(1)=texture'Characters_tex.rus_heads.rus_face01'

    FaceSkins(0)=texture'Characters_tex.rus_heads.rus_face01'
    FaceSkins(1)=texture'Characters_tex.rus_heads.rus_face02'
    FaceSkins(2)=texture'Characters_tex.rus_heads.rus_face03'
    FaceSkins(3)=texture'Characters_tex.rus_heads.rus_face04'
    FaceSkins(4)=texture'Characters_tex.rus_heads.rus_face05'
    FaceSkins(5)=texture'Characters_tex.rus_heads.rus_face06'
    FaceSkins(6)=texture'Characters_tex.rus_heads.rus_face07'
    FaceSkins(7)=texture'Characters_tex.rus_heads.rus_face08'
    FaceSkins(8)=texture'Characters_tex.rus_heads.rus_face09'
    FaceSkins(9)=texture'Characters_tex.rus_heads.rus_face10'
    FaceSkins(10)=texture'Characters_tex.rus_heads.rus_face11'
    FaceSkins(11)=texture'Characters_tex.rus_heads.rus_face12'
    FaceSkins(12)=texture'Characters_tex.rus_heads.rus_face13'
    FaceSkins(13)=texture'Characters_tex.rus_heads.rus_face14'
    FaceSkins(14)=texture'Characters_tex.rus_heads.rus_face15'

    ShovelClassName="DH_Equipment.DHShovelItem_US" // TODO: make Soviet shovel
}
