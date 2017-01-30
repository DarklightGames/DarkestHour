//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHCombatEngineer_Greatcoat extends DH_HeerGreatcoat;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Stürmpioniere"
    Article="a "
    PluralName="Combat Engineers"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    GivenItems(1)="DH_Equipment.DHWireCuttersItem"
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    Limit=1
}
