//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHMortarObserver extends DH_Heer;

defaultproperties
{
    bIsMortarObserver=true
    MyName="Mortar Observer"
    AltName="Werferbeobachter"
    Article="a "
    PluralName="Mortar Observers"
    MenuImage=texture'DHGermanCharactersTex.Icons.WH_MortarObserver'
    Models(0)="WH_1"
    Models(1)="WH_2"
    Models(2)="WH_3"
    Models(3)="WH_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    Limit=1
}
