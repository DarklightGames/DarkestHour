//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHAssault_Greatcoat extends DH_HeerGreatcoat;

defaultproperties
{
     MyName="Assault Trooper"
     AltName="Stoßtruppe"
     Article="an "
     PluralName="Assault Troops"
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetThree'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
     Limit=4
}
