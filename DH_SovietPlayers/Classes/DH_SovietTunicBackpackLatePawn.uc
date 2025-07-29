//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SovietTunicBackpackLatePawn extends DH_SovietPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.sov_tunic_backpack_late'
    Skins(1)=Texture'DHSovietCharactersTex.DH_rus_rifleman_tunic'
    Skins(0)=Texture'Characters_tex.rus_face01'
	Skins(2)=Texture'Characters_tex.rus_snowcamo'
    Skins(3)=TexRotator'DHSovietCharactersTex.Puttees_alt'

    bReversedSkinsSlots=true
}
