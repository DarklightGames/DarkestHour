//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USTankCommander743rd extends DH_US_743rd_TankBattalion;

defaultproperties
{
     MyName="Tank Commander"
     AltName="Tank Commander"
     Article="a "
     PluralName="Tank Commanders"
     InfoText="The tank commander is primarily tasked with the operation of the main gun of the tank as well as to direct the rest of the operating crew. From his usual turret position, he is often the only crew member with an all-round view. As a commander, he is expected to lead a complete platoon of tanks as well as direct his own."
     MenuImage=Texture'DHUSCharactersTex.Icons.IconTCom'
     Models(0)="US_743rdT1"
     Models(1)="US_743rdT2"
     Models(2)="US_743rdT3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_ThompsonWeapon',Amount=3)
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',Amount=3)
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=class'DH_USPlayers.DH_USTankerHat'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     bCanBeTankCrew=true
     bCanBeTankCommander=true
     Limit=1
}
