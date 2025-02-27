//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BritishVestPawn extends DH_BritishPawn;

// Modified to fix player's head being too big in the assault vest mesh!
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetHeadScale(default.HeadScale);
}

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersBRIT_anm.Brit_Infantry_Vest'
    Skins(0)=Texture'DHBritishCharactersTex.Faces.BritParaFace1'
    Skins(1)=Texture'DHBritishCharactersTex.PBI.British_Infantry_Vest'

    HeadScale=0.9

    bReversedSkinsSlots=true
}
