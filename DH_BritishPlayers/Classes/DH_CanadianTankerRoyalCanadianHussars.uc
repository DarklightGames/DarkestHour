class DH_CanadianTankerRoyalCanadianHussars extends DH_RoyalCanadianHussars;

defaultproperties
{
     MyName="Tank Crewman"
     AltName="Tank Crewman"
     Article="a "
     PluralName="Tank Crewmen"
     InfoText="The tank crewman is a composite role tasked with a variety of operations including  gunner, hull gunner and driver. Each position has a specific view sector out of the tank and is responsible for keeping watch and reporting enemy movements in that direction, as well as performing their primary function."
     MenuImage=Texture'DHCanadianCharactersTex.Icons.Can_TankCrew'
     Models(0)="Can_Tanker1"
     Models(1)="Can_Tanker2"
     Models(2)="Can_Tanker3"
     SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Headgear(0)=Class'DH_BritishPlayers.DH_CanadianTankerBeret'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     bCanBeTankCrew=true
     Limit=3
}
