//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USSergeantWinter extends DHUSSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_USTrenchcoatScarfPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_USWinterScarfPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_USTrenchcoatPawn',Weight=0.6)
    RolePawns(3)=(PawnClass=Class'DH_USWinterPawn',Weight=0.3)
    Headgear(0)=Class'DH_AmericanWinterWoolHat'
    Headgear(1)=Class'DH_AmericanHelmetWinter'
    Headgear(2)=Class'DH_AmericanHelmetNCO'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.4
    HeadgearProbabilities(2)=0.4
    HandType=Hand_Gloved
}
