//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHAntiTank_Snow extends DH_HeerSnow;

defaultproperties
{
    bIsATGunner=true
    MyName="Tank Hunter"
    AltName="Panzerjäger"
    Article="a "
    PluralName="Tank Hunters"
    MenuImage=texture'DHGermanCharactersTex.Icons.Pak-soldat'
    Models(0)="WHS_1"
    Models(1)="WHS_2"
    Models(2)="WHS_3"
    Models(3)="WHS_4"
    Models(4)="WHS_5"
    Models(5)="WHS_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetSnow'
    PrimaryWeaponType=WT_SMG
    Limit=1
}
