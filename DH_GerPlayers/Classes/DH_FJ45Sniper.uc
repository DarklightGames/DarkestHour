//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJ45Sniper extends DH_FJ_1945;

defaultproperties
{
    MyName="Sniper"
    AltName="Scharfschütze"
    Article="a "
    PluralName="Snipers"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98ScopedWeapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43ScopedWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmet2'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetNet2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    Limit=2
}
