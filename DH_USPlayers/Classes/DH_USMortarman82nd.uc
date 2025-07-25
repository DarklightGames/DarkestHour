//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USMortarman82nd extends DHUSMortarmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_USAB82ndPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.USAB_sleeves'
    Headgear(0)=Class'DH_AmericanHelmet82ndEMa'
    Headgear(1)=Class'DH_AmericanHelmet82ndEMb'

    PrimaryWeapons(0)=(Item=Class'DH_M1A1CarbineWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
}
