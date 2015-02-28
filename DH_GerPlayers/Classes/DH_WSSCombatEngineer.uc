//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WSSCombatEngineer extends DH_WaffenSS;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Sturmpioniere"
    Article="a "
    PluralName="Combat Engineers"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_Eng'
    Models(0)="SS_1"
    Models(1)="SS_2"
    Models(2)="SS_3"
    Models(3)="SS_4"
    Models(4)="SS_5"
    Models(5)="SS_6"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SMG
    Limit=3
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
}
class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SMG
    Limit=3
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
}
