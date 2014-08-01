//=============================================================================
// DH_BritishAntiTankOx&Bucks
//=============================================================================
class DH_BritishAntiTankOx_Bucks extends DH_Ox_Bucks;

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
     bIsATGunner=true
     bCarriesATAmmo=false
     MyName="Tank Hunter"
     AltName="Tank Hunter"
     Article="a "
     PluralName="Tank Hunters"
     InfoText="The tank hunter is tasked with locating and destroying or disabling enemy vehicles.  Armed with close-range anti-tank weaponry, he must often get dangerously close to his target in order to assure a hit.  His weaponry can also be effective against enemy fortifications."
     menuImage=Texture'DHBritishCharactersTex.Icons.Para_AT'
     Models(0)="para1"
     Models(1)="para2"
     Models(2)="para3"
     Models(3)="para4"
     Models(4)="para5"
     Models(5)="para6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Grenades(1)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_PIATWeapon"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishParaHelmet1'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishParaHelmet2'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishAirborneBeretOx_Bucks'
     PrimaryWeaponType=WT_SMG
     limit=1
}
