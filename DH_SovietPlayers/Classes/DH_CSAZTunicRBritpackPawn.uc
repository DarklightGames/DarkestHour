//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZTunicRBritpackPawn extends DH_CSAZPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.CSAZ_tunic_backpackB'
    Skins(1)=Texture'DHSovietCharactersTex.DH_CSAZ_tunic'
    Skins(0)=Texture'Characters_tex.rus_face05'
    Skins(2)=Texture'DHBritishCharactersTex.BritParaGear'

    bReversedSkinsSlots=true
}
