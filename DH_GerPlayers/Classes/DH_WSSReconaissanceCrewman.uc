// *************************************************************************
//
//	***   DH_WSSReconaissanceCrewman  ***
//
// *************************************************************************

class DH_WSSReconaissanceCrewman extends DH_WaffenSSTankCrew;

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
     Models(0)="SSP_1"
     Models(1)="SSP_2"
     Models(2)="SSP_3"
     Models(3)="SSP_4"
     Models(4)="SSP_5"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     DetachedArmClass=Class'ROEffects.SeveredArmGerTanker'
     DetachedLegClass=Class'ROEffects.SeveredLegGerTanker'
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Headgear(0)=Class'DH_GerPlayers.DH_WSSHatPanzerA'
     Headgear(1)=Class'DH_GerPlayers.DH_WSSHatPanzerB'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=2
}
