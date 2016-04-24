//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHGunner_Autumn extends DH_HeerAutumn;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Maschinengewehrschütze"
    Article="a "
    PluralName="Machine-Gunners"
    MenuImage=texture'InterfaceArt_tex.SelectMenus.MG-Schutze'
    Models(0)="WHAu_1"
    Models(1)="WHAu_2"
    Models(2)="WHAu_3"
    Models(3)="WHAu_4"
    Models(4)="WHAu_5"
    Models(5)="WHAu_6"
    bIsGunner=true
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.SplinterASleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MG34Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetCover'
    PrimaryWeaponType=WT_LMG
    Limit=2
}
