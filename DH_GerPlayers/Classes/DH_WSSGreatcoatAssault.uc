//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGreatcoatAssault extends DH_WaffenSSGreatcoat;

defaultproperties
{
     MyName="SS Assault Troop"
     AltName="Stoßtruppe-SS"
     Article="a "
     PluralName="SS Assault Troops"
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
     Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
     Limit=4
}
