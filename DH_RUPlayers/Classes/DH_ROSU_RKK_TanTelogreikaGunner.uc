//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_TanTelogreikaGunner extends DH_ROSU_RKK_TanTelogreika;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        return Headgear[1];
    }
    else
    {
        return Headgear[0];
    }
}

defaultproperties
{
    MyName="Machine-gunner"
    AltName="Pulemetchik"
    Article="a "
    PluralName="Machine-gunners"
    PrimaryWeaponType=WT_LMG
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP28Weapon',Amount=1)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'DH_RUPlayers.DH_ROSovietSidecap'
    Headgear(1)=class'DH_RUPlayers.DH_ROSovietHelmet'
    Headgear(2)=class'DH_RUPlayers.DH_ROSovietHelmet'
    bIsGunner=true
    bCarriesMGAmmo=false
    limit=2
}
