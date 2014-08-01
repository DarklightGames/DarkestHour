//=============================================================================
// DH_USOfficer3rd
//=============================================================================
class DH_USOfficer3rd extends DH_US_3rd_Infantry;

defaultproperties
{
     bIsArtilleryOfficer=true
     MyName="Artillery Officer"
     AltName="Artillery Officer"
     Article="an "
     PluralName="Artillery Officers"
     InfoText="The artillery officer is tasked with directing artillery fire upon the battlefield through the use of long-range observation. Coordinating his efforts with a radio operator, he is able to target locations for off-grid artillery to lay down a  barrage with devastating effect."
     menuImage=Texture'DHUSCharactersTex.Icons.IconOf'
     Models(0)="US_3InfOf1"
     Models(1)="US_3InfOf2"
     Models(2)="US_3InfOf3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet3rdOfficer'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=1
}
