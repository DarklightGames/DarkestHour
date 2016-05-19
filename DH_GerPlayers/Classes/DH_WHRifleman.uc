//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHRifleman extends DH_Heer;

defaultproperties
{
    MyName="Schütze"
    AltName="Schütze"
    Article="a "
    PluralName="Schützen"
    MenuImage=texture'InterfaceArt_tex.SelectMenus.Schutze'
    Models(0)="WH_1"
    Models(1)="WH_2"
    Models(2)="WH_3"
    Models(3)="WH_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
}
