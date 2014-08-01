// *************************************************************************
//
//	***   WH SP Crew   ***
//
// *************************************************************************

class DH_WHSPCrew extends DH_HeerTankCrew;

function class<ROHeadgear> GetHeadgear()
{
	if (FRand() < 0.2)
	{
		return Headgear[0];
	}
	else
	{
		return Headgear[1];
	}
}

defaultproperties
{
     MyName="Assault Gun Crewman"
     AltName="Stugbesatzung"
     Article="a "
     PluralName="Assault Gun Crewmen"
     InfoText="Stugbesatzung||The assault gun crew consists of variations on gunner, loader, hull gunner/radio operator and the driver. Each is a specialized role, requiring specialized training. Each has a specific view sector out of the vehicle and is responsible for keeping watch in that direction, as well as performing their primary function."
     menuImage=Texture'DHGermanCharactersTex.Icons.IconSPCrew'
     Models(0)="WHSP_1"
     Models(1)="WHSP_2"
     Models(2)="WHSP_3"
     Models(3)="WHSP_4"
     Models(4)="WHSP_5"
     Models(5)="WHSP_6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     DetachedArmClass=Class'ROEffects.SeveredArmGerTanker'
     DetachedLegClass=Class'ROEffects.SeveredLegGerTanker'
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Headgear(0)=Class'ROInventory.ROGermanHat'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerCamoCap'
     RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     bCanBeTankCrew=true
     limit=3
}
