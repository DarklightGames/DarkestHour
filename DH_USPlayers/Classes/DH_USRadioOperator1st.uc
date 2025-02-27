//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USRadioOperator1st extends DHUSRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USRadio1stPawn',Weight=1.0)
    
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa' 
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMb'
    Headgear(2)=class'DH_USPlayers.DH_AmericanHelmet'
    Headgear(3)=class'DH_USPlayers.DH_AmericanHelmetNet'

    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.4
    HeadgearProbabilities(2)=0.1
    HeadgearProbabilities(3)=0.3

}
