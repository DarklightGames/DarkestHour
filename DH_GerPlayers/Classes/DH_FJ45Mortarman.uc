//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJ45Mortarman extends DH_FJ_1945;

defaultproperties
{
    bCanUseMortars=true
    MyName="Mortar Operator"
    AltName="Werferschütze"
    Article="a "
    PluralName="Mortar Operators"

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
    Limit=1
}
