//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_USrifleman2ndR extends DHUSRiflemanRoles;

defaultproperties
{
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SpringfieldA1Weapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')

    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_US2ndRPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USVest2ndRPawn',Weight=1.0)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet2ndREMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet2ndREMb'
}
