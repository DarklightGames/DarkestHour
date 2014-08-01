//=============================================================================
// DH_USPlatoonMG29th.
//=============================================================================
class DH_USPlatoonMG29th extends DH_US_29th_Infantry;

function class<ROHeadgear> GetHeadgear()
{
	if (FRand() < 0.2)
		return Headgear[0];
	else
		return Headgear[1];
}

defaultproperties
{
     MyName="Machine-Gunner"
     AltName="Machine-Gunner"
     Article="a "
     PluralName="Machine-Gunners"
     InfoText="The machine-gunner is tasked with the tactical employment of the medium machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the medium machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     menuImage=Texture'DHUSCharactersTex.Icons.IconPMG'
     Models(0)="US_29Inf1"
     Models(1)="US_29Inf2"
     Models(2)="US_29Inf3"
     Models(3)="US_29Inf4"
     Models(4)="US_29Inf5"
     bIsGunner=true
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_30calWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet29thEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet29thEMb'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     limit=1
}
