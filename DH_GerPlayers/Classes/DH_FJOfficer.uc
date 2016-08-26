//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJOfficer extends DH_FJ;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Artillery Officer"
    AltName="Artillerieoffizier"
    Article="a "
    PluralName="Artillery Officers"
    Models(0)="FJO1"
    Models(1)="FJO2"
    Models(2)="FJO3"
    Models(3)="FJO4"
    Models(4)="FJO5"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamo1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamo2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
}
