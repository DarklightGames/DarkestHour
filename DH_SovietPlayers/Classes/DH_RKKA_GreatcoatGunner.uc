//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RKKA_GreatcoatGunner extends DH_RKKA_Greatcoat;

defaultproperties
{
    MyName="Machine-gunner"
    AltName="Pulemetchik"
    Article="a "
    PluralName="Machine-gunners"
    PrimaryWeaponType=WT_LMG
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP28Weapon',Amount=1)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietHelmet'
    bIsGunner=true
    bCarriesMGAmmo=false
    limit=2
}
