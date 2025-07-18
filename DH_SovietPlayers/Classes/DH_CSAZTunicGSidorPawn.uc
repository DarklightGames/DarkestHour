//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZTunicGSidorPawn extends DH_CSAZPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.CSAZ_tunic_backpackS'
    Skins(1)=Texture'DHSovietCharactersTex.DH_CSAZ_tunicG'
    Skins(0)=Texture'Characters_tex.rus_face05'
    Skins(2)=Texture'Characters_tex.rus_snowcamo'
    Skins(3)=TexRotator'DHSovietCharactersTex.Puttees_alt'

    bReversedSkinsSlots=true
}
