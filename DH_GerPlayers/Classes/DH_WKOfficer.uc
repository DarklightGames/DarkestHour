//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WKOfficer extends DH_Kriegsmarine;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Officer"
    AltName="Zugführer"
    Article="a "
    PluralName="Officers"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P38Weapon')
    Grenades(0)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineHelmet'
    Limit=1
}
