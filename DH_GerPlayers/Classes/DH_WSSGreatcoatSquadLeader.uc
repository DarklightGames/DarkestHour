//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatSquadLeader extends DH_WaffenSSGreatcoat;

defaultproperties
{
    MyName="SS Squad Leader"
    AltName="Gruppenführer-SS"
    Article="a "
    PluralName="SS Squad Leaders"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_G41Weapon',Amount=9,AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
    bIsLeader=true
    Limit=2
}
