//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHGunner_Greatcoat extends DH_HeerGreatcoat;

defaultproperties
{
    MyName="Machine-gunner"
    AltName="Maschinengewehrschütze"
    Article="a "
    PluralName="Machine-gunners"
    bIsGunner=true
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MG34Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    Limit=2
}
