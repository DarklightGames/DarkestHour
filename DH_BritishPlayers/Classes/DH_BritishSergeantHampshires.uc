//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BritishSergeantHampshires extends DHCWSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_BritishSergeantHampshiresPawn')
    RolePawns(1)=(PawnClass=class'DH_BritishPlayers.DH_BritishVestSergeantHampshiresPawn')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishInfantryBeretHampshires'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
