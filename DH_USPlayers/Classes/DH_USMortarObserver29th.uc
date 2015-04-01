//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_USMortarObserver29th extends DH_US_29th_Infantry;

defaultproperties
{
    bIsMortarObserver=true
    MyName="Mortar Observer"
    AltName="Mortar Observer"
    Article="a "
    PluralName="Mortar Observers"
    MenuImage=texture'DHUSCharactersTex.Icons.IconMortarObserver'
    Models(0)="US_29Inf1"
    Models(1)="US_29Inf2"
    Models(2)="US_29Inf3"
    Models(3)="US_29Inf4"
    Models(4)="US_29Inf5"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M1GarandWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}
