//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_CanadianSquadMGRoyalNewBrunswicks extends DH_RoyalNewBrunswicks;

defaultproperties
{
    MyName="Light Machine-Gunner"
    AltName="Light Machine-Gunner"
    Article="a "
    PluralName="Light Machine-Gunners"
    Models(0)="RNB_1"
    Models(1)="RNB_2"
    Models(2)="RNB_3"
    Models(3)="RNB_4"
    Models(4)="RNB_5"
    Models(5)="RNB_6"
    bIsGunner=true
    SleeveTexture=texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_BrenWeapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    PrimaryWeaponType=WT_LMG
    Limit=3
}
