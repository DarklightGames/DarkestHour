//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHSquadLeader_Snow extends DH_HeerSnow;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Unteroffizier"
    AltName="Unteroffizier"
    Article="a "
    PluralName="Unteroffiziere"
    MenuImage=texture'DHGermanCharactersTex.Icons.WH_SqL'
    Models(0)="WHS_1"
    Models(1)="WHS_2"
    Models(2)="WHS_3"
    Models(3)="WHS_4"
    Models(4)="WHS_5"
    Models(5)="WHS_6"
    bIsLeader=true
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    Grenades(2)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetSnow'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetCover'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=2
}
