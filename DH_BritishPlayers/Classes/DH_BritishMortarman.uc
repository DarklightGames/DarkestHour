//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BritishMortarman extends DH_British_Infantry;

defaultproperties
{
    bCanUseMortars=true
    bCarriesMortarAmmo=false
    MyName="Mortar Operator"
    AltName="Mortar Operator"
    Article="a "
    PluralName="Mortar Operators"
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_MortarOperator'
    Models(0)="PBI_1"
    Models(1)="PBI_2"
    Models(2)="PBI_3"
    Models(3)="PBI_4"
    Models(4)="PBI_5"
    Models(5)="PBI_6"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    GivenItems(0)="DH_Mortars.DH_M2MortarWeapon"
    GivenItems(1)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    Limit=1
}
