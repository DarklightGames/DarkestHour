//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GermanFJPawn extends DH_GermanPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_Fallschirmjager'
    Skins(0)=Texture'DHGermanCharactersTex.FJ_Green'
    Skins(1)=Texture'Characters_tex.ger_face01'

    bReversedSkinsSlots=false

    BodySkins(0)=Texture'DHGermanCharactersTex.FJ_Green'
    BodySkins(1)=Texture'DHGermanCharactersTex.FJ_SplinterB2'
    BodySkins(2)=Texture'DHGermanCharactersTex.FJ_SplinterB2'
    BodySkins(3)=Texture'DHGermanCharactersTex.FJ_SplinterB3'
}
