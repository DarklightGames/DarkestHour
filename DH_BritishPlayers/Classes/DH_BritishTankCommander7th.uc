class DH_BritishTankCommander7th extends DH_British_7thArmouredDivision;

defaultproperties
{
     MyName="Tank Commander"
     AltName="Tank Commander"
     Article="a "
     PluralName="Tank Commanders"
     InfoText="The tank commander is primarily tasked with the operation of the main gun of the tank as well as to direct the rest of the operating crew. From his usual turret position, he is often the only crew member with an all-round view. As a commander, he is expected to lead a complete platoon of tanks as well as direct his own."
     menuImage=Texture'DHBritishCharactersTex.Icons.Brit_TankCom'
     Models(0)="Brit_Tanker1"
     Models(1)="Brit_Tanker2"
     Models(2)="Brit_Tanker3"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=3)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_ThompsonWeapon',Amount=3)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTankerHat'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     bCanBeTankCrew=True
     bCanBeTankCommander=True
     limit=1
}
