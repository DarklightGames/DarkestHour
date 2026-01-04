//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ROM_GreatcoatRifleman extends DHROMRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_RomanianGreatcoatPutteesPawn',Weight=7.0)
    Headgear(0)=Class'DH_RomanianCap'
    Headgear(1)=Class'DH_RomanianHelmet'

    HeadgearProbabilities(0)=0.7
    HeadgearProbabilities(1)=0.3

    SleeveTexture=Texture'DHRomanianCharactersTex.Sleeves.RomanianSummerSleeves'
}
