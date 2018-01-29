//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_WSSGreatcoatRifleman extends DH_WaffenSSGreatcoat;

defaultproperties
{
     MyName="SS Rifleman"
     AltName="Schütze-SS"
     Article="a "
     PluralName="Riflemen"
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
     Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
     Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
}
