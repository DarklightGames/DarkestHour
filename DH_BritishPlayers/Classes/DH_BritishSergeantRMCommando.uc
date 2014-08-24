//=============================================================================
// DH_BritishSquadLeaderRMCommando
//=============================================================================
class DH_BritishSergeantRMCommando extends DH_RoyalMarineCommandos;

defaultproperties
{
     bIsSquadLeader=true
     MyName="Corporal"
     AltName="Corporal"
     Article="a "
     PluralName="Corporals"
     InfoText="The corporal is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the corporal's presence is an excellent force multiplier to the units under his command."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_Sg'
     Models(0)="RMCSarg1"
     Models(1)="RMCSarg2"
     Models(2)="RMCSarg3"
     bIsLeader=true
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Grenades(1)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     Grenades(2)=(Item=Class'DH_Equipment.DH_RedSmokeWeapon',Amount=1)
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=2
}
