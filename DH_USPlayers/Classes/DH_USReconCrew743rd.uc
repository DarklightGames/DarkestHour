class DH_USReconCrew743rd extends DH_US_743rd_TankBattalion;

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
     AltName="Reconnaissance Crewman"
     Article="a "
     PluralName="Reconnaissance Crewmen"
     InfoText="The reconnaissance crewman is tasked with either driving his reconnaissance vehicle or operating its main gun.  In order to be effective, the reconnaissance crewman must be able to forcefully scout enemy territory and accurately relay important information to all team members."
     menuImage=Texture'DHUSCharactersTex.Icons.US_ReconCrew'
     Models(0)="US_743rdT1"
     Models(1)="US_743rdT2"
     Models(2)="US_743rdT3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet'
     Headgear(1)=Class'DH_USPlayers.DH_USTankerHat'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=2
}
