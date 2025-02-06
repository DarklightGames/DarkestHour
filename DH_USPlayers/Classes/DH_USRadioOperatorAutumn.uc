//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USRadioOperatorAutumn extends DHUSRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USRadioWinterPawn')
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USRadioTrenchcoatPawn')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmetNet'
    HandType=Hand_Gloved
}
