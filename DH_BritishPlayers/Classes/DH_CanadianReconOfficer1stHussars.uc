class DH_CanadianReconOfficer1stHussars extends DH_1stHussars;

defaultproperties
{
     bCanBeReconCrew=true
     bCanBeReconOfficer=true
     bIsArtilleryOfficer=true
     MyName="Reconnaissance Commander"
     AltName="Reconnaissance Commander"
     Article="a "
     PluralName="Reconnaissance Commanders"
     InfoText="The reconnaissance commander is primarily tasked with the operation of the main gun of the armored car as well as to direct the rest of the operating crew. As the commanding officer of the scouting mission, he is capable of directing his team from within his assigned vehicle as well as while dismounted."
     MenuImage=Texture'DHCanadianCharactersTex.Icons.Can_ReconOfficer'
     Models(0)="Can_1stH1"
     Models(1)="Can_1stH2"
     Models(2)="Can_1stH3"
     SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=3)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_ThompsonWeapon',Amount=3)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_CanadianTankerHat'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
}
