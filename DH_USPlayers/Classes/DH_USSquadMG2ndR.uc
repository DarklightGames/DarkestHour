//=============================================================================
// DH_USSquadMG2ndR
//=============================================================================
class DH_USSquadMG2ndR extends DH_US_2ndRangersBattalion;


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
     MyName="Squad Machine-Gunner"
     AltName="Squad Machine-Gunner"
     Article="a "
     PluralName="Squad Machine-Gunners"
     InfoText="The squad machine-gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     menuImage=Texture'DHUSCharactersTex.Icons.IconSMG'
     Models(0)="US_2R1"
     Models(1)="US_2R2"
     Models(2)="US_2R3"
     Models(3)="US_2R4"
     Models(4)="US_2R5"
     bIsGunner=True
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_BARWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet2ndREMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet2ndREMb'
     bCarriesMGAmmo=False
     PrimaryWeaponType=WT_SMG
     limit=2
}
