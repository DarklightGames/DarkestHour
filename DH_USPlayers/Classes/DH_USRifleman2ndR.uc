//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USrifleman2ndR extends DHUSRiflemanRoles;

defaultproperties
{
    PrimaryWeapons(1)=(Item=Class'DH_SpringfieldA1Weapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')

    RolePawns(0)=(PawnClass=Class'DH_US2ndRPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_USVest2ndRPawn',Weight=1.0)
    Headgear(0)=Class'DH_AmericanHelmet2ndREMa'
    Headgear(1)=Class'DH_AmericanHelmet2ndREMb'
}
