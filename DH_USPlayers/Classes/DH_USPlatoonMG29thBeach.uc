//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_USPlatoonMG29thBeach extends DH_US_29th_Infantry;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Machine-Gunner"
    Article="a "
    PluralName="Machine-Gunners"
    MenuImage=texture'DHUSCharactersTex.Icons.IconPMG'
    Models(0)="US_29Inf1B"
    Models(1)="US_29Inf2B"
    Models(2)="US_29Inf3B"
    Models(3)="US_29Inf4B"
    Models(4)="US_29Inf5B"
    bIsGunner=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thEMb'
    bCarriesMGAmmo=false
    PrimaryWeaponType=WT_LMG
    Limit=1
}
