//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USOfficerWinter extends DH_US_Winter_Infantry;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Artillery Officer"
    AltName="Artillery Officer"
    Article="an "
    PluralName="Artillery Officers"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanWinterWoolHat'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stOfficer'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
}
