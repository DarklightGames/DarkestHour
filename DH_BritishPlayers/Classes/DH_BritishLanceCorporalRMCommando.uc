//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BritishLanceCorporalRMCommando extends DH_RoyalMarineCommandos;

defaultproperties
{
    MyName="Lance Corporal"
    AltName="Lance Corporal"
    Article="a "
    PluralName="Lance Corporals"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_StenMkIIWeapon')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_ThompsonWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    Limit=2
}
