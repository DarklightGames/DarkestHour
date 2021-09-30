//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_SovietPawn_Balaklava extends DHPawn;

defaultproperties
{
    Species=class'DH_SovietPlayers.DH_Soviet'

    Mesh=SkeletalMesh'DHCharactersSOV_anm.DH_rus_rifleman_tunic'
    Skins(0)=Texture'DHSovietCharactersTex.RussianTunics.DH_rus_rifleman_tunic'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face01'

    FaceSkins(0)=Combiner'DHSovietCharactersTex.sov_faces.sov_face01winter' 
    FaceSkins(1)=Combiner'DHSovietCharactersTex.sov_faces.sov_face02winter'
    FaceSkins(2)=Combiner'DHSovietCharactersTex.sov_faces.sov_face03winter'
    FaceSkins(3)=Combiner'DHSovietCharactersTex.sov_faces.sov_face04winter'
    FaceSkins(4)=Combiner'DHSovietCharactersTex.sov_faces.sov_face05winter'
    FaceSkins(5)=Combiner'DHSovietCharactersTex.sov_faces.sov_face06winter'
    FaceSkins(6)=Combiner'DHSovietCharactersTex.sov_faces.sov_face07winter'
    FaceSkins(7)=Combiner'DHSovietCharactersTex.sov_faces.sov_face08winter'
    FaceSkins(8)=Combiner'DHSovietCharactersTex.sov_faces.sov_face09winter'
    FaceSkins(9)=Combiner'DHSovietCharactersTex.sov_faces.sov_face10winter'
    FaceSkins(10)=Combiner'DHSovietCharactersTex.sov_faces.sov_face11winter'
    FaceSkins(11)=Combiner'DHSovietCharactersTex.sov_faces.sov_face12winter'
    FaceSkins(12)=Combiner'DHSovietCharactersTex.sov_faces.sov_face13winter'
    FaceSkins(13)=Combiner'DHSovietCharactersTex.sov_faces.sov_face14winter'
    FaceSkins(14)=Combiner'DHSovietCharactersTex.sov_faces.sov_face15winter'

    ShovelClassName="DH_Equipment.DHShovelItem_Russian"
    BinocsClassName="DH_Equipment.DHBinocularsItemSoviet"
}
