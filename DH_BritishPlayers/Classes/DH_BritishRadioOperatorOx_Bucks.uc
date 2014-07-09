//=============================================================================
// DH_BritishRadioOperatorOx&Bucks
//=============================================================================
class DH_BritishRadioOperatorOx_Bucks extends DH_Ox_Bucks;

defaultproperties
{
     MyName="Radio Operator"
     AltName="Radio Operator"
     Article="a "
     PluralName="Radio Operators"
     InfoText="The radio operator carries a man-packed radio and is tasked with the role of calling in artillery strikes towards targets designated by the artillery officer. Effective communication between the radio operator and the artillery officer is critical to the success of a coordinated barrage."
     menuImage=Texture'DHBritishCharactersTex.Icons.Para_RadOp'
     Models(0)="paraRad1"
     Models(1)="paraRad2"
     Models(2)="paraRad3"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_BritishRadioItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishAirborneBeretOx_Bucks'
     PrimaryWeaponType=WT_SMG
     limit=1
}
