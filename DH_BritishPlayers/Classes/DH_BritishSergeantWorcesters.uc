//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BritishSergeantWorcesters extends DHCWSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_BritishSergeantWorcestersPawn')
    RolePawns(1)=(PawnClass=Class'DH_BritishVestSergeantWorcestersPawn')
    Headgear(0)=Class'DH_BritishInfantryBeretWorcesters'
    Headgear(1)=Class'DH_BritishTurtleHelmetNet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
