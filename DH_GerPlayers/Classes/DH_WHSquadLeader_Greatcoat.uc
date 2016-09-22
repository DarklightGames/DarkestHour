//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHSquadLeader_Greatcoat extends DH_HeerGreatcoat;

defaultproperties
{
    MyName="Squad Leader"
    AltName="Gruppenführer"
    Article="a "
    PluralName="Squad Leaders"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_G41Weapon',Amount=9,AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Equipment.DH_GerArtyBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
    bIsLeader=true
    Limit=2
}
