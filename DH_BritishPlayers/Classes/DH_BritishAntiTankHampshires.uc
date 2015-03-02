//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BritishAntiTankHampshires extends DH_Hampshires;

defaultproperties
{
    bIsATGunner=true
    bCarriesATAmmo=false
    MyName="Tank Hunter"
    AltName="Tank Hunter"
    Article="a "
    PluralName="Tank Hunters"
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_AT'
    Models(0)="Hamp_1"
    Models(1)="Hamp_2"
    Models(2)="Hamp_3"
    Models(3)="Hamp_4"
    Models(4)="Hamp_5"
    Models(5)="Hamp_6"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=1)
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    GivenItems(0)="DH_ATWeapons.DH_PIATWeapon"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    PrimaryWeaponType=WT_SMG
    Limit=1
}
