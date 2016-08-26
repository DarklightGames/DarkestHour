//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHFireteamLeader_Autumn extends DH_HeerAutumn;

defaultproperties
{
    MyName="Corporal"
    AltName="Gefreiter"
    Article="a "
    PluralName="Corporals"
    Models(0)="WHAu_1"
    Models(1)="WHAu_2"
    Models(2)="WHAu_3"
    Models(3)="WHAu_4"
    Models(4)="WHAu_5"
    Models(5)="WHAu_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetNoCover'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
    Limit33to44=2
    LimitOver44=2
}
