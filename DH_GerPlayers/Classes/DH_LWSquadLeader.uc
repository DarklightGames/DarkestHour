//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_LWSquadLeader extends DH_LuftwaffeFlak;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Squad Leader"
    AltName="Gruppenführer"
    Article="a "
    PluralName="Squad Leaders"
    MenuImage=texture'InterfaceArt_tex.SelectMenus.Gruppenfuhrer'
    Models(0)="WL_1"
    Models(1)="WL_2"
    Models(2)="WL_3"
    Models(3)="WL_4"
    bIsLeader=true
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Grenades(2)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_LWHelmet'
    Headgear(1)=class'DH_GerPlayers.DH_LWHelmetTwo'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=2
}
