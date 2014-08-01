// *************************************************************************
//
//	***   DH_WHReconaissanceCrewman   ***
//
// *************************************************************************

class DH_WHReconaissanceCrewman extends DH_HeerTankCrew;

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
     bCanBeReconCrew=true
     MyName="Reconnaissance Crewman"
     AltName="Spähwagenbesatzung"
     Article="a "
     PluralName="Reconnaissance Crewmen"
     InfoText="The reconnaissance crewman is tasked with either driving his reconnaissance vehicle or operating its main gun.  In order to be effective, the reconnaissance crewman must be able to forcefully scout enemy territory and accurately relay important information to all team members."
     menuImage=Texture'DHGermanCharactersTex.Icons.WH_ReconCrewman'
     Models(0)="WHP_1"
     Models(1)="WHP_2"
     Models(2)="WHP_3"
     Models(3)="WHP_4"
     Models(4)="WHP_5"
     Models(5)="WHP_6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.GermanTankerSleeves'
     DetachedArmClass=Class'ROEffects.SeveredArmGerTanker'
     DetachedLegClass=Class'ROEffects.SeveredLegGerTanker'
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerTankerCap'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerCamoCap'
     RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=2
}
