//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BritishPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_BritishPlayers.DH_British'

    Mesh=SkeletalMesh'DHCharacters_anm.Brit_Infantry'
    Skins(0)=Texture'DHBritishCharactersTex.PBI.British_Infantry'
    Skins(1)=Texture'DHBritishCharactersTex.Faces.BritParaFace1'

    FaceSkins(0)=Texture'DH_Halloween_Masks.gb_heads.BritParaFace1'
    FaceSkins(1)=Texture'DH_Halloween_Masks.gb_heads.BritParaFace2'

    ShovelClassName="DH_Equipment.DHShovelItem_US" // TODO: make British shovel
    BinocsClassName="DH_Equipment.BinocularsItemAllied"
}
