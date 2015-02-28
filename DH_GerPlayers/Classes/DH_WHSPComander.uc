//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHSPComander extends DH_HeerTankCrew;

defaultproperties
{
    MyName="Assault Gun Commander"
    AltName="Stugführer"
    Article="a "
    PluralName="Assault Gun Commanders"
    MenuImage=texture'DHGermanCharactersTex.Icons.IconSPCom'
    Models(0)="WHSP_1"
    Models(1)="WHSP_2"
    Models(2)="WHSP_3"
    Models(3)="WHSP_4"
    Models(4)="WHSP_5"
    Models(5)="WHSP_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'ROInventory.ROGermanHat'
    Headgear(1)=class'DH_GerPlayers.DH_HeerArtilleryCrushercap'
    RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    bCanBeTankCommander=true
    Limit=1
}
ularsItem"
    Headgear(0)=class'ROInventory.ROGermanHat'
    Headgear(1)=class'DH_GerPlayers.DH_HeerArtilleryCrushercap'
    RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    bCanBeTankCommander=true
    Limit=1
}
