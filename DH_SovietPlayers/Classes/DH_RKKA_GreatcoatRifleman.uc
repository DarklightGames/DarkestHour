//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RKKA_GreatcoatRifleman extends DH_RKKA_Greatcoat;

defaultproperties
{
    MyName="Rifleman"
    AltName="Strelok"
    Article="a "
    PluralName="Riflemen"
    PrimaryWeaponType=WT_Rifle
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon',Amount=2)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietFurHat'
}
