//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USMortarman506101st extends DH_US_506PIR;

defaultproperties
{
    bCanUseMortars=true
    bCarriesMortarAmmo=false
    MyName="Mortar Operator"
    AltName="Mortar Operator"
    Article="a "
    PluralName="Mortar Operators"
    InfoText="The mortar operator is tasked with providing indirect fire on distant targets using his medium mortar.  The mortar operator should work closely with a mortar observer to accurately bombard targets out of visual range.||* Targets marked by a mortar observer will appear on your situation map.|* Rounds that land near the marked target will appear on your situation map."
    MenuImage=texture'DHUSCharactersTex.Icons.ABMortarOperator'
    Models(0)="US_506101AB1"
    Models(1)="US_506101AB2"
    Models(2)="US_506101AB3"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    GivenItems(0)="DH_Mortars.DH_M2MortarWeapon"
    GivenItems(1)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet506101stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet506101stEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}
