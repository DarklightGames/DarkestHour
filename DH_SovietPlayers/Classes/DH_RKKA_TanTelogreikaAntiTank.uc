//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RKKA_TanTelogreikaAntiTank extends DH_RKKA_TanTelogreika;

defaultproperties
{
    MyName="Anti-tank soldier"
    AltName="PT-Soldat"
    Article="an "
    PluralName="Anti-tank soldiers"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M38Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon',Amount=3)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietSidecap'
    bIsGunner=true
    Limit=2
}
