class DH_BritishReconnaissance7th extends DH_British_7thArmouredDivision;

defaultproperties
{
     bCanBeReconCrew=True
     MyName="Reconnaissance Crewman"
     AltName="Reconnaissance Crewman"
     Article="a "
     PluralName="Reconnaissance Crewmen"
     InfoText="The reconnaissance crewman is tasked with either driving his reconnaissance vehicle or operating its main gun.  In order to be effective, the reconnaissance crewman must be able to forcefully scout enemy territory and accurately relay important information to all team members."
     menuImage=Texture'DHBritishCharactersTex.Icons.Brit_ReconCrew'
     Models(0)="Brit_Tanker1"
     Models(1)="Brit_Tanker2"
     Models(2)="Brit_Tanker3"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTankerBeret'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     limit=2
}
