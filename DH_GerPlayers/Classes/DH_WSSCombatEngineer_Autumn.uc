//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSCombatEngineer_Autumn extends DH_WaffenSSAutumn;

defaultproperties
{
    MyName="Sturmpioniere"
    AltName="Sturmpioniere"
    Article="a "
    PluralName="Sturmpionieri"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_Eng'
    Models(0)="SSA_1"
    Models(1)="SSA_2"
    Models(2)="SSA_3"
    Models(3)="SSA_4"
    Models(4)="SSA_5"
    Models(5)="SSA_6"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetNoCover'
    PrimaryWeaponType=WT_SMG
    Limit=3
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
}
