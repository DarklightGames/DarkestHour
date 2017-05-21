//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_BritishPlatoonMGRMCommando extends DH_RoyalMarineCommandos;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Machine-Gunner"
    Article="a "
    PluralName="Machine-Gunners"
    bIsGunner=true
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    Limit=1
}
