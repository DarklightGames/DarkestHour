//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BritishPlatoonMGRMCommando extends DH_RoyalMarineCommandos;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Machine-Gunner"
    Article="a "
    PluralName="Machine-Gunners"
    Models(0)="RMC1"
    Models(1)="RMC2"
    Models(2)="RMC3"
    Models(3)="RMC4"
    Models(4)="RMC5"
    Models(5)="RMC6"
    bIsGunner=true
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    PrimaryWeaponType=WT_LMG
    Limit=1
}
