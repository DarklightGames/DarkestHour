//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RKKA_GreenTelogreikaGunner extends DH_RKKA_GreenTelogreika;

defaultproperties
{
    MyName="Machine-gunner"
    AltName="Pulemetchik"
    Article="a "
    PluralName="Machine-gunners"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP28Weapon',Amount=1)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietSidecap'
    bIsGunner=true
    bCarriesMGAmmo=false
    Limit=2
}
