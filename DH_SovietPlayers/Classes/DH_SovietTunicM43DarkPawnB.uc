//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SovietTunicM43DarkPawnB extends DH_SovietPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.sov_m43tunic_B'
    Skins(1)=Texture'DHSovietCharactersTex.RussianTunics.DH_rus_M43tunic_dark'
    Skins(0)=Texture'Characters_tex.rus_heads.rus_face01'
    Skins(2)=TexRotator'DHSovietCharactersTex.soviet_gear.Puttees_alt'

    bReversedSkinsSlots=true
}
