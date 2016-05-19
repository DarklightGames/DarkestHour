//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHTanker extends DH_HeerTankCrew;

defaultproperties
{
    MyName="Panzerbesatzung"
    AltName="Panzerbesatzung"
    Article="a "
    PluralName="Panzerbesatzungen"
    MenuImage=texture'InterfaceArt_tex.SelectMenus.Panzerbezatsung'
    Models(0)="WHP_1"
    Models(1)="WHP_2"
    Models(2)="WHP_3"
    Models(3)="WHP_4"
    Models(4)="WHP_5"
    Models(5)="WHP_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.GermanTankerSleeves'
    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerTankerCap'
    Headgear(1)=class'DH_GerPlayers.DH_HeerCamoCap'
    RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    Limit=3
}
