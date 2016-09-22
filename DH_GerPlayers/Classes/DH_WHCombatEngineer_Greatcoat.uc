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
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    Limit=1

}
