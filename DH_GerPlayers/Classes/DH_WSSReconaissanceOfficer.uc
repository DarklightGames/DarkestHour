// *************************************************************************
//
//	***   DH_WSSReconaissanceOfficer   ***
//
// *************************************************************************

class DH_WSSReconaissanceOfficer extends DH_WaffenSSTankCrew;

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
     bCanBeReconCrew=true
     bCanBeReconOfficer=true
     bIsArtilleryOfficer=true
     MyName="Reconnaissance Commander"
     AltName="Spähwagenoffizier"
     Article="a "
     PluralName="Reconnaissance Commanders"
     InfoText="The reconnaissance commander is primarily tasked with the operation of the main gun of the armored car as well as to direct the rest of the operating crew. As the commanding officer of the scouting mission, he is capable of directing his team from within his assigned vehicle as well as while dismounted."
     menuImage=Texture'DHGermanCharactersTex.Icons.WH_ReconOfficer'
     Models(0)="SSP_1"
     Models(1)="SSP_2"
     Models(2)="SSP_3"
     Models(3)="SSP_4"
     Models(4)="SSP_5"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     DetachedArmClass=Class'ROEffects.SeveredArmGerTanker'
     DetachedLegClass=Class'ROEffects.SeveredLegGerTanker'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_C96Weapon',Amount=2,AssociatedAttachment=Class'DH_Weapons.DH_C96AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_GerArtyBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_WSSTankerCrushercap'
     Headgear(1)=Class'DH_GerPlayers.DH_SSCap'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=1
}
