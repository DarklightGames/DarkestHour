//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_12thSSAntiTank extends DH_12thSS;

defaultproperties
{
    bIsATGunner=true
    bCarriesATAmmo=false
    MyName="Tank Hunter"
    AltName="Panzerjäger"
    Article="a "
    PluralName="Tank Hunters"
    InfoText="The tank hunter is tasked with locating and destroying or disabling enemy vehicles.  Armed with close-range anti-tank weaponry, he must often get dangerously close to his target in order to ensure a hit.  His weaponry can also be effective against enemy fortifications."
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_AT'
    Models(0)="12SS_1"
    Models(1)="12SS_2"
    Models(2)="12SS_3"
    Models(3)="12SS_4"
    Models(4)="12SS_5"
    Models(5)="12SS_6"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Grenades(0)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SMG
    Limit=1
}
