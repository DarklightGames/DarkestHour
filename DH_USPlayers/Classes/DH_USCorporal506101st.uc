//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USCorporal506101st extends DHUSCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_USAB101stPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    Headgear(0)=Class'DH_AmericanHelmet506101stEMa'
    Headgear(1)=Class'DH_AmericanHelmet506101stEMb'

    PrimaryWeapons(0)=(Item=Class'DH_GreaseGunWeapon',AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M1A1CarbineWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
}
