//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USSergeant1stIDSicilyBeach extends DHUSSergeantRoles;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_M1928_20rndWeapon',AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M1CarbineWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M1GarandWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
    RolePawns(0)=(PawnClass=Class'DH_US1stIDSicilyBeachPawnNCO',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.US_HBT_Light_sleeves'
    Headgear(0)=Class'DH_AmericanHelmet1stNCOa'
    Headgear(1)=Class'DH_AmericanHelmetNCO'
    HeadgearProbabilities(0)=0.7
    HeadgearProbabilities(1)=0.3
}
