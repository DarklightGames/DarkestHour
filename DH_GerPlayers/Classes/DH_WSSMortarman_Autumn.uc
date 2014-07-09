// *************************************************************************
//
//	***   SS Mortarman ***
//
// *************************************************************************

class DH_WSSMortarman_Autumn extends DH_WaffenSSAutumn;

function class<ROHeadgear> GetHeadgear()
{
	if (FRand() < 0.2)
	{
		return Headgear[0];
	}
	else
	{
		return Headgear[1];
	}
}

defaultproperties
{
     bCanUseMortars=True
     bCarriesMortarAmmo=False
     MyName="Mortar Operator"
     AltName="Werferschütze"
     Article="a "
     PluralName="Mortar Operators"
     InfoText="The mortar operator is tasked with providing indirect fire on distant targets using his medium mortar.  The mortar operator should work closely with a mortar observer to accurately bombard targets out of visual range.||* Targets marked by the mortar observer will appear on your situation map.|* Rounds that land near the marked target will appear on your situation map."
     menuImage=Texture'DHGermanCharactersTex.Icons.WSS_MortarOperator'
     Models(0)="SSA_1"
     Models(1)="SSA_2"
     Models(2)="SSA_3"
     Models(3)="SSA_4"
     Models(4)="SSA_5"
     Models(5)="SSA_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     GivenItems(0)="DH_Mortars.DH_Kz8cmGrW42Weapon"
     GivenItems(1)="DH_Equipment.DH_GerBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetNoCover'
     limit=1
}
