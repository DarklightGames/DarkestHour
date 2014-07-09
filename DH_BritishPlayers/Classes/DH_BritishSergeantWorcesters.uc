//=============================================================================
// DH_BritishSquadLeader
//=============================================================================
class DH_BritishSergeantWorcesters extends DH_Worcesters;

function class<ROHeadgear> GetHeadgear()
{
	if (FRand() < 0.5)
		return Headgear[1];
	else
		return Headgear[0];
}

defaultproperties
{
     bIsSquadLeader=True
     MyName="Corporal"
     AltName="Corporal"
     Article="a "
     PluralName="Corporals"
     InfoText="The corporal is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the corporal's presence is an excellent force multiplier to the units under his command."
     Models(0)="Wor_Sarg1"
     Models(1)="Wor_Sarg2"
     Models(2)="Wor_Sarg3"
     bIsLeader=True
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_ThompsonWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Grenades(1)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     Grenades(2)=(Item=Class'DH_Equipment.DH_RedSmokeWeapon',Amount=1)
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishInfantryBeretWorcesters'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     limit=2
}
