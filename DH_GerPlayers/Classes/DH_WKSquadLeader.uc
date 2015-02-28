//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WKSquadLeader extends DH_Kriegsmarine;

defaultproperties
{
    MyName="Squad Leader"
    AltName="Gruppenführer"
    Article="a "
    PluralName="Squad Leaders"
    InfoText="Gruppenführer - Difficulty: Very Advanced||The Gruppenführer is the leader of the squad - an NCO by rank.  His job is to see to the completion of the squad's objectives by directing his men in combat and ensuring the LMG's firepower is put to good use.  Equipped for close quarters combat, the Gruppenführer is better off directing the squad's firepower at longer ranges than engaging himself.||* The Gruppenführer counts one and a half times when taking and holding objectives."
    MenuImage=texture'InterfaceArt_tex.SelectMenus.Gruppenfuhrer'
    Models(0)="WK_1"
    Models(1)="WK_2"
    Models(2)="WK_3"
    Models(3)="WK_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineCap'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=2
}
