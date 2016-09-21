//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RKKA_StandardGunner extends DH_RKKA_Standard;

defaultproperties
{
    MyName="Machine-gunner"
    AltName="Pulemetchik"
    Article="a "
    PluralName="Machine-gunners"
    PrimaryWeaponType=WT_LMG
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP28Weapon',Amount=1)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietHelmet'
    bIsGunner=true
    bCarriesMGAmmo=false
    Limit=2
}
