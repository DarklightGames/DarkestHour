// *************************************************************************
//
//	***   SS Gunner   ***
//
// *************************************************************************

class DH_12thSSGunner extends DH_12thSS;

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
     MyName="Machine-Gunner"
     AltName="Maschinengewehrschütze"
     Article="a "
     PluralName="Machine-Gunners"
     InfoText="The machine-gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     menuImage=Texture'DHGermanCharactersTex.Icons.WSS_MG'
     Models(0)="12SS_1"
     Models(1)="12SS_2"
     Models(2)="12SS_3"
     Models(3)="12SS_4"
     Models(4)="12SS_5"
     Models(5)="12SS_6"
     bIsGunner=true
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MG42Weapon',Amount=6)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_MG34Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     limit=2
}
