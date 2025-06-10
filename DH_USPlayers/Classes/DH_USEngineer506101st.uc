//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USEngineer506101st extends DHUSENgineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_USAB101stPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    Headgear(0)=Class'DH_AmericanHelmet506101stEMa'
    Headgear(1)=Class'DH_AmericanHelmet506101stEMb'

    PrimaryWeapons(0)=(Item=Class'DH_M1A1CarbineWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
}
