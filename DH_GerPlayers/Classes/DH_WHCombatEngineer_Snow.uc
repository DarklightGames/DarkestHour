//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHCombatEngineer_Snow extends DH_HeerSnow;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Stürmpioniere"
    Article="a "
    PluralName="Combat Engineers"
    Models(0)="WHS_1"
    Models(1)="WHS_2"
    Models(2)="WHS_3"
    Models(3)="WHS_4"
    Models(4)="WHS_5"
    Models(5)="WHS_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetSnow'
    PrimaryWeaponType=WT_SMG
    Limit=3
}
