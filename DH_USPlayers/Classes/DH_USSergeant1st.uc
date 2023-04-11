//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USSergeant1st extends DHUSSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_US1stPawnNCO',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USVest1stPawnNCO',Weight=1.0)

    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stNCOa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stNCOb'
    Headgear(2)=class'DH_USPlayers.DH_AmericanHelmetNCO'
    Headgear(3)=class'DH_USPlayers.DH_AmericanHelmetNetNCO'

    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.4
    HeadgearProbabilities(2)=0.1
    HeadgearProbabilities(3)=0.3

}
