//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BritishSergeantWorcesters extends DH_Worcesters;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_BritishSergeantWorcestersPawn',Weight=1.0)
    MyName="Corporal"
    AltName="Corporal"
    Article="a "
    PluralName="Corporals"
    bIsLeader=true
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_StenMkIIWeapon')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_ThompsonWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Grenades(2)=(Item=class'DH_Equipment.DH_RedSmokeWeapon')
    HeadgearProbabilities(0)=0.5
    Headgear(0)=class'DH_BritishPlayers.DH_BritishInfantryBeretWorcesters'
    HeadgearProbabilities(1)=0.5
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Limit=2
}
