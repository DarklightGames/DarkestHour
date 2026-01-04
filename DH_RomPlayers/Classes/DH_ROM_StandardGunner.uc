//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ROM_StandardGunner extends DHROMMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_RomanianStandardPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_RomanianStandardCorporalPawn',Weight=1.0)
    SleeveTexture=Texture'DHRomanianCharactersTex.Sleeves.RomanianSummerSleeves'

    Headgear(0)=Class'DH_RomanianHelmet'
    Headgear(1)=Class'DH_RomanianHelmetB'

    HeadgearProbabilities(0)=0.7
    HeadgearProbabilities(1)=0.3
}
