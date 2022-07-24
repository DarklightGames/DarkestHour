//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_BritishPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_BritishPlayers.DH_British'

    Mesh=SkeletalMesh'DHCharactersBRIT_anm.Brit_Infantry'
    Skins(0)=Texture'DHBritishCharactersTex.PBI.British_Infantry'
    Skins(1)=Texture'DHBritishCharactersTex.Faces.BritParaFace1'

    FaceSkins(0)=Texture'DHBritishCharactersTex.Faces.BritParaFace1'
    FaceSkins(1)=Texture'DHBritishCharactersTex.Faces.BritParaFace2'
    FaceSkins(2)=Texture'DHBritishCharactersTex.Faces.BritParaFace3'

    ShovelClassName="DH_Equipment.DHShovelItem_US" // TODO: make British shovel
    BinocsClassName="DH_Equipment.DHBinocularsItemAllied"
}
