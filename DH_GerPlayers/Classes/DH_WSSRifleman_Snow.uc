//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSRifleman_Snow extends DH_WaffenSSSnow;

defaultproperties
{
    MyName="Rifleman"
    AltName="Schütze"
    Article="a "
    PluralName="Riflemen"
    Models(0)="SSS_1"
    Models(1)="SSS_2"
    Models(2)="SSS_3"
    Models(3)="SSS_4"
    Models(4)="SSS_5"
    Models(5)="SSS_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetSnow'
}
