//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USSergeant1st extends DHUSSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_US1stPawnNCO',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_USVest1stPawnNCO',Weight=1.0)

    Headgear(0)=Class'DH_AmericanHelmet1stNCOa'
    Headgear(1)=Class'DH_AmericanHelmet1stNCOb'
    Headgear(2)=Class'DH_AmericanHelmetNCO'
    Headgear(3)=Class'DH_AmericanHelmetNetNCO'

    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.4
    HeadgearProbabilities(2)=0.1
    HeadgearProbabilities(3)=0.3

}
