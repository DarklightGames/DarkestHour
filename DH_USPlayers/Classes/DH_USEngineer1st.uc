//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USEngineer1st extends DH_US_1st_Infantry;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Combat Engineer"
    Article="a "
    PluralName="Combat Engineers"
    Models(0)="US_1Inf1"
    Models(1)="US_1Inf2"
    Models(2)="US_1Inf3"
    Models(3)="US_1Inf4"
    Models(4)="US_1Inf5"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=3
}
