//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatRifleman extends DH_WaffenSSGreatcoat;

defaultproperties
{
     MyName="SS Rifleman"
     AltName="Schütze-SS"
     Article="a "
     PluralName="Riflemen"
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
}
