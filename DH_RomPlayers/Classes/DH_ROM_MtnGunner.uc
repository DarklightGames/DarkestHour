//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ROM_MtnGunner extends DHROMMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_RomanianMtnPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_RomanianMtnCorporalPawn',Weight=1.0)
    SleeveTexture=Texture'DHRomanianCharactersTex.Sleeves.RomanianSummerSleeves'

    Headgear(0)=Class'DH_RomanianHelmet'
    Headgear(1)=Class'DH_RomanianHelmetB'

    HeadgearProbabilities(0)=0.7
    HeadgearProbabilities(1)=0.3
}
