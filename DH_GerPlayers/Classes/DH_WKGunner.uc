//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WKGunner extends DH_Kriegsmarine;

defaultproperties
{
     MyName="Machine-gunner"
     AltName="MG-Schütze"
     Article="a "
     PluralName="Machine-gunners"
     InfoText="MG-Schütze - Difficulty: Advanced||Armed with a light machine gun, the MG-Schütze provides the squad with its primary source of firepower.  The LMG can deliver insurmountable damage to the enemy, but careful use is required to avoid overheating or wasting ammunition.  Since the LMG is not a close combat weapon, the MG-Schütze also requires protection from his squad.  With intelligent use, a spotter, and sufficient ammo reserves, the MG-Schütze can keep the enemy at bay almost indefinitely.||Loadout: MG34, P38|* The MG-Schütze can bring the LMG into action more quickly than others as well as handle barrel changes; a leader spotting for him will increase his accuracy."
     MenuImage=Texture'InterfaceArt_tex.SelectMenus.MG-Schutze'
     Models(0)="WK_1"
     Models(1)="WK_2"
     Models(2)="WK_3"
     Models(3)="WK_4"
     bIsGunner=true
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon',Amount=6)
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MG34Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineHelmet'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     Limit=3
}
