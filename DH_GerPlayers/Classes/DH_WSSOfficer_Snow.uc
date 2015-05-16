//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WSSOfficer_Snow extends DH_WaffenSSSnow;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Artillery Officer"
    AltName="Artillerieoffizier"
    Article="a "
    PluralName="Artillery Officers"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_Off'
    Models(0)="SSS_1"
    Models(1)="SSS_2"
    Models(2)="SSS_3"
    Models(3)="SSS_4"
    Models(4)="SSS_5"
    Models(5)="SSS_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetSnow'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
}
