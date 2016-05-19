//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSGunner_Snow extends DH_WaffenSSSnow;

defaultproperties
{
    MyName="Maschinengewehrschütze"
    AltName="Maschinengewehrschütze"
    Article="a "
    PluralName="Maschinengewehrschützen"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_MG'
    Models(0)="SSS_1"
    Models(1)="SSS_2"
    Models(2)="SSS_3"
    Models(3)="SSS_4"
    Models(4)="SSS_5"
    Models(5)="SSS_6"
    bIsGunner=true
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MG34Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetSnow'
    PrimaryWeaponType=WT_LMG
    Limit=2
}
