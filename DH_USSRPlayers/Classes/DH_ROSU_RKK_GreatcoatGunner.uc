//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_GreatcoatGunner extends DH_ROSU_RKK_Greatcoat;

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
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_DP28Weapon',Amount=1)
    SecondaryWeapons(0)=(Item=class'DH_ROWeapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietFurHat'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietFurHat'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietHelmet'
    InfoText="The machine-gunner is tasked with the tactical employment of the medium machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the medium machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
    MenuImage=Texture'InterfaceArt_tex.SelectMenus.Pulemetchik'
    bIsGunner=true
    bCarriesMGAmmo=false
    limit=2
}
