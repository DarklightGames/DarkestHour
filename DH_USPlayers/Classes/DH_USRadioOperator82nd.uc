//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USRadioOperator82nd extends DHUSRadioOperatorRoles;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1A1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USAB82ndRadioPawn')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndEMb'
}
