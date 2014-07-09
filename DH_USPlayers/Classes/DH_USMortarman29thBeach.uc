//=============================================================================
// DH_USMortarman29th.
//=============================================================================
class DH_USMortarman29thBeach extends DH_US_29th_Infantry;

function class<ROHeadgear> GetHeadgear()
{
	if (FRand() < 0.2)
		return Headgear[0];
	else
		return Headgear[1];
}

defaultproperties
{
     bCanUseMortars=True
     bCarriesMortarAmmo=False
     MyName="Mortar Operator"
     AltName="Mortar Operator"
     Article="a "
     PluralName="Mortar Operators"
     InfoText="The mortar operator is tasked with providing indirect fire on distant targets using his medium mortar.  The mortar operator should work closely with a mortar observer to accurately bombard targets out of visual range.||* Targets marked by a mortar observer will appear on your situation map.|* Rounds that land near the marked target will appear on your situation map."
     menuImage=Texture'DHUSCharactersTex.Icons.IconMortarOperator'
     Models(0)="US_29Inf1B"
     Models(1)="US_29Inf2B"
     Models(2)="US_29Inf3B"
     Models(3)="US_29Inf4B"
     Models(4)="US_29Inf5B"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     GivenItems(0)="DH_Mortars.DH_M2MortarWeapon"
     GivenItems(1)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet29thEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet29thEMb'
     PrimaryWeaponType=WT_SemiAuto
     limit=1
}
