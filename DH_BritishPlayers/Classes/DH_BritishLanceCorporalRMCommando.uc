//=============================================================================
// DH_BritishLanceCorporalRMCommando
//=============================================================================
class DH_BritishLanceCorporalRMCommando extends DH_RoyalMarineCommandos;

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
     MyName="Lance Corporal"
     AltName="Lance Corporal"
     Article="a "
     PluralName="Lance Corporals"
     InfoText="The lance corporal is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
     menuImage=Texture'DHBritishCharactersTex.Icons.Brit_LanceCorporal'
     Models(0)="RMC1"
     Models(1)="RMC2"
     Models(2)="RMC3"
     Models(3)="RMC4"
     Models(4)="RMC5"
     Models(5)="RMC6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_ThompsonWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=1)
     Grenades(1)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
     limit=2
}
