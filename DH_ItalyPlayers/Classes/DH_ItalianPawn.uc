//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_ItalianPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_ItalyPlayers.DH_Italian'

    Mesh=SkeletalMesh'DHCharactersITA_anm.ita_livorno_rifleman'
    Skins(0)=Texture'DHItalianCharactersTex.Uniforms.ita_livorno_rifleman'
    Skins(1)=Texture'DHItalianCharactersTex.Faces.ita_face01'

    FaceSkins(0)=Texture'DHItalianCharactersTex.Faces.ita_face01'
    // FaceSkins(1)=Texture'DHItalianCharactersTex.Faces.ita_face02'
    // FaceSkins(2)=Texture'DHItalianCharactersTex.Faces.ita_face03'
    // FaceSkins(3)=Texture'DHItalianCharactersTex.Faces.ita_face04'
    // FaceSkins(4)=Texture'DHItalianCharactersTex.Faces.ita_face05'
    // FaceSkins(5)=Texture'DHItalianCharactersTex.Faces.ita_face06'
    // FaceSkins(6)=Texture'DHItalianCharactersTex.Faces.ita_face07'
    // FaceSkins(7)=Texture'DHItalianCharactersTex.Faces.ita_face08'
    // FaceSkins(8)=Texture'DHItalianCharactersTex.Faces.ita_face09'
    // FaceSkins(9)=Texture'DHItalianCharactersTex.Faces.ita_face10'
    // FaceSkins(10)=Texture'DHItalianCharactersTex.Faces.ita_face11'
    // FaceSkins(11)=Texture'DHItalianCharactersTex.Faces.ita_face12'
    // FaceSkins(12)=Texture'DHItalianCharactersTex.Faces.ita_face13'
    // FaceSkins(13)=Texture'DHItalianCharactersTex.Faces.ita_face14'
    // FaceSkins(14)=Texture'DHItalianCharactersTex.Faces.ita_face15'

    // TODO: replace all this
    ShovelClass=class'DH_Equipment.DHShovelItem_Italian'
    BinocsClass=class'DH_Equipment.DHBinocularsItemSoviet'
    SmokeGrenadeClass=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeWeapon'

    HealthFigureClass=class'DH_ItalyPlayers.DHHealthFigure_Italy'
}
