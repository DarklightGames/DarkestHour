//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJ45Mortarman extends DH_FJ_1945;

function class<ROHeadgear> GetHeadgear()
{
    local int RandNum;
    RandNum = Rand(3);

    switch (RandNum)
    {
        case 0:
             return Headgear[0];
        case 1:
             return Headgear[1];
        case 2:
             return Headgear[2];
        default:
             return Headgear[0];
    }
}

defaultproperties
{
    bCanUseMortars=true
    bCarriesMortarAmmo=false
    MyName="Mortar Operator"
    AltName="Werferschütze"
    Article="a "
    PluralName="Mortar Operators"
    InfoText="The mortar operator is tasked with providing indirect fire on distant targets using his medium mortar.  The mortar operator should work closely with a mortar observer to accurately bombard targets out of visual range.||* Targets marked by a mortar observer will appear on your situation map.|* Rounds that land near the marked target will appear on your situation map."
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_MortarOperator'
    Models(0)="FJ451"
    Models(1)="FJ452"
    Models(2)="FJ453"
    Models(3)="FJ454"
    Models(4)="FJ455"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    GivenItems(0)="DH_Mortars.DH_Kz8cmGrW42Weapon"
    GivenItems(1)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmet1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmet2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet2'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}
