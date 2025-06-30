//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWPTunicGreyPawn extends DH_LWPPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.LWP_tunic_late'
    Skins(1)=Texture'DHSovietCharactersTex.DH_LWP_wz43_tunic_grey'
    Skins(0)=Texture'Characters_tex.rus_face05'
    Skins(2)=TexRotator'DHSovietCharactersTex.Puttees_alt'

    bReversedSkinsSlots=true
}
