//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USRifleman1st extends DHUSRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_US1stPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_USVest1stPawn',Weight=1.0)

    Headgear(0)=Class'DH_AmericanHelmet1stEMa'
    Headgear(1)=Class'DH_AmericanHelmet1stEMb'
    Headgear(2)=Class'DH_AmericanHelmet'
    Headgear(3)=Class'DH_AmericanHelmetNet'

    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.4
    HeadgearProbabilities(2)=0.1
    HeadgearProbabilities(3)=0.3
}
