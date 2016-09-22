//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHFireteamLeader extends DH_Heer;

defaultproperties
{
    MyName="Corporal"
    AltName="Gefreiter"
    Article="a "
    PluralName="Corporals"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    Limit=1
    Limit33to44=2
    LimitOver44=2
}
