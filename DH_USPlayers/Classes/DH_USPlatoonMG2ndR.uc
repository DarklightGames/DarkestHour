//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USPlatoonMG2ndR extends DH_US_2ndRangersBattalion;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Machine-Gunner"
    Article="a "
    PluralName="Machine-Gunners"
    Models(0)="US_2R1"
    Models(1)="US_2R2"
    Models(2)="US_2R3"
    Models(3)="US_2R4"
    Models(4)="US_2R5"
    bIsGunner=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet2ndREMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet2ndREMb'
    PrimaryWeaponType=WT_LMG
    Limit=1
}
