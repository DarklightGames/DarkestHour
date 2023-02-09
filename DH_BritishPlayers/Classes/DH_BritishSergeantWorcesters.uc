//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BritishSergeantWorcesters extends DHCWSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_BritishSergeantWorcestersPawn')
    RolePawns(1)=(PawnClass=class'DH_BritishPlayers.DH_BritishVestSergeantWorcestersPawn')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishInfantryBeretWorcesters'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
