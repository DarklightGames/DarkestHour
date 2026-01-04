//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ROM_MtnRifleman extends DHROMRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_RomanianMtnPawn',Weight=7.0)
    Headgear(0)=Class'DH_RomanianMtnBeret'
    Headgear(1)=Class'DH_RomanianHelmet'

    HeadgearProbabilities(0)=0.3
    HeadgearProbabilities(1)=0.7

    SleeveTexture=Texture'DHRomanianCharactersTex.Sleeves.RomanianSummerSleeves'
}
