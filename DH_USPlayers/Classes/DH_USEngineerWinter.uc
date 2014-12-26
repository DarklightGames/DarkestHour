//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USEngineerWinter extends DH_US_Winter_Infantry;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Combat Engineer"
    Article="a "
    PluralName="Combat Engineers"
    InfoText="The combat engineer is tasked with destroying front-line enemy obstacles and fortifications.  Geared for close quarters combat, the combat engineer is generally equipped with sub machine-guns and grenades.  For instances where enemy fortifications or obstacles are exposed to enemy fire, he is equipped with concealment smoke so he may get close enough to destroy the target."
    MenuImage=texture'DHUSCharactersTex.Icons.IconEng'
    Models(0)="US_WinterInf1"
    Models(1)="US_WinterInf2"
    Models(2)="US_WinterInf3"
    Models(3)="US_WinterInf4"
    Models(4)="US_WinterInf5"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmetWinter'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    PrimaryWeaponType=WT_SemiAuto
    Limit=3
}
