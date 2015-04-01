//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_CanadianRadioOperatorRoyalNewBrunswicks extends DH_RoyalNewBrunswicks;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    MenuImage=texture'DHCanadianCharactersTex.Icons.Can_RadOp'
    Models(0)="RNB_Rad1"
    Models(1)="RNB_Rad2"
    Models(2)="RNB_Rad3"
    SleeveTexture=texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    GivenItems(0)="DH_Equipment.DH_USRadioItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}
