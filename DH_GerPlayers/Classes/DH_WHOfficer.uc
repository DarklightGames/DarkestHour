//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHOfficer extends DH_Heer;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Artillery Officer"
    AltName="Artillerieoffizier"
    Article="a "
    PluralName="Artillery Officers"
    Models(0)="WH_1"
    Models(1)="WH_2"
    Models(2)="WH_3"
    Models(3)="WH_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetOne'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
}
