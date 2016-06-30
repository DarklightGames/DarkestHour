//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROGEGunnerGreatH extends DH_ROGE_Heer_Greatcoat;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        return Headgear[0];

    else
    {
        return Headgear[1];
    }
}

defaultproperties
{
    MyName="Machine-gunner"
    AltName="Maschinengewehrschütze"
    Article="a "
    PluralName="Machine-gunners"
    InfoText="The machine-gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
    menuImage=Texture'InterfaceArt_tex.SelectMenus.MG-Schutze'
    bIsGunner=True
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    //PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon',Amount=6)
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MG34Weapon',Amount=6)
    SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
    PrimaryWeaponType=WT_LMG
    limit=2
    bCarriesMGAmmo=false
}
