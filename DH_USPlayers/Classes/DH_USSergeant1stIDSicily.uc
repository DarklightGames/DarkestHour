//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USSergeant1stIDSicily extends DHUSSergeantRoles;

defaultproperties
{
    // The greasegun was not issued until late 1943, so it is not available in the Sicily campaign.
    // Rplace it with the M1928 Thompson.
    PrimaryWeapons(0)=(Item=Class'DH_M1928_20rndWeapon',AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M1CarbineWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M1GarandWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
    RolePawns(0)=(PawnClass=Class'DH_US1stIDSicilyPawnNCO',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_HBT_Light_sleeves'
    Headgear(0)=Class'DH_AmericanHelmet1stNCOa'
    Headgear(1)=Class'DH_AmericanHelmetNCO'
    HeadgearProbabilities(0)=0.7
    HeadgearProbabilities(1)=0.3
}
