//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CanadianTankCommanderRoyalCanadianHussars extends DH_RoyalCanadianHussars;

defaultproperties
{
     MyName="Tank Commander"
     AltName="Tank Commander"
     Article="a "
     PluralName="Tank Commanders"
     InfoText="The tank commander is primarily tasked with the operation of the main gun of the tank as well as to direct the rest of the operating crew. From his usual turret position, he is often the only crew member with an all-round view. As a commander, he is expected to lead a complete platoon of tanks as well as direct his own."
     MenuImage=Texture'DHCanadianCharactersTex.Icons.Can_TankCom'
     Models(0)="Can_Tanker1"
     Models(1)="Can_Tanker2"
     Models(2)="Can_Tanker3"
     SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=3)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_CanadianTankerHat'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     bCanBeTankCrew=true
     bCanBeTankCommander=true
     Limit=1
}
