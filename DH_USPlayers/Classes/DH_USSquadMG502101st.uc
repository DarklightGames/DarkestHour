//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USSquadMG502101st extends DHUSAutoRifleRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_USAB101stPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.USAB_sleeves'
    Headgear(0)=Class'DH_AmericanHelmet502101stEMa'
    Headgear(1)=Class'DH_AmericanHelmet502101stEMb'

    PrimaryWeapons(1)=(Item=Class'DH_BARNoBipodWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
}
