//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BritishPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_BritishPlayers.DH_British'

    Mesh=SkeletalMesh'DHCharacters_anm.Brit_Infantry'
    Skins(0)=texture'DHBritishCharactersTex.PBI.British_Infantry'
    Skins(1)=texture'DHBritishCharactersTex.Faces.BritParaFace1'

    FaceSkins(0)=texture'DHBritishCharactersTex.Faces.BritParaFace1'
    FaceSkins(1)=texture'DHBritishCharactersTex.Faces.BritParaFace2'
    FaceSkins(2)=texture'DHBritishCharactersTex.Faces.BritParaFace3'
}
