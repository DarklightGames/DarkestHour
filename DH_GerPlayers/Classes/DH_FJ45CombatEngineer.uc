//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJ45CombatEngineer extends DH_FJ_1945;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Sturmpioniere"
    Article="a "
    PluralName="Combat Engineers"
    InfoText="The combat engineer is tasked with destroying front-line enemy obstacles and fortifications.  Geared for close quarters combat, the combat engineer is generally equipped with submachine-guns and grenades.  For instances where enemy fortifications or obstacles are exposed to enemy fire, he is equipped with concealment smoke so he may get close enough to destroy the target."
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_Eng'
    Models(0)="FJ451"
    Models(1)="FJ452"
    Models(2)="FJ453"
    Models(3)="FJ454"
    Models(4)="FJ455"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmet1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmet2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    PrimaryWeaponType=WT_SMG
    Limit=3
}
