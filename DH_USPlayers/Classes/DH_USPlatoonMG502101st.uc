//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USPlatoonMG502101st extends DH_US_502PIR;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Machine-Gunner"
    Article="a "
    PluralName="Machine-Gunners"
    Models(0)="US_502101AB1"
    Models(1)="US_502101AB2"
    Models(2)="US_502101AB3"
    bIsGunner=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet502101stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet502101stEMb'
    PrimaryWeaponType=WT_LMG
    Limit=1
}
