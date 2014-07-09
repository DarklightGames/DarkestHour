//=============================================================================
// DH_USSquadLeader29th.
//=============================================================================
class DH_USSergeant29th extends DH_US_29th_Infantry;


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
     bIsSquadLeader=True
     MyName="Sergeant"
     AltName="Sergeant"
     Article="a "
     PluralName="Sergeants"
     InfoText="The sergeant is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the sergeant's presence is an excellent force multiplier to the units under his command."
     menuImage=Texture'DHUSCharactersTex.Icons.IconSg'
     Models(0)="US_29InfSarg1"
     Models(1)="US_29InfSarg2"
     Models(2)="US_29InfSarg3"
     bIsLeader=True
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_ThompsonWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_GreaseGunWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     Grenades(1)=(Item=Class'DH_Equipment.DH_RedSmokeWeapon',Amount=1)
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet29thNCOa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet29thNCOb'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     limit=2
}
