//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHArtilleryGunner extends DH_Heer;

defaultproperties
{
    MyName="Artillery Gunner"
    AltName="Artillerie Schütze"
    Article="a "
    PluralName="Artillery Gunners"
    Models(0)="WHA_1"
    Models(1)="WHA_2"
    Models(2)="WHA_3"
    Models(3)="WHA_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    bCanBeTankCrew=true
    Limit=5
}
