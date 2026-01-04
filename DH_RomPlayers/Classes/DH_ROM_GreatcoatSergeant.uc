//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ROM_GreatcoatSergeant extends DHROMSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_RomanianGreatcoatPawn',Weight=7.0)
    Headgear(0)=Class'DH_RomanianCap'
    Headgear(1)=Class'DH_RomanianHelmetB'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    SleeveTexture=Texture'DHRomanianCharactersTex.Sleeves.RomanianSummerSleeves'
}
