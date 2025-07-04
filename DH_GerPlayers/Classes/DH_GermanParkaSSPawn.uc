//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GermanParkaSSPawn extends DH_GermanParkaPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_Parka_mix'

    Skins(2)=Texture'DHGermanCharactersTex.WSSParkaCam1' //shirt
    Skins(0)=Texture'DHGermanCharactersTex.WSSParkaCam1' //pants

    BodySkins(0)=Texture'DHGermanCharactersTex.HeerParkaCam4' //black
    BodySkins(1)=Texture'DHGermanCharactersTex.WSSParkaCam1'
    BodySkins(2)=Texture'DHGermanCharactersTex.HeerSmock1' //green

    Skins(1)=Texture'Characters_tex.ger_face01'

    bReversedSkinsSlots=false
}
