//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZ_BritcoatRifleman_Winter extends DHCSRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_CSAZbritcoatPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_CSAZbritcoatSidorPawn_Winter',Weight=1.0)
    Headgear(0)=Class'DH_CSAZFurHatUnfolded'
    SleeveTexture=Texture'DHBritishCharactersTex.Brit_Coat_Sleeves'
    HandType=Hand_Gloved
}
