//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BritishPlatoonMG extends DH_British_Infantry;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Machine-Gunner"
    Article="a "
    PluralName="Machine-Gunners"
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_PMG'
    Models(0)="PBI_1"
    Models(1)="PBI_2"
    Models(2)="PBI_3"
    Models(3)="PBI_4"
    Models(4)="PBI_5"
    Models(5)="PBI_6"
    bIsGunner=true
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    PrimaryWeaponType=WT_LMG
    Limit=1
}
