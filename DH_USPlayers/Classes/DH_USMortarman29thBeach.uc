//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USMortarman29thBeach extends DH_US_29th_Infantry;

defaultproperties
{
    bCanUseMortars=true
    MyName="Mortar Operator"
    AltName="Mortar Operator"
    Article="a "
    PluralName="Mortar Operators"
    Models(0)="US_29Inf1B"
    Models(1)="US_29Inf2B"
    Models(2)="US_29Inf3B"
    Models(3)="US_29Inf4B"
    Models(4)="US_29Inf5B"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    GivenItems(0)="DH_Mortars.DH_M2MortarWeapon"
    GivenItems(1)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}
