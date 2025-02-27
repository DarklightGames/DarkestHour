//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZBritcoatBritpackPawn extends DH_CSAZPawn_SovGloves; //works as winter version too

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.CSAZ_britcoat_britpack'
    Skins(0)=Texture'Characters_tex.rus_heads.rus_face05'
    Skins(1)=Texture'DHBritishCharactersTex.Winter.britcoat'
    Skins(2)=Texture'DHBritishCharactersTex.ParachuteRegiment.BritParaGear'

    bReversedSkinsSlots=true
}
