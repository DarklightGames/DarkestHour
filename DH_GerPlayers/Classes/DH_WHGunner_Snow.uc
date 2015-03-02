//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHGunner_Snow extends DH_HeerSnow;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Maschinengewehrschütze"
    Article="a "
    PluralName="Machine-Gunners"
    MenuImage=texture'InterfaceArt_tex.SelectMenus.MG-Schutze'
    Models(0)="WHS_1"
    Models(1)="WHS_2"
    Models(2)="WHS_3"
    Models(3)="WHS_4"
    Models(4)="WHS_5"
    Models(5)="WHS_6"
    bIsGunner=true
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon',Amount=6)
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MG34Weapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetSnow'
    bCarriesMGAmmo=false
    PrimaryWeaponType=WT_LMG
    Limit=2
}
