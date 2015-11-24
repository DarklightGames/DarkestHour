//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_FJ45Mortarman extends DH_FJ_1945;

defaultproperties
{
    bCanUseMortars=true
    bCarriesMortarAmmo=false
    MyName="Mortar Operator"
    AltName="Werferschütze"
    Article="a "
    PluralName="Mortar Operators"
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_MortarOperator'
    Models(0)="FJ451"
    Models(1)="FJ452"
    Models(2)="FJ453"
    Models(3)="FJ454"
    Models(4)="FJ455"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    GivenItems(0)="DH_Mortars.DH_Kz8cmGrW42Weapon"
    GivenItems(1)="DH_Equipment.DHBinocularsItem"
    HeadgearProbabilities(0)=0.333
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmet1'
    HeadgearProbabilities(1)=0.333
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmet2'
    HeadgearProbabilities(2)=0.334
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet2'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}
