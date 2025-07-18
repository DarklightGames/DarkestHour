//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BritishSergeantHampshires extends DHCWSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_BritishSergeantHampshiresPawn')
    RolePawns(1)=(PawnClass=Class'DH_BritishVestSergeantHampshiresPawn')
    Headgear(0)=Class'DH_BritishInfantryBeretHampshires'
    Headgear(1)=Class'DH_BritishTurtleHelmetNet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
