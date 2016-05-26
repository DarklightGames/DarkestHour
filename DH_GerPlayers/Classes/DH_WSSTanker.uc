//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSTanker extends DH_WaffenSSTankCrew;

defaultproperties
{
    MyName="Tank Crewman"
    AltName="Panzerbesatzung"
    Article="a "
    PluralName="Tank Crewmen"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_TankCrew'
    Models(0)="SSP_1"
    Models(1)="SSP_2"
    Models(2)="SSP_3"
    Models(3)="SSP_4"
    Models(4)="SSP_5"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_C96Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_WSSHatPanzerA'
    Headgear(1)=class'DH_GerPlayers.DH_WSSHatPanzerB'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    Limit=3
}
