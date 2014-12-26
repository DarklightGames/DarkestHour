//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WSSAntiTank_Snow extends DH_WaffenSSSnow;

defaultproperties
{
    bIsATGunner=true
    bCarriesATAmmo=false
    MyName="Tank Hunter"
    AltName="Panzerjäger"
    Article="a "
    PluralName="Tank Hunters"
    InfoText="The tank hunter is tasked with locating and destroying or disabling enemy vehicles.  Armed with close-range anti-tank weaponry, he must often get dangerously close to his target in order to assure a hit.  His weaponry can also be effective against enemy fortifications."
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_AT'
    Models(0)="SSS_1"
    Models(1)="SSS_2"
    Models(2)="SSS_3"
    Models(3)="SSS_4"
    Models(4)="SSS_5"
    Models(5)="SSS_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    Grenades(0)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetSnow'
    PrimaryWeaponType=WT_SMG
    Limit=1
}
