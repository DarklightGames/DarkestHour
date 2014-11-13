//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishMortarmanHampshires extends DH_Hampshires;

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
     Models(0)="Hamp_1"
     Models(1)="Hamp_2"
     Models(2)="Hamp_3"
     Models(3)="Hamp_4"
     Models(4)="Hamp_5"
     Models(5)="Hamp_6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
     GivenItems(0)="DH_Mortars.DH_M2MortarWeapon"
     GivenItems(1)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
     Limit=1
}
