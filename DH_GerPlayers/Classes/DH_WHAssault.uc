//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHAssault extends DH_Heer;

defaultproperties
{
    MyName="Assault Trooper"
    AltName="Stoﬂtruppe"
    Article="an "
    PluralName="Assault Troopers"
    MenuImage=texture'InterfaceArt_tex.SelectMenus.Stosstruppe'
    Models(0)="WH_1"
    Models(1)="WH_2"
    Models(2)="WH_3"
    Models(3)="WH_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=4
}
