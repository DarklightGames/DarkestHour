//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WHSPCrew extends DH_HeerTankCrew;

defaultproperties
{
    MyName="Assault Gun Crewman"
    AltName="Stugbesatzung"
    Article="a "
    PluralName="Assault Gun Crewmen"
    Models(0)="WHSP_1"
    Models(1)="WHSP_2"
    Models(2)="WHSP_3"
    Models(3)="WHSP_4"
    Models(4)="WHSP_5"
    Models(5)="WHSP_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'ROInventory.ROGermanHat'
    Headgear(1)=class'DH_GerPlayers.DH_HeerCamoCap'
    RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    Limit=3
}
