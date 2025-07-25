//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWPTunicMixLightPawn extends DH_LWPPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.LWP_tunic_mix'
    Skins(1)=Texture'DHSovietCharactersTex.DH_LWP_wz43_tunic_light'
    Skins(0)=Texture'Characters_tex.rus_face05'
    Skins(2)=Texture'DHSovietCharactersTex.DH_LWP_wz43_tunic'

    bReversedSkinsSlots=true
}
