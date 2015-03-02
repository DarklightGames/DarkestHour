//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BritishOfficerRMCommando extends DH_RoyalMarineCommandos;

defaultproperties
{
    bIsArtilleryOfficer=true
    MyName="Artillery Officer"
    AltName="Artillery Officer"
    Article="an "
    PluralName="Artillery Officers"
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_Off'
    Models(0)="RMCOf1"
    Models(1)="RMCOf2"
    Models(2)="RMCOf3"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
}
