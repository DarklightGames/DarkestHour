//=============================================================================
// DH_BritishPlatoonMG
//=============================================================================
class DH_BritishPlatoonMGWorcesters extends DH_Worcesters;

function class<ROHeadgear> GetHeadgear()
{
	if (FRand() < 0.2)
	{
		if (FRand() < 0.5)
			return Headgear[2];
		else
			return Headgear[1];
	}
	else
	{
		return Headgear[0];
	}
}

defaultproperties
{
     MyName="Machine-Gunner"
     AltName="Machine-Gunner"
     Article="a "
     PluralName="Machine-Gunners"
     InfoText="The machine-gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     menuImage=Texture'DHBritishCharactersTex.Icons.Brit_PMG'
     Models(0)="Wor_1"
     Models(1)="Wor_2"
     Models(2)="Wor_3"
     Models(3)="Wor_4"
     Models(4)="Wor_5"
     Models(5)="Wor_6"
     bIsGunner=True
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_30calWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishTommyHelmet'
     bCarriesMGAmmo=False
     PrimaryWeaponType=WT_LMG
     limit=1
}
