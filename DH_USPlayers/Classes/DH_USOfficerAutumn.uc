//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USOfficerAutumn extends DH_US_Autumn_Infantry;

defaultproperties
{
     bIsArtilleryOfficer=true
     MyName="Artillery Officer"
     AltName="Artillery Officer"
     Article="an "
     PluralName="Artillery Officers"
     InfoText="The artillery officer is tasked with directing artillery fire upon the battlefield through the use of long-range observation. Coordinating his efforts with a radio operator, he is able to target locations for off-grid artillery to lay down a  barrage with devastating effect."
     MenuImage=Texture'DHUSCharactersTex.Icons.IconOf'
     Models(0)="US_AutumnInfOf1"
     Models(1)="US_AutumnInfOf2"
     Models(2)="US_AutumnInfOf3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet1stOfficer'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
}
