//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_USSniperWinter extends DH_US_Winter_Infantry;

defaultproperties
{
    MyName="Sniper"
    AltName="Sniper"
    Article="a "
    PluralName="Snipers"
    MenuImage=texture'DHUSCharactersTex.Icons.IconSnip'
    Models(0)="US_WinterInf1"
    Models(1)="US_WinterInf2"
    Models(2)="US_WinterInf3"
    Models(3)="US_WinterInf4"
    Models(4)="US_WinterInf5"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_SpringfieldScopedWeapon',Amount=18,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmetWinter'
    PrimaryWeaponType=WT_Sniper
    Limit=1
}
