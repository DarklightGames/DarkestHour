//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USEngineer7th extends DHUSEngineerRoles;

// Note: There are no other 7th Naval Beach Battalion roles (only engineer)

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_US7thPawn',Weight=5.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USVest7thPawn',Weight=4.0)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet7thEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet7thEMb'
}
