class DH_BritishReconnaissanceOfficer7th extends DH_British_7thArmouredDivision;

defaultproperties
{
     bCanBeReconCrew=True
     bCanBeReconOfficer=True
     bIsArtilleryOfficer=True
     MyName="Reconnaissance Commander"
     AltName="Reconnaissance Commander"
     Article="a "
     PluralName="Reconnaissance Commanders"
     InfoText="The reconnaissance commander is primarily tasked with the operation of the main gun of the armored car as well as to direct the rest of the operating crew. As the commanding officer of the scouting mission, he is capable of directing his team from within his assigned vehicle as well as while dismounted."
     menuImage=Texture'DHBritishCharactersTex.Icons.Brit_ReconOfficer'
     Models(0)="Brit_Tanker1"
     Models(1)="Brit_Tanker2"
     Models(2)="Brit_Tanker3"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=3)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_ThompsonWeapon',Amount=3)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTankerHat'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     limit=2
}
