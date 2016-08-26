//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USRadioOperator1st extends DH_US_1st_Infantry;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    Models(0)="US_1InfRad1"
    Models(1)="US_1InfRad2"
    Models(2)="US_1InfRad3"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}
