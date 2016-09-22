//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BritishSquadMGHampshires extends DH_Hampshires;

defaultproperties
{
    MyName="Light Machine-Gunner"
    AltName="Light Machine-Gunner"
    Article="a "
    PluralName="Light Machine-Gunners"
    bIsGunner=true
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_BrenWeapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    Limit=3
}
