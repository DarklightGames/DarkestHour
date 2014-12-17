//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CanadianSergeantRoyalNewBrunswicks extends DH_RoyalNewBrunswicks;

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
    MenuImage=texture'DHCanadianCharactersTex.Icons.Can_Sg'
    Models(0)="RNB_Sarg1"
    Models(1)="RNB_Sarg2"
    Models(2)="RNB_Sarg3"
    bIsLeader=true
    SleeveTexture=texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    Grenades(2)=(Item=class'DH_Equipment.DH_RedSmokeWeapon',Amount=1)
    Headgear(0)=class'DH_BritishPlayers.DH_CanadianInfantryBeretRoyalNewBrunswicks'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=2
}
