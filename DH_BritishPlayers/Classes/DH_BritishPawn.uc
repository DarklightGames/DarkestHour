//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BritishPawn extends DHPawn;

defaultproperties
{
    Species=Class'DH_British'

    Mesh=SkeletalMesh'DHCharactersBRIT_anm.Brit_Infantry'
    Skins(0)=Texture'DHBritishCharactersTex.PBI.British_Infantry'
    Skins(1)=Texture'DHBritishCharactersTex.Faces.BritParaFace1'

    FaceSkins(0)=Texture'DHBritishCharactersTex.Faces.BritParaFace1'
    FaceSkins(1)=Texture'DHBritishCharactersTex.Faces.BritParaFace2'
    FaceSkins(2)=Texture'DHBritishCharactersTex.Faces.BritParaFace3'

    ShovelClass=Class'DHShovelItem_US' // TODO: make British shovel
    BinocsClass=Class'DHBinocularsItemAllied'
    SmokeGrenadeClass=Class'DH_USSmokeGrenadeWeapon'
    ColoredSmokeGrenadeClass=Class'DH_RedSmokeWeapon'

    HealthFigureClass=Class'DHHealthFigure_Britain'
}
