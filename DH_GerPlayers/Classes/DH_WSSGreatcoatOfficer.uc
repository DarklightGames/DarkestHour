//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatOfficer extends DH_WaffenSSGreatcoat;

defaultproperties
{
    MyName="Artillery Officer"
    AltName="Artillerieoffizier"
    Article="a "
    PluralName="Artillery Officers"
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Equipment.DH_GerArtyBinocularsItem"
    Headgear(0)=Class'DH_GerPlayers.DH_WSSOfficercap'
    Headgear(1)=Class'DH_GerPlayers.DH_WSSCrushercap'
    Limit=1
    bIsArtilleryOfficer=true
}
