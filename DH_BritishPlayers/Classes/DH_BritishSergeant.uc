//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishSergeant extends DH_British_Infantry;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.5)
        return Headgear[1];
    else
        return Headgear[0];
}

defaultproperties
{
     bIsSquadLeader=true
     MyName="Corporal"
     AltName="Corporal"
     Article="a "
     PluralName="Corporals"
     InfoText="The corporal is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the corporal's presence is an excellent force multiplier to the units under his command."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Para_Sg'
     Models(0)="PBI_Sarg1"
     Models(1)="PBI_Sarg2"
     Models(2)="PBI_Sarg3"
     bIsLeader=true
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_ThompsonWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Grenades(1)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     Grenades(2)=(Item=Class'DH_Equipment.DH_RedSmokeWeapon',Amount=1)
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishInfantryBeretHampshires'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=2
}
