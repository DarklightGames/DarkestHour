// *************************************************************************
//
//  ***   WK Rifleman   ***
//
// *************************************************************************

class DH_WKRifleman extends DH_Kriegsmarine;

defaultproperties
{
     MyName="Rifleman"
     AltName="Schütze"
     Article="a "
     PluralName="Riflemen"
     InfoText="Schütze - Difficulty: Medium||The Schütze is the main-stay of the German infantry platoon.  He is tasked with the vital role of taking and holding ground.  Using his standard issue rifle, he can effectively engage the enemy at moderate to long range."
     MenuImage=Texture'InterfaceArt_tex.SelectMenus.Schutze'
     Models(0)="WK_1"
     Models(1)="WK_2"
     Models(2)="WK_3"
     Models(3)="WK_4"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_KriegsmarineHelmet'
}
