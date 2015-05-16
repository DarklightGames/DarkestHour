//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WKOfficer extends DH_Kriegsmarine;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Officer"
    AltName="Zugführer"
    Article="a "
    PluralName="Officers"
    MenuImage=texture'DHGermanCharactersTex.Icons.Zugfuhrer'
    Models(0)="WK_1"
    Models(1)="WK_2"
    Models(2)="WK_3"
    Models(3)="WK_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P38Weapon')
    Grenades(0)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineHelmet'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
}
