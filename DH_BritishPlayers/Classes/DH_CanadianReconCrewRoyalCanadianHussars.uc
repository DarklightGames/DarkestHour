class DH_CanadianReconCrewRoyalCanadianHussars extends DH_RoyalCanadianHussars;

defaultproperties
{
     bCanBeReconCrew=true
     MyName="Reconnaissance Crewman"
     AltName="Reconnaissance Crewman"
     Article="a "
     PluralName="Reconnaissance Crewmen"
     InfoText="The reconnaissance crewman is tasked with either driving his reconnaissance vehicle or operating its main gun.  In order to be effective, the reconnaissance crewman must be able to forcefully scout enemy territory and accurately relay important information to all team members."
     MenuImage=Texture'DHCanadianCharactersTex.Icons.Can_ReconCrew'
     Models(0)="Can_Tanker1"
     Models(1)="Can_Tanker2"
     Models(2)="Can_Tanker3"
     SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_CanadianTankerBeret'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=2
}
