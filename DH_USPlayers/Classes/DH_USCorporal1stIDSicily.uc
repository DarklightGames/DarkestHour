//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USCorporal1stIDSicily extends DHUSCorporalRoles;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1928_20rdWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_M1GarandWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_US1stIDSicilyPawn',Weight=5.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_US1stIDSicilyBeachPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_HBT_Light_sleeves'
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    HeadgearProbabilities(0)=0.3
    HeadgearProbabilities(1)=0.7
}
