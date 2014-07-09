//=============================================================================
// DH_USOfficer29th.
//=============================================================================
class DH_USOfficer29th extends DH_US_29th_Infantry;

defaultproperties
{
     bIsArtilleryOfficer=True
     MyName="Artillery Officer"
     AltName="Artillery Officer"
     Article="an "
     PluralName="Artillery Officers"
     InfoText="The artillery officer is tasked with directing artillery fire upon the battlefield through the use of long-range observation. Coordinating his efforts with a radio operator, he is able to target locations for off-grid artillery to lay down a  barrage with devastating effect."
     menuImage=Texture'DHUSCharactersTex.Icons.IconOf'
     Models(0)="US_29InfOf1"
     Models(1)="US_29InfOf2"
     Models(2)="US_29InfOf3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet29thOfficer'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     limit=1
}
