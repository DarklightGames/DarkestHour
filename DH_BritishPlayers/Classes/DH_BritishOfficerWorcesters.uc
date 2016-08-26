//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BritishOfficerWorcesters extends DH_Worcesters;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Artillery Officer"
    AltName="Artillery Officer"
    Article="an "
    PluralName="Artillery Officers"
    Models(0)="Wor_Of1"
    Models(1)="Wor_Of2"
    Models(2)="Wor_Of3"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
}
