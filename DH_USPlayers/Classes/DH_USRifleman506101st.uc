//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USRifleman506101st extends DHUSRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_USAB101stPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.USAB_sleeves'
    Headgear(0)=Class'DH_AmericanHelmet506101stEMa'
    Headgear(1)=Class'DH_AmericanHelmet506101stEMb'

    PrimaryWeapons(0)=(Item=Class'DH_M1GarandWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')

    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
}
