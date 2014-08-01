class DH_USReconOfficer743rd extends DH_US_743rd_TankBattalion;

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
     menuImage=Texture'DHUSCharactersTex.Icons.US_ReconOfficer'
     Models(0)="US_743rdT1"
     Models(1)="US_743rdT2"
     Models(2)="US_743rdT3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_GreaseGunWeapon',Amount=3)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_ThompsonWeapon',Amount=3)
     PrimaryWeapons(2)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=Class'DH_USPlayers.DH_USTankerHat'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=1
}
