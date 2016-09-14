//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USPlatoonMGWinter extends DH_US_Winter_Infantry;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Machine-Gunner"
    Article="a "
    PluralName="Machine-Gunners"
    bIsGunner=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmetWinter'
    PrimaryWeaponType=WT_LMG
    Limit=1
}
