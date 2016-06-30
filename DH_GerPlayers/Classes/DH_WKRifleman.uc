//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WKRifleman extends DH_Kriegsmarine;

defaultproperties
{
    MyName="Rifleman"
    AltName="Schütze"
    Article="a "
    PluralName="Riflemen"
    Models(0)="WK_1"
    Models(1)="WK_2"
    Models(2)="WK_3"
    Models(3)="WK_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineHelmet'
}
