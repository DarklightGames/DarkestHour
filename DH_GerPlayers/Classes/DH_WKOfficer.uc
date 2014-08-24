// *************************************************************************
//
//  ***   WK Officer   ***
//
// *************************************************************************

class DH_WKOfficer extends DH_Kriegsmarine;

defaultproperties
{
     bIsArtilleryOfficer=true
     MyName="Officer"
     AltName="Zugführer"
     Article="a "
     PluralName="Officers"
     InfoText="Zugführer - Difficulty: Very Advanced||The Zugführer is the Platoon leader. Although equipped for close quarters combat, the Zugführer is better off directing his squads to their objectives than engaging the enemy himself.||* The Zugführer counts one and a half times when taking and holding objectives."
     menuImage=Texture'DHGermanCharactersTex.Icons.Zugfuhrer'
     Models(0)="WK_1"
     Models(1)="WK_2"
     Models(2)="WK_3"
     Models(3)="WK_4"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=2)
     Grenades(1)=(Item=Class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_GerMortarBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_KriegsmarineCap'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=1
}
