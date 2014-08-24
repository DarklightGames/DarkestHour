//=============================================================================
// DH_BritishAntiTankOx&Bucks
//=============================================================================
class DH_BritishMortarmanOx_Bucks extends DH_Ox_Bucks;

defaultproperties
{
     bCanUseMortars=true
     bCarriesMortarAmmo=false
     MyName="Mortar Operator"
     AltName="Mortar Operator"
     Article="a "
     PluralName="Mortar Operators"
     InfoText="The mortar operator is tasked with providing indirect fire on distant targets using his medium mortar.  The mortar operator should work closely with a mortar observer to accurately bombard targets out of visual range.||* Targets marked by the mortar observer will appear on your situation map.|* Rounds that land near the marked target will appear on your situation map."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_MortarOperator'
     Models(0)="para1"
     Models(1)="para2"
     Models(2)="para3"
     Models(3)="para4"
     Models(4)="para5"
     Models(5)="para6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Mortars.DH_M2MortarWeapon"
     GivenItems(1)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishParaHelmet1'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishParaHelmet2'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishAirborneBeretOx_Bucks'
     Limit=1
}
