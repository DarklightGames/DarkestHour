//=============================================================================
// DH_CanadianOfficer
//=============================================================================
class DH_CanadianOfficerRoyalNewBrunswicks extends DH_RoyalNewBrunswicks;

defaultproperties
{
     bIsArtilleryOfficer=true
     MyName="Artillery Officer"
     AltName="Artillery Officer"
     Article="a "
     PluralName="Artillery Officers"
     InfoText="The artillery officer is tasked with directing artillery fire upon the battlefield through the use of long-range observation. Coordinating his efforts with a radio operator, he is able to target locations for off-grid artillery to lay down a  barrage with devastating effect."
     MenuImage=Texture'DHCanadianCharactersTex.Icons.Can_Off'
     Models(0)="RNB_Of1"
     Models(1)="RNB_Of2"
     Models(2)="RNB_Of3"
     SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTommyHelmet'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
}
