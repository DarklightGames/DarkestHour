//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USEngineerWinter extends DHUSEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USTrenchcoatScarfPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USWinterScarfPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_USPlayers.DH_USTrenchcoatPawn',Weight=0.6)
    RolePawns(3)=(PawnClass=class'DH_USPlayers.DH_USWinterPawn',Weight=0.3)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmetWinter'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    HandType=Hand_Gloved
}
