//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHTanker extends DH_HeerTankCrew;

defaultproperties
{
    MyName="Tank Crewman"
    AltName="Panzerbesatzung"
    Article="a "
    PluralName="Tank Crewmen"
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
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_HeerTankerCap'
    Headgear(1)=class'DH_GerPlayers.DH_HeerCamoCap'
    RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    Limit=3
}
