//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USSergeantAutumn extends DHUSSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USWinterPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USTrenchcoatPawn',Weight=1.0)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmetNCO'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmetNetNCO'
    HandType=Hand_Gloved
}
