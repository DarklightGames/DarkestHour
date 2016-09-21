//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHOfficer_Greatcoat extends DH_HeerGreatcoat;

defaultproperties
{
    MyName="Artillery Officer"
    AltName="Artillerieoffizier"
    Article="a "
    PluralName="Artillery Officers"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Equipment.DH_GerArtyBinocularsItem"
    Headgear(0)=Class'DH_GerPlayers.DH_HeerOfficercap'
    Headgear(1)=Class'DH_GerPlayers.DH_HeerCrushercap'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=True
    limit=1
    bIsArtilleryOfficer=true
}
